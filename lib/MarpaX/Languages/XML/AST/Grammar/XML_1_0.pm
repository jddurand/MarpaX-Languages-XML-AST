use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0;
use MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util qw/%TOKEN/;
use MarpaX::Languages::XML::AST::Util qw/:all/;
use Carp qw/croak/;
use Marpa::R2 2.082000;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) written in Marpa BNF

# VERSION

our $DATA = do {local $/; <DATA>};

our %POST = (
             X20              => [ \&_normalize ],
             S                => [ \&_normalize ],
             NAME             => [ \&_normalize ],
             CHAR             => [ \&_normalize ],
             NMTOKEN          => [ \&_normalize ],
             SYSTEMLITERAL    => [ \&_normalize ],
             PUBIDLITERAL     => [ \&_normalize ],
             CHARDATA         => [ \&_normalize, \&_chardata ],
             COMMENT          => [ \&_normalize ],
             PITARGET         => [ \&_normalize, \&_pitarget ],
             PI_INTERIOR      => [ \&_normalize, \&_pi_interior ],
             IGNORE_INTERIOR  => [ \&_normalize, \&_ignore_interior ],
             ENTITYREF        => [ \&_normalize ],
             PEREFERENCE      => [ \&_normalize ],
            );
#
# There are several DIFFERENT top-level productions in the XML grammar
#
our %G = ();
foreach (qw/document extSubset extSubsetDecl Name Names Nmtoken Nmtokens NotationDecl PublicID Char/) {
  my $top = $_;
  $DATA =~ s/(:start\s*::=\s*)(.*)/$1$top/g;
  print STDERR "Compiling $top production\n";
  $G{$top} = Marpa::R2::Scanless::G->new({source => \$DATA});
}
#
# For performance reasons, we modify data directly on the stack
#
sub _normalize {
  #
  # Translate both the two-character sequence #xD #xA and any #xD that is not followed by #xA
  # to a single #xA character.
  #
  $_[0] =~ s/\x{D}\x{A}/\x{A}/g;
  $_[0] =~ s/\x{D}/\x{A}/g;
  return;
}

sub _chardata {
  #
  # Exclude the CDATA-section-close delimiter
  #
  my $pos = index($_[0], ']]>');
  if ($pos >= 0) {
    substr($_[0], $pos, -1, '');
  }
  return;
}

sub _pitarget {
  #
  # Exclude the 'xml' (case insensitive) string
  #
  if ($_[0] =~ /^xml$/i) {
    $_[0] = '';
  }
  return;
}

sub _pi_interior {
  #
  # Exclude '?>'
  #
  my $pos = index($_[0], '?>');
  if ($pos >= 0) {
    substr($_[0], $pos, -1, '');
  }
  return;
}

sub _ignore_interior {
  #
  # Exclude '<![' and ']]>'
  #
  my $pos = index($_[0], '<![');
  if ($pos >= 0) {
    substr($_[0], $pos, -1, '');
  }
  $pos = index($_[0], ']]>');
  if ($pos >= 0) {
    substr($_[0], $pos, -1, '');
  }
  return;
}

sub new {
  my ($class, %opts) = @_;

  my $self = {};

  bless($self, $class);

  return $self;
}

sub _doEvents {
  my ($self, $input, $pos, $recce) = @_;

  my @alternatives = ();
  my $longest = -1;
  my $value = '';
  foreach (@{$recce->events()}) {
    my ($name) = @{$_};
    #
    # We made sure that we are paused only on lexemes
    #
    my $token = $TOKEN{$name}($input, $pos);
    if (defined($token)) {
      my $length = length($token);
      if ($length > $longest) {
        $#alternatives = -1;
        push(@alternatives, $name);
        $longest = $length;
        $value = $token;
      } elsif ($length == $longest) {
        push(@alternatives, $name);
      }
    }
  }
  if (! @alternatives) {
    logCroak($recce, $input, "No alternative", $pos);
  }
  foreach (@alternatives) {
    my $name = $_;
    my $lp = lineAndCol($recce, $pos);
    #printf STDERR "%-10s %s \"%s\"\n", "L$lp->[0]c$lp->[1]", $name, $value;
    $recce->lexeme_alternative($name, $value);
  }
  $recce->lexeme_complete($pos, $longest);
}

sub parse {
  my ($self, $input) = @_;

  my $recce = Marpa::R2::Scanless::R->new( { grammar => $G{document} } );
  my $pos = $recce->read(\$input);
  my $max = length($input);
  $self->{_elementStack} = [];
  $self->{_elementHash} = {};
  $self->{_doctypedeclName} = '';
  $self->{_rootName} = '';
  while ($pos < $max) {
    $self->_doEvents($input, $pos, $recce);
    $pos = $recce->resume();
  }
}

