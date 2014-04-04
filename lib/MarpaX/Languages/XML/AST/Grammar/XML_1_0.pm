use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0;
use MarpaX::Languages::XML::AST::StreamIn;
use MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util qw/:all/;
use MarpaX::Languages::XML::AST::Util qw/:all/;
use Carp qw/croak/;
use Marpa::R2 2.082000;
use Log::Any qw/$log/;
use MarpaX::Languages::XML::AST::R;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) written in Marpa BNF

# VERSION

our $DATA = do {local $/; <DATA>};

# -----------------------------------------------------------
# Keep track of recursion using STAG_END and ETAG_END lexemes
# -----------------------------------------------------------
our %LEXEME_LEVEL = (STAG_END => 1,
		     ETAG_END => -1);

# --------------------------------------------------------------------
# There are several DIFFERENT top-level productions in the XML grammar
# --------------------------------------------------------------------
our %G = ();
foreach (qw/document/) {
  my $top = $_;
  $DATA =~ s/(:start\s*::=\s*)(.*)/$1$top/g;
  print STDERR "Compiling $top production\n";
  $G{$top} = Marpa::R2::Scanless::G->new({source => \$DATA, bless_package => 'XML'});
}

# ----------------------------------------------------------------
# We always work with a single buffer, and handle eventual overlap
# by appending to current buffer before discarding it
# ----------------------------------------------------------------
sub new {
  my ($class, %opts) = @_;

  my $self = {buf => undef, mapbeg => 0, origmapend => 0, mapend => 0, lastBufNo => 0};

  bless($self, $class);

  return $self;
}

# -------------------------------------------------
# For performance, everything is done one the stack
# This routine eventually discard a buffer
# -------------------------------------------------
sub _donePos {
    # my ($self, $stream, $pos) = @_;

    # $log->tracef('_donePos %d', $_[2]);

    if ($_[2] >= $_[0]->{origmapend}) {
	#
	# Current buffer, eventually appended with content of next
	# buffer(s), is over
	#
        my $mapend;
        while (defined($mapend = $_[1]->mapend(0))) {
          if ($_[2] >= $mapend) {
            $_[1]->doneb(0);
          } else {
            last;
          }
        }
	#
	# Assigning mapend to zero is enough for us
	# to know nothing else is cached
	#
	$_[0]->{buf} = undef;
	$_[0]->{mapbeg} = 0;
	$_[0]->{mapend} = 0;
	$_[0]->{origmapend} = 0;
	$_[0]->{lastBufNo} = 0;
    }
}

#
# _isPos is functionally equivalent to _canPos, but prevent an
# unnecessary call to pos(). _isPos() should be called ONLY after
# a successful m//g or after a _canPos.
#
sub _isPos {
    # my ($self, $stream, $pos) = @_;

    if ($_[2] < $_[0]->{mapend}) {
	#
	# Current buffer. pos($self->{buf}) ASSUMED to be already correctly positionned.
	#
	# $log->tracef('_isPos %d : internal pos %s : %s', $_[2], pos($_[0]->{buf}), substr($_[0]->{buf}, pos($_[0]->{buf})));
	return 1;
    } else {
	return $_[0]->_canPos($_[1], $_[2]);
    }
}

#
# _moreDataNeeded returns TRUE if the position given is the last uncached data and EOF is not reached
#
sub _moreDataNeeded {
    # my ($self, $stream, $pos) = @_;

  return ($_[2] == $_[0]->{mapend} && ! $_[1]->eof());

}

