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
    printf STDERR "%-10s %s \"%s\"\n", "L$lp->[0]c$lp->[1]", $name, $value;
    $recce->lexeme_alternative($name, $value);
  }
  $recce->lexeme_complete($pos, $longest);

  return $pos+$longest;
}

sub parse {
  my ($self, $input) = @_;

  my $recce = Marpa::R2::Scanless::R->new( { grammar => $G{document}, trace_terminals => 1 } );
  my $fake_input = ' ';
  my $pos = $recce->read(\$input);
  my $max = length($input);
  $self->{_elementStack} = [];
  $self->{_elementHash} = {};
  $self->{_doctypedeclName} = '';
  $self->{_rootName} = '';
  while ($pos < $max) {
    $pos = $self->_doEvents($input, $pos, $recce);
    #eval {$pos = $recce->resume()};
    if ($@) {
	print STDERR "$@";
	print STDERR $recce->show_progress();
	exit;
    }
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
EntityValue   ::= Dquote EntityValueInteriorDquoteUnitAny Dquote
                | Squote EntityValueInteriorSquoteUnitAny Squote
AttValue      ::= Dquote AttValueInteriorDquoteUnitAny Dquote
                | Squote AttValueInteriorSquoteUnitAny Squote
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
PublicID      ::= PUBLIC WhiteSpace PubidLiteral
#
# G1 helpers
#
x20      ::= X20
EntityCharDquote ::= ENTITYCHARDQUOTE
EntityCharSquote ::= ENTITYCHARSQUOTE
EntityValueInteriorDquoteUnit ::= EntityCharDquote | PEReference | Reference
EntityValueInteriorDquoteUnitAny ::= EntityValueInteriorDquoteUnit*
EntityValueInteriorSquoteUnit ::= EntityCharSquote | PEReference | Reference
EntityValueInteriorSquoteUnitAny ::= EntityValueInteriorSquoteUnit*
AttCharDquote ::= ATTCHARDQUOTE
AttCharSquote ::= ATTCHARSQUOTE
AttValueInteriorDquoteUnit ::= AttCharDquote | Reference
AttValueInteriorDquoteUnitAny ::= AttValueInteriorDquoteUnit*
AttValueInteriorSquoteUnit ::= AttCharSquote | Reference
AttValueInteriorSquoteUnitAny ::= AttValueInteriorSquoteUnit*
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
DoctypeEnd ::= DOCTYPE_END
Lbracket ::= LBRACKET
Rbracket ::= RBRACKET
Standalone ::= STANDALONE
Yes ::= YES
No ::= NO
STagBeg ::= STAG_BEG
STagEnd ::= STAG_END
ETagBeg ::= ETAG_BEG
ETagEnd ::= ETAG_END
EmptyElemTagBeg ::= EMPTYELEMTAG_BEG
EmptyElemTagEnd ::= EMPTYELEMTAG_END
ElementDeclBeg ::= ELEMENTDECL_BEG
ElementDeclEnd ::= ELEMENTDECL_END
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
AttlistEnd ::= ATTLIST_END
TypeId ::= TYPE_ID
TypeIdref ::= TYPE_IDREF
TypeIdrefs ::= TYPE_IDREFS
TypeEntity ::= TYPE_ENTITY
TypeEntities ::= TYPE_ENTITIES
TypeNmtoken ::= TYPE_NMTOKEN
TypeNmtokens ::= TYPE_NMTOKENS
Notation ::= NOTATION
NotationBeg ::= NOTATION_BEG
NotationEnd ::= NOTATION_END
Required ::= REQUIRED
Implied ::= IMPLIED
Fixed ::= FIXED
SectBeg ::= SECT_BEG
SectEnd ::= SECT_END
Include ::= INCLUDE
EdeclBeg ::= EDECL_BEG
EdeclEnd ::= EDECL_END
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
# G1 prediction events
# Take care, we made sure that all these events are on LHS that are consuming exactly one
# single lexeme, unique per LHS. In such a case, the lexemes read never happen, i.e.
# this is a way to prevent Marpa to pre-read the stream. And that's why it is OK to
# make all lexemes definitions like [^\s\S] i.e. nothing
# -------
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
ATTCHARDQUOTE    ~ _DUMMY
ATTCHARSQUOTE    ~ _DUMMY

event X20              = predicted x20
event S                = predicted WhiteSpace
event NAME             = predicted Name
event CHAR             = predicted Char
event NMTOKEN          = predicted Nmtoken
event SYSTEMLITERAL    = predicted SystemLiteral
event PUBIDLITERAL     = predicted PubidLiteral
event CHARDATA         = predicted CharData
event CDATA            = predicted CData
event COMMENT_BEG      = predicted CommentBeg
event COMMENT_END      = predicted CommentEnd
event COMMENT          = predicted CommentInterior
event PI_BEG           = predicted PiBeg
event PI_END           = predicted PiEnd
event PITARGET         = predicted PITarget
event PI_INTERIOR      = predicted PiInterior
event CDSTART          = predicted CDStart
event CDEND            = predicted CDEnd
event XML_BEG          = predicted XmlBeg
event XML_END          = predicted XmlEnd
event VERSION          = predicted Version
event DQUOTE           = predicted Dquote
event SQUOTE           = predicted Squote
event EQUAL            = predicted Equal
event VERSIONNUM       = predicted VersionNum
event DOCTYPE_BEG      = predicted DoctypeBeg
event DOCTYPE_END      = predicted DoctypeEnd
event LBRACKET         = predicted Lbracket
event RBRACKET         = predicted Rbracket
event STANDALONE       = predicted Standalone
event YES              = predicted Yes
event NO               = predicted No
event STAG_BEG         = predicted STagBeg
event STAG_END         = predicted STagEnd
event ETAG_BEG         = predicted ETagBeg
event ETAG_END         = predicted ETagEnd
event EMPTYELEMTAG_BEG = predicted EmptyElemTagBeg
event EMPTYELEMTAG_END = predicted EmptyElemTagEnd
event ELEMENTDECL_BEG  = predicted ElementDeclBeg
event ELEMENTDECL_END  = predicted ElementDeclEnd
event EMPTY            = predicted Empty
event ANY              = predicted Any
event QUESTION_MARK    = predicted QuestionMark
event STAR             = predicted Star
event PLUS             = predicted Plus
event LPAREN           = predicted Lparen
event RPAREN           = predicted Rparen
event PIPE             = predicted Pipe
event COMMA            = predicted Comma
event RPARENSTAR       = predicted RparenStar
event PCDATA           = predicted Pcdata
event ATTLIST_BEG      = predicted AttlistBeg
event ATTLIST_END      = predicted AttlistEnd
event STRINGTYPE       = predicted StringType
event TYPE_ID          = predicted TypeId
event TYPE_IDREF       = predicted TypeIdref
event TYPE_IDREFS      = predicted TypeIdrefs
event TYPE_ENTITY      = predicted TypeEntity
event TYPE_ENTITIES    = predicted TypeEntities
event TYPE_NMTOKEN     = predicted TypeNmtoken
event TYPE_NMTOKENS    = predicted TypeNmtokens
event NOTATION         = predicted Notation
event REQUIRED         = predicted Required
event IMPLIED          = predicted Implied
event FIXED            = predicted Fixed
event SECT_BEG         = predicted SectBeg
event INCLUDE          = predicted Include
event SECT_END         = predicted SectEnd
event IGNORE           = predicted TOKIgnore
event IGNORE_INTERIOR  = predicted Ignore
event CHARREF          = predicted CharRef
event ENTITYREF        = predicted EntityRef
event PEREFERENCE      = predicted PEReference
event EDECL_BEG        = predicted EdeclBeg
event EDECL_END        = predicted EdeclEnd
event PERCENT          = predicted Percent
event SYSTEM           = predicted System
event PUBLIC           = predicted Public
event NDATA            = predicted Ndata
event ENCODING         = predicted Encoding
event ENCNAME          = predicted EncName
event NOTATION_BEG     = predicted NotationBeg
event NOTATION_END     = predicted NotationEnd
event ENTITYCHARDQUOTE = predicted EntityCharDquote
event ENTITYCHARSQUOTE = predicted EntityCharSquote
event ATTCHARDQUOTE    = predicted AttCharDquote
event ATTCHARSQUOTE    = predicted AttCharSquote