1;
__DATA__
inaccessible is ok by default

:start ::=      # TO BE FILLED DYNAMICALLY
:default ::= action => [values] bless => ::lhs
lexeme default = action => [start,length,value] forgiving => 1

document      ::= prolog element MiscAny
Char          ::= CHAR
Name          ::= NAME
Names         ::= Name+ separator => x20
Nmtoken       ::= NMTOKEN
Nmtokens      ::= Nmtoken+ separator => x20
EntityValue   ::= DQUOTE EntityValueInteriorDquoteUnitAny DQUOTE
                | SQUOTE EntityValueInteriorSquoteUnitAny SQUOTE
AttValue      ::= ATTVALUE
SystemLiteral ::= SYSTEMLITERAL
PubidLiteral  ::= PUBIDLITERAL
CharData      ::= CHARDATA
Comment       ::= COMMENT_BEG COMMENT COMMENT_END
PITarget      ::= PITARGET
PI            ::= PI_BEG PITarget               PI_END
                | PI_BEG PITarget S PI_INTERIOR PI_END
CDSect        ::= CDSTART CData CDEND
CData         ::= CHARDATA*
prolog        ::= XMLDeclMaybe MiscAny
                | XMLDeclMaybe MiscAny doctypedecl MiscAny
XMLDecl       ::= XML_BEG VersionInfo EncodingDeclMaybe SDDeclMaybe SMaybe XML_END
VersionInfo   ::= S VERSION Eq SQUOTE VersionNum SQUOTE
                | S VERSION Eq DQUOTE VersionNum DQUOTE
Eq            ::= SMaybe EQUAL SMaybe
VersionNum    ::= VERSIONNUM
Misc          ::= Comment
                | PI
                | S
doctypedecl   ::= DOCTYPE_BEG S Name (<doctypedeclNameEvent>) SMaybe                                     DOCTYPE_END
                | DOCTYPE_BEG S Name (<doctypedeclNameEvent>) SMaybe LBRACKET intSubset RBRACKET SMaybe DOCTYPE_END
                | DOCTYPE_BEG S Name (<doctypedeclNameEvent>) S ExternalID SMaybe                                     DOCTYPE_END
                | DOCTYPE_BEG S Name (<doctypedeclNameEvent>) S ExternalID SMaybe LBRACKET intSubset RBRACKET SMaybe DOCTYPE_END
DeclSep       ::= PEReference
                | S
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
SDDecl        ::= S STANDALONE Eq SQUOTE YES SQUOTE
                | S STANDALONE Eq SQUOTE NO  SQUOTE
                | S STANDALONE Eq DQUOTE YES DQUOTE
                | S STANDALONE Eq DQUOTE NO  DQUOTE
element       ::= EmptyElemTag
                | STag content ETag
STag          ::= STAG_BEG Name <TagNameEvent> STagInteriorAny SMaybe STAG_END
Attribute     ::= Name Eq AttValue
ETag          ::= ETAG_BEG Name SMaybe ETAG_END
content       ::= CharDataMaybe ContentInteriorAny
EmptyElemTag  ::= EMPTYELEMTAG_BEG Name <TagNameEvent> EmptyElemTagInteriorAny SMaybe EMPTYELEMTAG_END
elementdecl   ::= ELEMENTDECL_BEG S Name S contentspec SMaybe ELEMENTDECL_END
contentspec   ::= EMPTY
                | ANY
                | Mixed
                | children
children      ::= choice QuantifierMaybe
                | seq QuantifierMaybe
cp            ::= Name QuantifierMaybe
                | choice QuantifierMaybe
                | seq QuantifierMaybe
choice        ::= LPAREN SMaybe cp ChoiceInteriorMany SMaybe RPAREN
seq           ::= LPAREN SMaybe cp SeqInteriorAny SMaybe RPAREN
Mixed         ::= LPAREN SMaybe PCDATA MixedInteriorAny SMaybe RPARENSTAR
                | LPAREN SMaybe PCDATA SMaybe RPAREN
AttlistDecl   ::= ATTLIST_BEG S Name AttDefAny SMaybe ATTLIST_END
AttDef        ::= S Name S AttType S DefaultDecl
AttType       ::= StringType
                | TokenizedType
                | EnumeratedType