#
# For performance, everything is done one the stack
# This routine check AND position buffer
#
sub _canPos {
    # my ($self, $stream, $pos) = @_;

    if ($_[2] < $_[0]->{mapend}) {
	#
	# Current buffer
	#
	pos($_[0]->{buf}) = $_[2] - $_[0]->{mapbeg};
	$log->tracef('_canPos %d : internal pos %s : %s...', $_[2], pos($_[0]->{buf}), substr($_[0]->{buf}, pos($_[0]->{buf}), 10));
	return 1;
    } else {
	if (! $_[0]->{mapend}) {
	    #
	    # No buffer
	    #
	    $_[0]->{buf} = $_[1]->fetchb(0);
	    if (! defined($_[0]->{buf})) {
		return undef;
	    } else {
		# $log->tracef('_canPos %d : fetched buffer 0: %s', $_[2], $_[0]->{buf});
		$_[0]->{mapbeg} = $_[1]->mapbeg(0);
		$_[0]->{mapend} = $_[1]->mapend(0);
		$_[0]->{origmapend} = $_[0]->{mapend};
		$_[0]->{lastBufNo} = 0;
		return $_[0]->_canPos($_[1], $_[2]);
	    }
	} else {
	    #
	    # Need to append. We take the next uncached buffer
	    #
	    my $nextBufNo = $_[0]->{lastBufNo} + 1;
	    $log->tracef('_canPos %d : append buffer %d', $_[2], $nextBufNo);
	    my $append = $_[1]->fetchb($nextBufNo);
	    if (defined($append)) {
		$_[0]->{buf} .= $append;
		$_[0]->{mapend} = $_[1]->mapend($nextBufNo);
		$_[0]->{lastBufNo} = $nextBufNo;
		return $_[0]->_canPos($_[1], $_[2]);
	    } else {
		return undef;
	    }
	}
    }
}

sub _progressToKey {
    my ($self, $recce) = @_;

    my $key = '';

    my @key = ();
    foreach (@{$recce->progress()}) {
      push(@key, "$_->[0].$_->[1]");
    }
    $key = join('/', @key);

    return $key;
}

our %REGEXP_PRIORITY = (
                        SYSTEMLITERAL => 2,
                        PUBIDLITERAL  => 2,
                        CHARDATA      => 2,
                        ATTVALUE      => 2,
                        ENTITYVALUE   => 2,
                        NAME          => 2,
                        PITARGET      => 1,
                        ENCNAME       => 1,
                        NMTOKEN       => 2,
                        S             => -1
);
sub _sortRegexpTerminals {
  #
  # We always place at the top the "greedy"-like regexps
  # and always put at the bottom the space regexp
  #
  my $aWeight = $REGEXP_PRIORITY{$a} || 0;
  my $bWeight = $REGEXP_PRIORITY{$b} || 0;

  return $bWeight <=> $aWeight;
}

