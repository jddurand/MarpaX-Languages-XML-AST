use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0;
use MarpaX::Languages::XML::AST::Util qw/:all/;
use Carp qw/croak/;
use Marpa::R2 2.082000;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) written in Marpa BNF

# VERSION

our $DATA = do {local $/; <DATA>};

#
# We will systematically pause before every lexeme: grammar is changed on the fly and we
# use that to make sure all regexp are defined.
#
#
# Util regexpes
#
our $RE_NAMESTARTCHAR = qr/(?:[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}])/;
our $RE_NAMECHAR = qr/(?:$RE_NAMESTARTCHAR|[-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}])/,
our $RE_PUBIDCHAR_DQUOTE = qr/(?:[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%])/;
our $RE_PUBIDCHAR_SQUOTE = qr/(?:[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%])/;
our $RE_CHARCOMMENT = qr/(?:[\x{9}\x{A}\x{D}\x{20}-\x{2C}\x{2E}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}])/,
our $RE_CHAR = qr/(?:[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}])/;

our $RE_NAME = qr/(?:${RE_NAMESTARTCHAR}${RE_NAMECHAR}*)/;
our %RE = (
           X20              => qr/\G(?:[\x{20}])/,
           S                => qr/\G(?:[\x{20}\x{9}\x{D}\x{A}]+)/,
           NAME             => qr/\G(?:${RE_NAME})/,
           CHAR             => qr/\G(?:${RE_CHAR})/,
           NMTOKEN          => qr/\G(?:${RE_NAMECHAR}+)/,
           SYSTEMLITERAL    => qr/\G(?:"[^"]*")|(?:'[^']*')/,
           PUBIDLITERAL     => qr/\G(?:"${RE_PUBIDCHAR_DQUOTE}*")|(?:'${RE_PUBIDCHAR_SQUOTE}*')/,
           CHARDATA         => qr/\G(?:[^<&]*)/,
           COMMENT_BEG      => qr/\G(?:<!--)/,
           COMMENT_END      => qr/\G(?:-->)/,
           COMMENT          => qr/\G(?:(?:$RE_CHARCOMMENT|(?:\-$RE_CHARCOMMENT))*)/,
           PI_BEG           => qr/\G(?:<\?)/,
           PI_END           => qr/\G(?:\?>)/,
           PITARGET         => qr/\G(?:${RE_NAME})/,
           PI_INTERIOR      => qr/\G(?:${RE_CHAR})/,
           CDSTART          => qr/\G(?:<!\[CDATA\[)/,
           CDEND            => qr/\G(?:\]\]>)/,
           XML_BEG          => qr/\G(?:<\?xml)/,
           XML_END          => qr/\G(?:\?>)/,
           VERSION          => qr/\G(?:version)/,
           DQUOTE           => qr/\G(?:")/,
           SQUOTE           => qr/\G(?:')/,
           EQUAL            => qr/\G(?:=)/,
           VERSIONNUM       => qr/\G(?:1\.[0-9]+)/,
           DOCTYPE_BEG      => qr/\G(?:<!DOCTYPE)/,
           DOCTYPE_END      => qr/\G(?:>)/,
           LBRACKET         => qr/\G(?:\[)/,
           RBRACKET         => qr/\G(?:\])/,
           STANDALONE       => qr/\G(?:standalone)/,
           YES              => qr/\G(?:yes)/,
           NO               => qr/\G(?:no)/,
           STAG_BEG         => qr/\G(?:<)/,
           STAG_END         => qr/\G(?:>)/,
           ETAG_BEG         => qr/\G(?:<\/)/,
           ETAG_END         => qr/\G(?:>)/,
           EMPTYELEMTAG_BEG => qr/\G(?:<)/,
           EMPTYELEMTAG_END => qr/\G(?:\/>)/,
           ELEMENTDECL_BEG  => qr/\G(?:<!ELEMENT)/,
           ELEMENTDECL_END  => qr/\G(?:>)/,
           EMPTY            => qr/\G(?:EMPTY)/,
           ANY              => qr/\G(?:ANY)/,
           QUESTION_MARK    => qr/\G(?:\?)/,
           STAR             => qr/\G(?:\*)/,
           PLUS             => qr/\G(?:\+)/,
           LPAREN           => qr/\G(?:\()/,
           RPAREN           => qr/\G(?:\))/,
           RPARENSTAR       => qr/\G(?:\(\*)/,
           PIPE             => qr/\G(?:\|)/,
           COMMA            => qr/\G(?:,)/,
           PCDATA           => qr/\G(?:#PCDATA)/,
           ATTLIST_BEG      => qr/\G(?:<!ATTLIST)/,
           ATTLIST_END      => qr/\G(?:>)/,
           CDATA            => qr/\G(?:CDATA)/,
           TYPE_ID          => qr/\G(?:ID)/,
           TYPE_IDREF       => qr/\G(?:IDREF)/,
           TYPE_IDREFS      => qr/\G(?:IDREFS)/,
           TYPE_ENTITY      => qr/\G(?:ENTITY)/,
           TYPE_ENTITIES    => qr/\G(?:ENTITIES)/,
           TYPE_NMTOKEN     => qr/\G(?:NMTOKEN)/,
           TYPE_NMTOKENS    => qr/\G(?:NMTOKENS)/,
           NOTATION         => qr/\G(?:NOTATION)/,
           REQUIRED         => qr/\G(?:#REQUIRED)/,
           IMPLIED          => qr/\G(?:#IMPLIED)/,
           FIXED            => qr/\G(?:#FIXED)/,
           SECT_BEG         => qr/\G(?:<!\[)/,
           INCLUDE          => qr/\G(?:INCLUDE)/,
           SECT_END         => qr/\G(?:\]\]>)/,
           IGNORE           => qr/\G(?:IGNORE)/,
           IGNORE_INTERIOR  => qr/\G(?:${RE_CHAR})/,
           CHARREF          => qr/\G(?:(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))/,
           ENTITYREF        => qr/\G(?:&${RE_NAME};)/,
           PEREFERENCE      => qr/\G(?:%${RE_NAME};)/,
           EDECL_BEG        => qr/\G(?:<!ENTITY)/,
           EDECL_END        => qr/\G(?:>)/,
           PERCENT          => qr/\G(?:%)/,
           SYSTEM           => qr/\G(?:SYSTEM)/,
           PUBLIC           => qr/\G(?:PUBLIC)/,
           NDATA            => qr/\G(?:NDATA)/,
           ENCODING         => qr/\G(?:encoding)/,
           ENCNAME          => qr/\G(?:[A-Za-z][A-Za-z0-9._-]*)/,
           NOTATION_BEG     => qr/\G(?:<!NOTATION)/,
           NOTATION_END     => qr/\G(?:>)/,
           ENTITYCHARDQUOTE => qr/\G(?:[^%&"])/,
           ENTITYCHARSQUOTE => qr/\G(?:[^%&'])/,
           ATTCHARDQUOTE    => qr/\G(?:[^<&"])/,
           ATTCHARSQUOTE    => qr/\G(?:[^<&'])/,
          );
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
# Eventual list of post-processing callbacks.
# Each post-processing callbacks has a single argument: the matched token, and will return a token.
#
pos($DATA) = undef;
while ($DATA =~ m/\G.*?^(\s*:lexeme\s*~\s*(\w+)\s*$)/smg) {
  my $name = substr($DATA, $-[2], $+[2] - $-[2]);
  my $lexemeLine = substr($DATA, $-[1], $+[1] - $-[1]);
  if (! exists($RE{$name})) {
    croak "Missing RE for $name";
  }
  my $new = "$lexemeLine pause => before event => '$name'";
  substr($DATA, $-[1], length($lexemeLine), $new);
  pos($DATA) = $-[1] + length($new);
}

#
# There are several DIFFERENT top-level productions in the XML grammar
#
our %G = ();
foreach (qw/document extSubset extSubsetDecl Name Names Nmtoken Nmtokens NotationDecl PublicID Char/) {
  my $top = $_;
  $DATA =~ s/(:start\s*::=\s*)(.*)/$1$top/g;
  #print STDERR "Compiling $top production\n";
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

  my %alternatives = ();
  pos($input) = $pos;
  my $longest = 0;
  my $value = '';
  foreach (@{$recce->events()}) {
    my ($name) = @{$_};
    if (exists($RE{$name})) {
      #
      # This is a prediction event. By definition 100% of the prediction events are for 100% of the lexemes.
      #
      if ($input =~ $RE{$name}) {
        $alternatives{$name}{value} = substr($input, $-[0], $+[0] - $-[0]);
        $alternatives{$name}{length} = length($alternatives{$name}{value});
        if ($alternatives{$name}{length} > $longest) {
          $longest = $alternatives{$name}{length};
	  $value = $alternatives{$name}{value};
        }
      }
    }
  }

  if (! %alternatives) {
    logCroak($recce, $input, "No alternative", $pos);
  }
  foreach (keys %alternatives) {
    my $name = $_;
    if ($alternatives{$name}{length} == $longest) {
      $recce->lexeme_alternative($name, $alternatives{$name}{value});
    }
  }
  $recce->lexeme_complete($pos, $longest);
  #
  # A lexeme_complete could generate some of the nulled events, that we want to process before doing the resume
  #
  foreach (@{$recce->events()}) {
    my ($name) = @{$_};
    if ($name eq 'TagNameEvent') {
	#
	# If not element, yet, then this is the root
	#
	if (! @{$self->{_elementStack}}) {
	    push(@{$self->{_elementStack}}, $value);
	    #
	    # For faster lookup
	    #
	    $self->{_elementHash}->{$value} = $pos;
	}
	if ($self->{_doctypedeclName} && $self->{_doctypedeclName} ne $self->{_elementStack}->[0]) {
	    # Validity constraint: Root Element Type
	    # The Name in the document type declaration must match
	    # the element type of the root element.
	    logCroak($recce, $input, "The Name in the document type declaration must match the element type <$self->{_elementStack}->[0]> of the root element", $pos);
	}
    } elsif ($name eq 'doctypedeclNameEvent') {
	$self->{_doctypedeclName}  = $value;
    }
  }
}

sub parse {
  my ($self, $input) = @_;

  my $recce = Marpa::R2::Scanless::R->new( { grammar => $G{document} } );
  my $pos = $recce->read(\$input);
  my $max = length($input);
  $self->{_elementStack} = [];
  $self->{_elementHash} = {};
  $self->{_doctypedeclName} = '';
  while ($pos < $max) {
    $self->_doEvents($input, $pos, $recce);
    $pos = $recce->resume();
  }
}

1;
__DATA__
inaccessible is ok by default

:start ::=      # TO BE FILLED DYNAMICALLY

:lexeme ~ X20
:lexeme ~ S
:lexeme ~ NAME
:lexeme ~ CHAR
:lexeme ~ NMTOKEN
:lexeme ~ SYSTEMLITERAL
:lexeme ~ PUBIDLITERAL
:lexeme ~ CHARDATA
:lexeme ~ COMMENT_BEG
:lexeme ~ COMMENT_END
:lexeme ~ COMMENT
:lexeme ~ PI_BEG
:lexeme ~ PI_END
:lexeme ~ PITARGET
:lexeme ~ PI_INTERIOR
:lexeme ~ CDSTART
:lexeme ~ CDEND
:lexeme ~ XML_BEG
:lexeme ~ XML_END
:lexeme ~ VERSION
:lexeme ~ DQUOTE
:lexeme ~ SQUOTE
:lexeme ~ EQUAL
:lexeme ~ VERSIONNUM
:lexeme ~ DOCTYPE_BEG
:lexeme ~ DOCTYPE_END
:lexeme ~ LBRACKET
:lexeme ~ RBRACKET
:lexeme ~ STANDALONE
:lexeme ~ YES
:lexeme ~ NO
:lexeme ~ STAG_BEG
:lexeme ~ STAG_END
:lexeme ~ ETAG_BEG
:lexeme ~ ETAG_END
:lexeme ~ EMPTYELEMTAG_BEG
:lexeme ~ EMPTYELEMTAG_END
:lexeme ~ ELEMENTDECL_BEG
:lexeme ~ ELEMENTDECL_END
:lexeme ~ EMPTY
:lexeme ~ ANY
:lexeme ~ QUESTION_MARK
:lexeme ~ STAR
:lexeme ~ PLUS
:lexeme ~ LPAREN
:lexeme ~ RPAREN
:lexeme ~ PIPE
:lexeme ~ COMMA
:lexeme ~ RPARENSTAR
:lexeme ~ PCDATA
:lexeme ~ ATTLIST_BEG
:lexeme ~ ATTLIST_END
:lexeme ~ CDATA
:lexeme ~ TYPE_ID
:lexeme ~ TYPE_IDREF
:lexeme ~ TYPE_IDREFS
:lexeme ~ TYPE_ENTITY
:lexeme ~ TYPE_ENTITIES
:lexeme ~ TYPE_NMTOKEN
:lexeme ~ TYPE_NMTOKENS
:lexeme ~ NOTATION
:lexeme ~ REQUIRED
:lexeme ~ IMPLIED
:lexeme ~ FIXED
:lexeme ~ SECT_BEG
:lexeme ~ INCLUDE
:lexeme ~ SECT_END
:lexeme ~ IGNORE
:lexeme ~ IGNORE_INTERIOR
:lexeme ~ CHARREF
:lexeme ~ ENTITYREF
:lexeme ~ PEREFERENCE
:lexeme ~ EDECL_BEG
:lexeme ~ EDECL_END
:lexeme ~ PERCENT
:lexeme ~ SYSTEM
:lexeme ~ PUBLIC
:lexeme ~ NDATA
:lexeme ~ ENCODING
:lexeme ~ ENCNAME
:lexeme ~ NOTATION_BEG
:lexeme ~ NOTATION_END
:lexeme ~ ENTITYCHARDQUOTE
:lexeme ~ ENTITYCHARSQUOTE
:lexeme ~ ATTCHARDQUOTE
:lexeme ~ ATTCHARSQUOTE

document      ::= prolog element Misc_any
Char          ::= CHAR
Name          ::= NAME
Names         ::= Name+ separator => x20
Nmtoken       ::= NMTOKEN
Nmtokens      ::= Nmtoken+ separator => x20
EntityValue   ::= DQUOTE EntityValue_interior_dquote_unit_any DQUOTE
                | SQUOTE EntityValue_interior_squote_unit_any SQUOTE
AttValue      ::= DQUOTE AttValue_interior_dquote_unit_any DQUOTE
                | SQUOTE AttValue_interior_squote_unit_any SQUOTE
SystemLiteral ::= SYSTEMLITERAL
PubidLiteral  ::= PUBIDLITERAL
CharData      ::= CHARDATA
Comment       ::= COMMENT_BEG COMMENT COMMENT_END
PITarget      ::= PITARGET
PI            ::= PI_BEG PITarget               PI_END
                | PI_BEG PITarget S PI_INTERIOR PI_END
CDSect        ::= CDSTART CData CDEND
CData         ::= CHARDATA*
prolog        ::= XMLDecl_maybe Misc_any
                | XMLDecl_maybe Misc_any doctypedecl Misc_any
XMLDecl       ::= XML_BEG VersionInfo EncodingDecl_maybe SDDecl_maybe S_maybe XML_END
VersionInfo   ::= S VERSION Eq SQUOTE VersionNum SQUOTE
                | S VERSION Eq DQUOTE VersionNum DQUOTE
Eq            ::= S_maybe EQUAL S_maybe
VersionNum    ::= VERSIONNUM
Misc          ::= Comment
                | PI
                | S
doctypedecl   ::= DOCTYPE_BEG S Name (<doctypedeclNameEvent>) S_maybe                                     DOCTYPE_END
                | DOCTYPE_BEG S Name (<doctypedeclNameEvent>) S_maybe LBRACKET intSubset RBRACKET S_maybe DOCTYPE_END
                | DOCTYPE_BEG S Name (<doctypedeclNameEvent>) S ExternalID S_maybe                                     DOCTYPE_END
                | DOCTYPE_BEG S Name (<doctypedeclNameEvent>) S ExternalID S_maybe LBRACKET intSubset RBRACKET S_maybe DOCTYPE_END
DeclSep       ::= PEReference
                | S
intSubset     ::= intSubset_unit_any
markupdecl    ::= elementdecl
                | AttlistDecl
                | EntityDecl
                | NotationDecl
                | PI
                | Comment
extSubset     ::=          extSubsetDecl
                | TextDecl extSubsetDecl
extSubsetDecl ::= extSubsetDecl_unit_any
SDDecl        ::= S STANDALONE Eq SQUOTE YES SQUOTE
                | S STANDALONE Eq SQUOTE NO  SQUOTE
                | S STANDALONE Eq DQUOTE YES DQUOTE
                | S STANDALONE Eq DQUOTE NO  DQUOTE
element       ::= EmptyElemTag
                | STag content ETag
STag          ::= STAG_BEG Name <TagNameEvent> STag_interior_any S_maybe STAG_END
Attribute     ::= Name Eq AttValue
ETag          ::= ETAG_BEG Name S_maybe ETAG_END
content       ::= CharData_maybe content_interior_any
EmptyElemTag  ::= EMPTYELEMTAG_BEG Name <TagNameEvent> EmptyElemTag_interior_any S_maybe EMPTYELEMTAG_END
elementdecl   ::= ELEMENTDECL_BEG S Name S contentspec S_maybe ELEMENTDECL_END
contentspec   ::= EMPTY
                | ANY
                | Mixed
                | children
children      ::= choice Quantifier_maybe
                | seq Quantifier_maybe
cp            ::= Name Quantifier_maybe
                | choice Quantifier_maybe
                | seq Quantifier_maybe
choice        ::= LPAREN S_maybe cp choice_interior_many S_maybe RPAREN
seq           ::= LPAREN S_maybe cp seq_interior_any S_maybe RPAREN
Mixed         ::= LPAREN S_maybe PCDATA Mixed_interior_any S_maybe RPARENSTAR
                | LPAREN S_maybe PCDATA S_maybe RPAREN
AttlistDecl   ::= ATTLIST_BEG S Name AttDef_any S_maybe ATTLIST_END
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
NotationType  ::= NOTATION S LPAREN S_maybe Name NotationType_interior_any S_maybe RPAREN
Enumeration   ::= LPAREN S_maybe Nmtoken Enumeration_interior_any S_maybe RPAREN
DefaultDecl   ::= REQUIRED
                | IMPLIED
                |         AttValue
                | FIXED S AttValue
conditionalSect ::= includeSect
                  | ignoreSect
includeSect   ::= SECT_BEG S_maybe INCLUDE S_maybe LBRACKET extSubsetDecl SECT_END
ignoreSect    ::= SECT_BEG S_maybe IGNORE S_maybe LBRACKET ignoreSectContents_any SECT_END
ignoreSectContents ::= Ignore ignoreSectContents_interior_any
Ignore        ::=  IGNORE_INTERIOR
CharRef       ::= CHARREF
Reference     ::= EntityRef
                | CharRef
EntityRef     ::= ENTITYREF
PEReference   ::= PEREFERENCE
EntityDecl    ::= GEDecl
                | PEDecl
GEDecl	      ::= EDECL_BEG S Name S EntityDef S_maybe EDECL_END
PEDecl        ::= EDECL_BEG S PERCENT S Name S PEDef S_maybe EDECL_END
EntityDef     ::= EntityValue
                | ExternalID
                | ExternalID NDataDecl
PEDef         ::= EntityValue
                | ExternalID
ExternalID    ::= SYSTEM S SystemLiteral
                | PUBLIC S PubidLiteral S SystemLiteral
NDataDecl     ::= S NDATA S Name
TextDecl      ::= XML_BEG VersionInfo_maybe EncodingDecl S_maybe XML_END
extParsedEnt  ::=          content
                | TextDecl content
EncodingDecl  ::= S ENCODING Eq DQUOTE EncName DQUOTE
                | S ENCODING Eq SQUOTE EncName SQUOTE
EncName       ::= ENCNAME
NotationDecl  ::= NOTATION_BEG S Name S ExternalID S_maybe NOTATION_END
                | NOTATION_BEG S Name S PublicID   S_maybe NOTATION_END
PublicID      ::= PUBLIC S PubidLiteral
#
# G1 helpers
#
x20      ::= X20
EntityValue_interior_dquote_unit ::= ENTITYCHARDQUOTE | PEReference | Reference
EntityValue_interior_dquote_unit_any ::= EntityValue_interior_dquote_unit*
EntityValue_interior_squote_unit ::= ENTITYCHARSQUOTE | PEReference | Reference
EntityValue_interior_squote_unit_any ::= EntityValue_interior_squote_unit*
AttValue_interior_dquote_unit ::= ATTCHARDQUOTE | Reference
AttValue_interior_dquote_unit_any ::= AttValue_interior_dquote_unit*
AttValue_interior_squote_unit ::= ATTCHARSQUOTE | Reference
AttValue_interior_squote_unit_any ::= AttValue_interior_squote_unit*
XMLDecl_maybe ::= XMLDecl
XMLDecl_maybe ::=
Misc_any ::= Misc*
EncodingDecl_maybe ::= EncodingDecl
EncodingDecl_maybe ::=
SDDecl_maybe ::= SDDecl
SDDecl_maybe ::=
S_maybe ::= S
S_maybe ::=
content_interior ::= element CharData_maybe
                   | Reference CharData_maybe
                   | CDSect CharData_maybe
                   | PI CharData_maybe
                   | Comment CharData_maybe
content_interior_any ::= content_interior*
intSubset_unit ::= markupdecl
                  | DeclSep
intSubset_unit_any ::= intSubset_unit*
extSubsetDecl_unit ::= markupdecl
                     | conditionalSect
                     | DeclSep
extSubsetDecl_unit_any ::= extSubsetDecl_unit*
STag_interior ::= S Attribute
STag_interior_any ::= STag_interior*
CharData_maybe ::= CharData
CharData_maybe ::=
EmptyElemTag_interior ::= S Attribute
EmptyElemTag_interior_any ::= EmptyElemTag_interior*
Quantifier ::= QUESTION_MARK
             | STAR
             | PLUS
Quantifier_maybe ::= Quantifier
Quantifier_maybe ::=
choice_interior ::= S_maybe PIPE S_maybe cp
choice_interior_many ::= choice_interior+
seq_interior ::= S_maybe COMMA S_maybe cp
seq_interior_any ::= seq_interior*
Mixed_interior ::= S_maybe PIPE S_maybe Name
Mixed_interior_any ::= Mixed_interior*
AttDef_any ::= AttDef*
NotationType_interior ::= S_maybe PIPE S_maybe Name
NotationType_interior_any ::= NotationType_interior*
Enumeration_interior ::= S_maybe PIPE S_maybe Nmtoken
Enumeration_interior_any ::= Enumeration_interior*
ignoreSectContents_any ::= ignoreSectContents*
ignoreSectContents_interior ::= SECT_BEG ignoreSectContents SECT_END Ignore
ignoreSectContents_interior_any ::= ignoreSectContents_interior*
VersionInfo_maybe ::= VersionInfo
VersionInfo_maybe ::=
#
# Event helper
#

event 'TagNameEvent' = nulled <TagNameEvent>
TagNameEvent ::=
event 'doctypedeclNameEvent' = nulled <doctypedeclNameEvent>
doctypedeclNameEvent ::=
#
# Dummy lexemes: tokenization is done is user space
#
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
ATTCHARDQUOTE    ~ _DUMMY
ATTCHARSQUOTE    ~ _DUMMY