StringType    ::= CDATA
TokenizedType ::= TYPE_ID
                | TYPE_IDREF
                | TYPE_IDREFS
                | TYPE_ENTITY
                | TYPE_ENTITIES
                | TYPE_NMTOKEN
                | TYPE_NMTOKENS
EnumeratedType ::= NotationType
                | Enumeration
NotationType  ::= NOTATION S LPAREN SMaybe Name NotationTypeInteriorAny SMaybe RPAREN
Enumeration   ::= LPAREN SMaybe Nmtoken EnumerationInteriorAny SMaybe RPAREN
DefaultDecl   ::= REQUIRED
                | IMPLIED
                |         AttValue
                | FIXED S AttValue
conditionalSect ::= includeSect
                  | ignoreSect
includeSect   ::= SECT_BEG SMaybe INCLUDE SMaybe LBRACKET extSubsetDecl SECT_END
ignoreSect    ::= SECT_BEG SMaybe IGNORE SMaybe LBRACKET ignoreSectContentsAny SECT_END
ignoreSectContents ::= Ignore ignoreSectContentsInteriorAny
Ignore        ::=  IGNORE_INTERIOR
CharRef       ::= CHARREF
Reference     ::= EntityRef
                | CharRef
EntityRef     ::= ENTITYREF
PEReference   ::= PEREFERENCE
EntityDecl    ::= GEDecl
                | PEDecl
GEDecl	      ::= EDECL_BEG S Name S EntityDef SMaybe EDECL_END
PEDecl        ::= EDECL_BEG S PERCENT S Name S PEDef SMaybe EDECL_END
EntityDef     ::= EntityValue
                | ExternalID
                | ExternalID NDataDecl
PEDef         ::= EntityValue
                | ExternalID
ExternalID    ::= SYSTEM S SystemLiteral
                | PUBLIC S PubidLiteral S SystemLiteral
NDataDecl     ::= S NDATA S Name
TextDecl      ::= XML_BEG VersionInfoMaybe EncodingDecl SMaybe XML_END
extParsedEnt  ::=          content
                | TextDecl content
EncodingDecl  ::= S ENCODING Eq DQUOTE EncName DQUOTE
                | S ENCODING Eq SQUOTE EncName SQUOTE
EncName       ::= ENCNAME
NotationDecl  ::= NOTATION_BEG S Name S ExternalID SMaybe NOTATION_END
                | NOTATION_BEG S Name S PublicID   SMaybe NOTATION_END
PublicID      ::= PUBLIC S PubidLiteral
#
# G1 helpers
#
x20      ::= X20
EntityValueInteriorDquoteUnit ::= ENTITYCHARDQUOTE | PEReference | Reference
EntityValueInteriorDquoteUnitAny ::= EntityValueInteriorDquoteUnit*
EntityValueInteriorSquoteUnit ::= ENTITYCHARSQUOTE | PEReference | Reference
EntityValueInteriorSquoteUnitAny ::= EntityValueInteriorSquoteUnit*
XMLDeclMaybe ::= XMLDecl
XMLDeclMaybe ::=
MiscAny ::= Misc*
EncodingDeclMaybe ::= EncodingDecl
EncodingDeclMaybe ::=
SDDeclMaybe ::= SDDecl
SDDeclMaybe ::=
SMaybe ::= S
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
STagInterior ::= S Attribute
STagInteriorAny ::= STagInterior*
CharDataMaybe ::= CharData
CharDataMaybe ::=
EmptyElemTagInterior ::= S Attribute
EmptyElemTagInteriorAny ::= EmptyElemTagInterior*
Quantifier ::= QUESTION_MARK
             | STAR
             | PLUS