sub parse {
  my ($self, $input) = @_;

  #
  # Initiate recognizer
  # We will take care of all lexemes recognition and use token-stream model
  #
  my $recce = Marpa::R2::Scanless::R->new( { grammar => $G{document} } );
  my $thin_slr = $recce->thin_slr();
  my $fake_input = ' ';
  $recce->read(\$fake_input);
  #
  # We used a single event just to pause at the very beginning. We do not
  # need this event anymore.
  #
  $recce->activate('^document', 0);
  #
  # Current buffer
  #
  my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input);
  my $pos = 0;
  my $bigtrace = 100000;
  #
  # Loop until nothing left in the buffer
  #
  my %KEY2TERMINALS = ();
  my %KEY2TERMINALS_CONDITIONS = ();
  my %KEY_TOKENS_TO_NEXTKEY = ();
  my %SYMBOL_ID = ();
  #
  # We instanciate $key manually
  #
  my $level = 0;
  my $key = $self->_progressToKey($recce, $level);
  my $internalPos;
  my $value;
  my $stringToMatch;
  my $stringToMatchLength;
  my $c0;
  my @MATCHARGS;

  return if (! $self->_canPos($stream, $pos));

  #
  # Do the very first positioning
  #

  while (1) {

    last if (! $self->_isPos($stream, $pos));

    $internalPos = pos($self->{buf});
    $c0 = substr($self->{buf}, $internalPos, 1);
    if (! defined($c0)) {
      $log->errorf('pos=%6d : oups $c0 is undef', $pos);
    }
    #
    # Get expected terminals
    #
    if (! defined($KEY2TERMINALS{$key})) {
      my @terminals_expected = @{$recce->terminals_expected()};
      #
      # We distinguish REGEXP and STRINGS
      #
      my @REGEXP = sort _sortRegexpTerminals grep {! exists($STR{$_})} @terminals_expected;
      #
      # In case of fixed strings, we will always make sure that the maximum
      # string to matched is available. So we sort the string by length.
      #
      my @STRING = sort {$STRLENGTH{$b} <=> $STRLENGTH{$a}} grep {exists($STR{$_})} @terminals_expected;
      #
      # Fill the cached terminals
      #
      $KEY2TERMINALS{$key} = [ [ @REGEXP ], $#STRING, [ @STRING] ];
    }

    if ($KEY2TERMINALS{$key}->[1] >= 0) {
      #
      # Try to fetch unless longest length is 1
      #
      if ($STRLENGTH{$KEY2TERMINALS{$key}->[2]->[0]} == 1) {
        $stringToMatch = $c0;
        $stringToMatchLength = 1;
      } else {
        # $log->tracef('pos=%6d : trying to fetch %d characters', $pos, $STRLENGTH{$KEY2TERMINALS{$key}->[2]->[0]});
        $self->_isPos($stream, $pos + $STRLENGTH{$KEY2TERMINALS{$key}->[2]->[0]} - 1);
        pos($self->{buf}) = $internalPos;
        $stringToMatch = substr($self->{buf}, $internalPos, $STRLENGTH{$KEY2TERMINALS{$key}->[2]->[0]});
        $stringToMatchLength = length($stringToMatch);
      }
    }

    # $log->tracef('pos=%6d : internal pos=%6d : trying regexps %s, then strings %s, on ...%s...', $pos, pos($self->{buf}), $KEY2TERMINALS{$key}->[0], $KEY2TERMINALS{$key}->[2], substr($self->{buf}, pos($self->{buf}), 10));

    @MATCHARGS = ($self, $stream, $pos, $c0, $internalPos);
    my $token = undef;
    my $value = '';
    #
    # Match the regexps first
    #
    foreach my $regexp (@{$KEY2TERMINALS{$key}->[0]}) {

      # $log->tracef('pos=%6d : internal pos=%6d/%6d : trying %s on ...%s...', $pos, $internalPos, pos($self->{buf}), $regexp, substr($self->{buf}, pos($self->{buf}), 10));

      $value = $MATCH{$regexp}(@MATCHARGS);

      if (length($value) > 0) {
        $token = $regexp;
        last;
      }
    }
    #
    # The strings if no regexp matched. Strings are easier and do not need a CODE reference
    #
    if (! defined($token)) {
      foreach my $string (@{$KEY2TERMINALS{$key}->[2]}) {

        if ($stringToMatchLength > $STRLENGTH{$string}) {
          substr($stringToMatch, $STRLENGTH{$string}) = '';
          $stringToMatchLength = $STRLENGTH{$string};
        }

        # $log->tracef('pos=%6d : internal pos=%6d/%6d : trying %s (length %d) on ...%s...', $pos, $internalPos, pos($self->{buf}), $string, $STRLENGTH{$string}, $stringToMatch);

        if ($stringToMatch eq $STR{$string}) {
          $token = $string;
          $value = $stringToMatch;
          pos($self->{buf}) += $stringToMatchLength;
          last;
        }
      }
    }
    if (defined($token)) {
      # $log->tracef('pos=%6d : internal pos=%6d/%6d : lexeme_alternative("%s", "%s")', $pos, $internalPos, pos($self->{buf}), $token, $value);
      # $recce->lexeme_alternative($token, $value);
      # $recce->lexeme_alternative($token);
      $thin_slr->lexeme_alternative(($SYMBOL_ID{$token} //= $recce->symbol_id($token)));
      $level += ($LEXEME_LEVEL{$token} //= 0);
      $thin_slr->lexeme_complete(0, 1);
      # $log->tracef('pos=%6d : +=%d, value=%s', $pos, $maxTokenLength, $value);
      $pos += length($value);
      $key = ($KEY_TOKENS_TO_NEXTKEY{"[$level]$key"}->{$token} //= $self->_progressToKey($recce));
    } else {
      #
      # Acceptable only if there are discardable characters
      #
      my $discard = $MATCH{_DISCARD}(@MATCHARGS);
      my $length = length($discard);
      if ($length > 0) {
        $log->tracef('pos=%6d : discarding %d characters (%s)', $pos, $length, $discard);
        $pos += $length;
      } else {
        $log->tracef('pos=%6d : no token nor discardable character', $pos);
        last;
      }
    }

    if ($pos >= $bigtrace) {
      $log->tracef('pos=%6d', $pos);
      $bigtrace += 100000;
      # last if ($bigtrace >= 300000);
    }

    $self->_donePos($stream, $pos);
  }
  goto novalue;
  my $nvalue = 0;
  while (defined($_ = $recce->value)) {
      ++$nvalue;
      #$log->tracef('Value %d: %s', $nvalue, $_);
  }
  $log->tracef('Total number of values: %d', $nvalue);
  if (! $nvalue) {
      print "EXPECTED: @{$recce->terminals_expected()}\n";
      print  "LATEST PROGRESS:\n";
      print $recce->show_progress();
  }
 novalue:
}

1;
__DATA__
inaccessible is ok by default

:start ::=      # TO BE FILLED DYNAMICALLY
:default ::= action => [values] bless => ::lhs
lexeme default = action => [start,length,value] forgiving => 1

#
# We want to pause at the very beginning
#
event '^document' = predicted <document>
document      ::= prolog element MiscAny
Char          ::= CHAR
Name          ::= NAME
Names         ::= Name
                | x20 Names
Nmtoken       ::= NMTOKEN
Nmtokens      ::= Nmtoken
                | x20 Nmtokens
EntityValue   ::= ENTITYVALUE
AttValue      ::= ATTVALUE
SystemLiteral ::= SYSTEMLITERAL
PubidLiteral  ::= PUBIDLITERAL
CharData      ::= CHARDATA
Comment       ::= CommentBeg CommentInterior CommentEnd
PITarget      ::= PITARGET
PI            ::= PiBeg PITarget               PiEnd
                | PiBeg PITarget WhiteSpace PiInterior PiEnd
CDSect        ::= CDStart CData CDEnd
CDStart       ::= CDSTART
CData         ::= CDATA
CDEnd         ::= CDEND
prolog        ::= XMLDeclMaybe MiscAny
                | XMLDeclMaybe MiscAny doctypedecl MiscAny
XMLDecl       ::= XmlBeg VersionInfo EncodingDeclMaybe SDDeclMaybe SMaybe XmlEnd
VersionInfo   ::= WhiteSpace Version Eq Squote VersionNum Squote
                | WhiteSpace Version Eq Dquote VersionNum Dquote
Eq            ::= SMaybe Equal SMaybe
VersionNum    ::= VERSIONNUM
Misc          ::= Comment
                | PI
                | WhiteSpace
doctypedecl   ::= DoctypeBeg WhiteSpace Name SMaybe                                     DoctypeEnd
                | DoctypeBeg WhiteSpace Name SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd
                | DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe                                     DoctypeEnd
                | DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd
DeclSep       ::= PEReference
                | WhiteSpace
intSubset     ::= intSubsetUnitAny
markupdecl    ::= elementdecl
                | AttlistDecl
                | EntityDecl
                | NotationDecl
                | PI
                | Comment
extSubset     ::=          extSubsetDecl
                | TextDecl extSubsetDecl
extSubsetDecl ::= extSubsetDeclUnitAny
SDDecl        ::= WhiteSpace Standalone Eq Squote Yes Squote
                | WhiteSpace Standalone Eq Squote No  Squote
                | WhiteSpace Standalone Eq Dquote Yes Dquote
                | WhiteSpace Standalone Eq Dquote No  Dquote
element       ::= EmptyElemTag
                | STag content ETag
STag          ::= STagBeg Name STagInteriorAny SMaybe STagEnd
Attribute     ::= Name Eq AttValue
ETag          ::= ETagBeg Name SMaybe ETagEnd
content       ::= CharDataMaybe ContentInteriorAny
EmptyElemTag  ::= EmptyElemTagBeg Name EmptyElemTagInteriorAny SMaybe EmptyElemTagEnd
elementdecl   ::= ElementDeclBeg WhiteSpace Name WhiteSpace contentspec SMaybe ElementDeclEnd
contentspec   ::= Empty
                | Any
                | Mixed
                | children
children      ::= choice QuantifierMaybe
                | seq QuantifierMaybe
cp            ::= Name QuantifierMaybe
                | choice QuantifierMaybe
                | seq QuantifierMaybe
choice        ::= Lparen SMaybe cp ChoiceInteriorMany SMaybe Rparen
seq           ::= Lparen SMaybe cp SeqInteriorAny SMaybe Rparen
Mixed         ::= Lparen SMaybe Pcdata MixedInteriorAny SMaybe RparenStar
                | Lparen SMaybe Pcdata SMaybe Rparen
AttlistDecl   ::= AttlistBeg WhiteSpace Name AttDefAny SMaybe AttlistEnd
AttDef        ::= WhiteSpace Name WhiteSpace AttType WhiteSpace DefaultDecl
AttType       ::= StringType
                | TokenizedType
                | EnumeratedType
StringType    ::= STRINGTYPE
TokenizedType ::= TypeId
                | TypeIdref
                | TypeIdrefs
                | TypeEntity
                | TypeEntities
                | TypeNmtoken
                | TypeNmtokens
EnumeratedType ::= NotationType
                | Enumeration
NotationType  ::= Notation WhiteSpace Lparen SMaybe Name NotationTypeInteriorAny SMaybe Rparen
Enumeration   ::= Lparen SMaybe Nmtoken EnumerationInteriorAny SMaybe Rparen
DefaultDecl   ::= Required
                | Implied
                |         AttValue
                | Fixed WhiteSpace AttValue
conditionalSect ::= includeSect
                  | ignoreSect
includeSect   ::= SectBeg SMaybe Include SMaybe Lbracket extSubsetDecl SectEnd
ignoreSect    ::= SectBeg SMaybe TOKIgnore SMaybe Lbracket ignoreSectContentsAny SectEnd
ignoreSectContents ::= Ignore ignoreSectContentsInteriorAny
Ignore        ::=  IGNORE_INTERIOR
CharRef       ::= CHARREF
Reference     ::= EntityRef
                | CharRef
EntityRef     ::= ENTITYREF
PEReference   ::= PEREFERENCE
EntityDecl    ::= GEDecl
                | PEDecl
GEDecl	      ::= EdeclBeg WhiteSpace Name WhiteSpace EntityDef SMaybe EdeclEnd
PEDecl        ::= EdeclBeg WhiteSpace Percent WhiteSpace Name WhiteSpace PEDef SMaybe EdeclEnd
EntityDef     ::= EntityValue
                | ExternalID
                | ExternalID NDataDecl
PEDef         ::= EntityValue
                | ExternalID
ExternalID    ::= System WhiteSpace SystemLiteral
                | Public WhiteSpace PubidLiteral WhiteSpace SystemLiteral
NDataDecl     ::= WhiteSpace Ndata WhiteSpace Name
TextDecl      ::= XmlBeg VersionInfoMaybe EncodingDecl SMaybe XmlEnd
extParsedEnt  ::=          content
                | TextDecl content
EncodingDecl  ::= WhiteSpace Encoding Eq Dquote EncName Dquote
                | WhiteSpace Encoding Eq Squote EncName Squote
EncName       ::= ENCNAME
NotationDecl  ::= NotationBeg WhiteSpace Name WhiteSpace ExternalID SMaybe NotationEnd
                | NotationBeg WhiteSpace Name WhiteSpace PublicID   SMaybe NotationEnd
PublicID      ::= Public WhiteSpace PubidLiteral
#
# G1 helpers
#
x20      ::= X20
XMLDeclMaybe ::= XMLDecl
XMLDeclMaybe ::=
MiscAny ::= Misc*
EncodingDeclMaybe ::= EncodingDecl
EncodingDeclMaybe ::=
SDDeclMaybe ::= SDDecl
SDDeclMaybe ::=
SMaybe ::= WhiteSpace
SMaybe ::=
ContentInterior ::= element CharDataMaybe
                   | Reference CharDataMaybe
                   | CDSect CharDataMaybe
                   | PI CharDataMaybe
                   | Comment CharDataMaybe
ContentInteriorAny ::= ContentInterior*
intSubsetUnit ::= markupdecl
                  | DeclSep
intSubsetUnitAny ::= intSubsetUnit*
extSubsetDeclUnit ::= markupdecl
                     | conditionalSect
                     | DeclSep
extSubsetDeclUnitAny ::= extSubsetDeclUnit*
STagInterior ::= WhiteSpace Attribute
STagInteriorAny ::= STagInterior*
CharDataMaybe ::= CharData
CharDataMaybe ::=
EmptyElemTagInterior ::= WhiteSpace Attribute
EmptyElemTagInteriorAny ::= EmptyElemTagInterior*
Quantifier ::= QuestionMark
             | Star
             | Plus
QuantifierMaybe ::= Quantifier
QuantifierMaybe ::=
ChoiceInterior ::= SMaybe Pipe SMaybe cp
ChoiceInteriorMany ::= ChoiceInterior+
SeqInterior ::= SMaybe Comma SMaybe cp
SeqInteriorAny ::= SeqInterior*
MixedInterior ::= SMaybe Pipe SMaybe Name
MixedInteriorAny ::= MixedInterior*
AttDefAny ::= AttDef*
NotationTypeInterior ::= SMaybe Pipe SMaybe Name
NotationTypeInteriorAny ::= NotationTypeInterior*
EnumerationInterior ::= SMaybe Pipe SMaybe Nmtoken
EnumerationInteriorAny ::= EnumerationInterior*
ignoreSectContentsAny ::= ignoreSectContents*
ignoreSectContentsInterior ::= SectBeg ignoreSectContents SectEnd Ignore
ignoreSectContentsInteriorAny ::= ignoreSectContentsInterior*
VersionInfoMaybe ::= VersionInfo
VersionInfoMaybe ::=
WhiteSpace ::= S
CommentBeg ::= COMMENT_BEG
CommentEnd ::= COMMENT_END
CommentInterior ::= COMMENT
PiInterior ::= PI_INTERIOR
XmlBeg ::= XML_BEG
XmlEnd ::= XML_END
Version ::= VERSION
Squote ::= SQUOTE
Dquote ::= DQUOTE
Equal ::= EQUAL
DoctypeBeg ::= DOCTYPE_BEG
DoctypeEnd ::= XTagEnd
Lbracket ::= LBRACKET
Rbracket ::= RBRACKET
Standalone ::= STANDALONE
Yes ::= YES
No ::= NO
XTagBeg ::= XTAG_BEG
STagBeg ::= XTagBeg
XTagEnd ::= XTAG_END
STagEnd ::= STAG_END
ETagBeg ::= ETAG_BEG
ETagEnd ::= ETAG_END
EmptyElemTagBeg ::= XTagBeg
EmptyElemTagEnd ::= EMPTYELEMTAG_END
ElementDeclBeg ::= ELEMENTDECL_BEG
ElementDeclEnd ::= XTagEnd
Empty ::= EMPTY
Any ::= ANY
QuestionMark ::= QUESTION_MARK
Star ::= STAR
Plus ::= PLUS
Lparen ::= LPAREN
Rparen ::= RPAREN
RparenStar ::= RPARENSTAR
Pipe ::= PIPE
Comma ::= COMMA
AttlistBeg ::= ATTLIST_BEG
AttlistEnd ::= XTagEnd
TypeId ::= TYPE_ID
TypeIdref ::= TYPE_IDREF
TypeIdrefs ::= TYPE_IDREFS
TypeEntity ::= TYPE_ENTITY
TypeEntities ::= TYPE_ENTITIES
TypeNmtoken ::= TYPE_NMTOKEN
TypeNmtokens ::= TYPE_NMTOKENS
Notation ::= NOTATION
NotationBeg ::= NOTATION_BEG
NotationEnd ::= XTagEnd
Required ::= REQUIRED
Implied ::= IMPLIED
Fixed ::= FIXED
SectBeg ::= SECT_BEG
SectEnd ::= SECT_END
Include ::= INCLUDE
EdeclBeg ::= EDECL_BEG
EdeclEnd ::= XTagEnd
Percent ::= PERCENT
System ::= SYSTEM
Public ::= PUBLIC
Ndata ::= NDATA
Encoding ::= ENCODING
TOKIgnore ::= IGNORE
Pcdata ::= PCDATA
PiBeg ::= PI_BEG
PiEnd ::= PI_END
#
# Lexemes: they are all dummy, this is taken care in userspace
# ------------------------------------------------------------
_DUMMY           ~ [^\s\S]
X20              ~ _DUMMY
S                ~ _DUMMY
NAME             ~ _DUMMY
CHAR             ~ _DUMMY
NMTOKEN          ~ _DUMMY
SYSTEMLITERAL    ~ _DUMMY
PUBIDLITERAL     ~ _DUMMY
CHARDATA         ~ _DUMMY
CDATA            ~ _DUMMY
COMMENT_BEG      ~ _DUMMY
COMMENT_END      ~ _DUMMY
COMMENT          ~ _DUMMY
PI_BEG           ~ _DUMMY
PI_END           ~ _DUMMY
PITARGET         ~ _DUMMY
PI_INTERIOR      ~ _DUMMY
CDSTART          ~ _DUMMY
CDEND            ~ _DUMMY
XML_BEG          ~ _DUMMY
XML_END          ~ _DUMMY
VERSION          ~ _DUMMY
DQUOTE           ~ _DUMMY
SQUOTE           ~ _DUMMY
EQUAL            ~ _DUMMY
VERSIONNUM       ~ _DUMMY
DOCTYPE_BEG      ~ _DUMMY
LBRACKET         ~ _DUMMY
RBRACKET         ~ _DUMMY
STANDALONE       ~ _DUMMY
YES              ~ _DUMMY
NO               ~ _DUMMY
XTAG_BEG         ~ _DUMMY
XTAG_END         ~ _DUMMY
STAG_END         ~ _DUMMY
ETAG_END         ~ _DUMMY
ETAG_BEG         ~ _DUMMY
EMPTYELEMTAG_END ~ _DUMMY
ELEMENTDECL_BEG  ~ _DUMMY
EMPTY            ~ _DUMMY
ANY              ~ _DUMMY
QUESTION_MARK    ~ _DUMMY
STAR             ~ _DUMMY
PLUS             ~ _DUMMY
LPAREN           ~ _DUMMY
RPAREN           ~ _DUMMY
PIPE             ~ _DUMMY
COMMA            ~ _DUMMY
RPARENSTAR       ~ _DUMMY
PCDATA           ~ _DUMMY
ATTLIST_BEG      ~ _DUMMY
STRINGTYPE       ~ _DUMMY
TYPE_ID          ~ _DUMMY
TYPE_IDREF       ~ _DUMMY
TYPE_IDREFS      ~ _DUMMY
TYPE_ENTITY      ~ _DUMMY
TYPE_ENTITIES    ~ _DUMMY
TYPE_NMTOKEN     ~ _DUMMY
TYPE_NMTOKENS    ~ _DUMMY
NOTATION         ~ _DUMMY
REQUIRED         ~ _DUMMY
IMPLIED          ~ _DUMMY
FIXED            ~ _DUMMY
SECT_BEG         ~ _DUMMY
INCLUDE          ~ _DUMMY
SECT_END         ~ _DUMMY
IGNORE           ~ _DUMMY
IGNORE_INTERIOR  ~ _DUMMY
CHARREF          ~ _DUMMY
ENTITYREF        ~ _DUMMY
PEREFERENCE      ~ _DUMMY
EDECL_BEG        ~ _DUMMY
PERCENT          ~ _DUMMY
SYSTEM           ~ _DUMMY
PUBLIC           ~ _DUMMY
NDATA            ~ _DUMMY
ENCODING         ~ _DUMMY
ENCNAME          ~ _DUMMY
NOTATION_BEG     ~ _DUMMY
ATTVALUE         ~ _DUMMY
ENTITYVALUE      ~ _DUMMY