QuantifierMaybe ::= Quantifier
QuantifierMaybe ::=
ChoiceInterior ::= SMaybe PIPE SMaybe cp
ChoiceInteriorMany ::= ChoiceInterior+
SeqInterior ::= SMaybe COMMA SMaybe cp
SeqInteriorAny ::= SeqInterior*
MixedInterior ::= SMaybe PIPE SMaybe Name
MixedInteriorAny ::= MixedInterior*
AttDefAny ::= AttDef*
NotationTypeInterior ::= SMaybe PIPE SMaybe Name
NotationTypeInteriorAny ::= NotationTypeInterior*
EnumerationInterior ::= SMaybe PIPE SMaybe Nmtoken
EnumerationInteriorAny ::= EnumerationInterior*
ignoreSectContentsAny ::= ignoreSectContents*
ignoreSectContentsInterior ::= SECT_BEG ignoreSectContents SECT_END Ignore
ignoreSectContentsInteriorAny ::= ignoreSectContentsInterior*
VersionInfoMaybe ::= VersionInfo
VersionInfoMaybe ::=
#
# G1 event helpers
# ----------------
event 'TagNameEvent' = nulled <TagNameEvent>
TagNameEvent ::=
event 'doctypedeclNameEvent' = nulled <doctypedeclNameEvent>
doctypedeclNameEvent ::=
#
# Lexemes
# -------
_DUMMY           ~ [\s\S]
X20              ~ _DUMMY
S                ~ _DUMMY
NAME             ~ _DUMMY
CHAR             ~ _DUMMY
NMTOKEN          ~ _DUMMY
SYSTEMLITERAL    ~ _DUMMY
PUBIDLITERAL     ~ _DUMMY
CHARDATA         ~ _DUMMY
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
DOCTYPE_END      ~ _DUMMY
LBRACKET         ~ _DUMMY
RBRACKET         ~ _DUMMY
STANDALONE       ~ _DUMMY
YES              ~ _DUMMY
NO               ~ _DUMMY
STAG_BEG         ~ _DUMMY
STAG_END         ~ _DUMMY
ETAG_BEG         ~ _DUMMY
ETAG_END         ~ _DUMMY
EMPTYELEMTAG_BEG ~ _DUMMY
EMPTYELEMTAG_END ~ _DUMMY
ELEMENTDECL_BEG  ~ _DUMMY
ELEMENTDECL_END  ~ _DUMMY
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
ATTLIST_END      ~ _DUMMY
CDATA            ~ _DUMMY
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
EDECL_END        ~ _DUMMY
PERCENT          ~ _DUMMY
SYSTEM           ~ _DUMMY
PUBLIC           ~ _DUMMY
NDATA            ~ _DUMMY
ENCODING         ~ _DUMMY
ENCNAME          ~ _DUMMY
NOTATION_BEG     ~ _DUMMY
NOTATION_END     ~ _DUMMY
ENTITYCHARDQUOTE ~ _DUMMY
ENTITYCHARSQUOTE ~ _DUMMY
ATTVALUE         ~ _DUMMY
#
# G0 events
# ---------
:lexeme ~ X20              pause => before event => 'X20'
:lexeme ~ S                pause => before event => 'S'
:lexeme ~ NAME             pause => before event => 'NAME'
:lexeme ~ CHAR             pause => before event => 'CHAR'
:lexeme ~ NMTOKEN          pause => before event => 'NMTOKEN'
:lexeme ~ SYSTEMLITERAL    pause => before event => 'SYSTEMLITERAL'
:lexeme ~ PUBIDLITERAL     pause => before event => 'PUBIDLITERAL'
:lexeme ~ CHARDATA         pause => before event => 'CHARDATA'
:lexeme ~ COMMENT_BEG      pause => before event => 'COMMENT_BEG'
:lexeme ~ COMMENT_END      pause => before event => 'COMMENT_END'
:lexeme ~ COMMENT          pause => before event => 'COMMENT'
:lexeme ~ PI_BEG           pause => before event => 'PI_BEG'
:lexeme ~ PI_END           pause => before event => 'PI_END'
:lexeme ~ PITARGET         pause => before event => 'PITARGET'
:lexeme ~ PI_INTERIOR      pause => before event => 'PI_INTERIOR'
:lexeme ~ CDSTART          pause => before event => 'CDSTART'
:lexeme ~ CDEND            pause => before event => 'CDEND'
:lexeme ~ XML_BEG          pause => before event => 'XML_BEG'
:lexeme ~ XML_END          pause => before event => 'XML_END'
:lexeme ~ VERSION          pause => before event => 'VERSION'
:lexeme ~ DQUOTE           pause => before event => 'DQUOTE'
:lexeme ~ SQUOTE           pause => before event => 'SQUOTE'
:lexeme ~ EQUAL            pause => before event => 'EQUAL'
:lexeme ~ VERSIONNUM       pause => before event => 'VERSIONNUM'
:lexeme ~ DOCTYPE_BEG      pause => before event => 'DOCTYPE_BEG'
:lexeme ~ DOCTYPE_END      pause => before event => 'DOCTYPE_END'
:lexeme ~ LBRACKET         pause => before event => 'LBRACKET'
:lexeme ~ RBRACKET         pause => before event => 'RBRACKET'
:lexeme ~ STANDALONE       pause => before event => 'STANDALONE'
:lexeme ~ YES              pause => before event => 'YES'
:lexeme ~ NO               pause => before event => 'NO'
:lexeme ~ STAG_BEG         pause => before event => 'STAG_BEG'
:lexeme ~ STAG_END         pause => before event => 'STAG_END'
:lexeme ~ ETAG_BEG         pause => before event => 'ETAG_BEG'
:lexeme ~ ETAG_END         pause => before event => 'ETAG_END'
:lexeme ~ EMPTYELEMTAG_BEG pause => before event => 'EMPTYELEMTAG_BEG'
:lexeme ~ EMPTYELEMTAG_END pause => before event => 'EMPTYELEMTAG_END'
:lexeme ~ ELEMENTDECL_BEG  pause => before event => 'ELEMENTDECL_BEG'
:lexeme ~ ELEMENTDECL_END  pause => before event => 'ELEMENTDECL_END'
:lexeme ~ EMPTY            pause => before event => 'EMPTY'
:lexeme ~ ANY              pause => before event => 'ANY'
:lexeme ~ QUESTION_MARK    pause => before event => 'QUESTION_MARK'
:lexeme ~ STAR             pause => before event => 'STAR'
:lexeme ~ PLUS             pause => before event => 'PLUS'
:lexeme ~ LPAREN           pause => before event => 'LPAREN'
:lexeme ~ RPAREN           pause => before event => 'RPAREN'
:lexeme ~ PIPE             pause => before event => 'PIPE'
:lexeme ~ COMMA            pause => before event => 'COMMA'
:lexeme ~ RPARENSTAR       pause => before event => 'RPARENSTAR'
:lexeme ~ PCDATA           pause => before event => 'PCDATA'
:lexeme ~ ATTLIST_BEG      pause => before event => 'ATTLIST_BEG'
:lexeme ~ ATTLIST_END      pause => before event => 'ATTLIST_END'
:lexeme ~ CDATA            pause => before event => 'CDATA'
:lexeme ~ TYPE_ID          pause => before event => 'TYPE_ID'
:lexeme ~ TYPE_IDREF       pause => before event => 'TYPE_IDREF'
:lexeme ~ TYPE_IDREFS      pause => before event => 'TYPE_IDREFS'
:lexeme ~ TYPE_ENTITY      pause => before event => 'TYPE_ENTITY'
:lexeme ~ TYPE_ENTITIES    pause => before event => 'TYPE_ENTITIES'
:lexeme ~ TYPE_NMTOKEN     pause => before event => 'TYPE_NMTOKEN'
:lexeme ~ TYPE_NMTOKENS    pause => before event => 'TYPE_NMTOKENS'
:lexeme ~ NOTATION         pause => before event => 'NOTATION'
:lexeme ~ REQUIRED         pause => before event => 'REQUIRED'
:lexeme ~ IMPLIED          pause => before event => 'IMPLIED'
:lexeme ~ FIXED            pause => before event => 'FIXED'
:lexeme ~ SECT_BEG         pause => before event => 'SECT_BEG'
:lexeme ~ INCLUDE          pause => before event => 'INCLUDE'
:lexeme ~ SECT_END         pause => before event => 'SECT_END'
:lexeme ~ IGNORE           pause => before event => 'IGNORE'
:lexeme ~ IGNORE_INTERIOR  pause => before event => 'IGNORE_INTERIOR'
:lexeme ~ CHARREF          pause => before event => 'CHARREF'
:lexeme ~ ENTITYREF        pause => before event => 'ENTITYREF'
:lexeme ~ PEREFERENCE      pause => before event => 'PEREFERENCE'
:lexeme ~ EDECL_BEG        pause => before event => 'EDECL_BEG'
:lexeme ~ EDECL_END        pause => before event => 'EDECL_END'
:lexeme ~ PERCENT          pause => before event => 'PERCENT'
:lexeme ~ SYSTEM           pause => before event => 'SYSTEM'
:lexeme ~ PUBLIC           pause => before event => 'PUBLIC'
:lexeme ~ NDATA            pause => before event => 'NDATA'
:lexeme ~ ENCODING         pause => before event => 'ENCODING'
:lexeme ~ ENCNAME          pause => before event => 'ENCNAME'
:lexeme ~ NOTATION_BEG     pause => before event => 'NOTATION_BEG'
:lexeme ~ NOTATION_END     pause => before event => 'NOTATION_END'
:lexeme ~ ENTITYCHARDQUOTE pause => before event => 'ENTITYCHARDQUOTE'
:lexeme ~ ENTITYCHARSQUOTE pause => before event => 'ENTITYCHARSQUOTE'
:lexeme ~ ATTVALUE         pause => before event => 'ATTVALUE'
