use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) util methods

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/%TOKEN/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

#
# Util regexpes
#
our $REG_NAMESTARTCHAR = qr/(?:[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}])/;
our $REG_NAMECHAR = qr/(?:${REG_NAMESTARTCHAR}|[-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}])/,
our $REG_PUBIDCHAR_DQUOTE = qr/(?:[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%])/;
our $REG_PUBIDCHAR_SQUOTE = qr/(?:[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%])/;
our $REG_CHARCOMMENT = qr/(?:[\x{9}\x{A}\x{D}\x{20}-\x{2C}\x{2E}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}])/,
our $REG_CHAR = qr/(?:[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}])/;
our $REG_NAME = qr/(?:${REG_NAMESTARTCHAR}${REG_NAMECHAR}*)/;
#
# Precompiled regexp. This is preferred v.s. the /o modifier.
#
our $REG_TOK_S                = qr/\G(?:[\x{20}\x{9}\x{D}\x{A}]+)/;
our $REG_TOK_NAME             = qr/\G(?:${REG_NAME})/;
our $REG_TOK_CHAR             = qr/\G(?:${REG_CHAR})/;
our $REG_TOK_NMTOKEN          = qr/\G(?:${REG_NAMECHAR}+)/;
our $REG_TOK_SYSTEMLITERAL    = qr/\G(?:(?:"[^"]*")|(?:'[^']*'))/;
our $REG_TOK_PUBIDLITERAL     = qr/\G(?:(?:"${REG_PUBIDCHAR_DQUOTE}*")|(?:'${REG_PUBIDCHAR_SQUOTE}*'))/;
our $REG_TOK_CHARDATA         = qr/\G(?:[^<&]*)/;
our $REG_TOK_COMMENT          = qr/\G(?:(?:${REG_CHARCOMMENT})|(?:\-${REG_CHARCOMMENT}))*/;
our $REG_TOK_PITARGET         = qr/\G(?:${REG_NAME})/;
our $REG_TOK_PI_INTERIOR      = qr/\G(?:${REG_CHAR})/;
our $REG_TOK_VERSIONNUM       = qr/\G(?:1\.[0-9]+)/;
our $REG_TOK_IGNORE_INTERIOR  = qr/\G(?:${REG_CHAR})/;
our $REG_TOK_CHARREF          = qr/\G(?:(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))/;
our $REG_TOK_ENTITYREF        = qr/\G(?:&${REG_NAME};)/;
our $REG_TOK_PEREFERENCE      = qr/\G(?:%${REG_NAME};)/;
our $REG_TOK_ENCNAME          = qr/\G(?:[A-Za-z][A-Za-z0-9._-]*)/;
our $REG_TOK_ENTITYCHARDQUOTE = qr/\G(?:[^%&"])/;
our $REG_TOK_ENTITYCHARSQUOTE = qr/\G(?:[^%&'])/;
our $REG_TOK_ATTCHARDQUOTE    = qr/\G(?:[^<&"])/;
our $REG_TOK_ATTCHARSQUOTE    = qr/\G(?:[^<&'])/;
#
# For speedup
#
our $ORD_PERCENT = ord('%');
our $ORD_LEFT    = ord('<');
our $ORD_AND     = ord('&');
our $ORD_SQUOTE  = ord('\'');
our $ORD_DQUOTE  = ord('"');
#
# Routines when the check is more than a single call to regexp or string comparison,
# or when the cost of regexp can be supressed.
#
our $SUB_TOK_ENTITYCHARDQUOTE = sub {
  my $c = substr($_[0], $_[1], 1);
  my $ordc = ord($c);
  if ($ordc == $ORD_PERCENT || $ordc == $ORD_AND || $ordc == $ORD_DQUOTE) {
    return undef;
  } else {
    return $c;
  }
};
our $SUB_TOK_ENTITYCHARSQUOTE = sub {
  my $c = substr($_[0], $_[1], 1);
  my $ordc = ord($c);
  if ($ordc == $ORD_PERCENT || $ordc == $ORD_AND || $ordc == $ORD_SQUOTE) {
    return undef;
  } else {
    return $c;
  }
};
our $SUB_TOK_ATTCHARDQUOTE = sub {
  my $c = substr($_[0], $_[1], 1);
  my $ordc = ord($c);
  if ($ordc == $ORD_LEFT || $ordc == $ORD_AND || $ordc == $ORD_DQUOTE) {
    return undef;
  } else {
    return $c;
  }
};
our $SUB_TOK_ATTCHARSQUOTE = sub {
  my $c = substr($_[0], $_[1], 1);
  my $ordc = ord($c);
  if ($ordc == $ORD_LEFT || $ordc == $ORD_AND || $ordc == $ORD_SQUOTE) {
    return undef;
  } else {
    return $c;
  }
};
#
# Hardcoded strings
#
our $STR_TOK_X20              = "\x{20}";
our $STR_TOK_COMMENT_BEG      = '<!--';
our $STR_TOK_COMMENT_END      = '-->';
our $STR_TOK_PI_BEG           = '<?';
our $STR_TOK_PI_END           = '?>';
our $STR_TOK_CDSTART          = '<![CDATA[';
our $STR_TOK_CDEND            = ']]>';
our $STR_TOK_XML_BEG          = '<?xml';
our $STR_TOK_XML_END          = '?>';
our $STR_TOK_VERSION          = 'version';
our $STR_TOK_DQUOTE           = '"';
our $STR_TOK_SQUOTE           = "'";
our $STR_TOK_EQUAL            = '=';
our $STR_TOK_DOCTYPE_BEG      = '<!DOCTYPE';
our $STR_TOK_DOCTYPE_END      = '>';
our $STR_TOK_LBRACKET         = '[';
our $STR_TOK_RBRACKET         = ']';
our $STR_TOK_STANDALONE       = 'standalone';
our $STR_TOK_YES              = 'yes';
our $STR_TOK_NO               = 'no';
our $STR_TOK_STAG_BEG         = '<';
our $STR_TOK_STAG_END         = '>';
our $STR_TOK_ETAG_BEG         = '</';
our $STR_TOK_ETAG_END         = '>';
our $STR_TOK_EMPTYELEMTAG_BEG = '<';
our $STR_TOK_EMPTYELEMTAG_END = '/>';
our $STR_TOK_ELEMENTDECL_BEG  = '<!ELEMENT';
our $STR_TOK_ELEMENTDECL_END  = '>';
our $STR_TOK_EMPTY            = 'EMPTY';
our $STR_TOK_ANY              = 'ANY';
our $STR_TOK_QUESTION_MARK    = '?';
our $STR_TOK_STAR             = '*';
our $STR_TOK_PLUS             = '+';
our $STR_TOK_LPAREN           = '(';
our $STR_TOK_RPAREN           = ')';
our $STR_TOK_RPARENSTAR       = '(*';
our $STR_TOK_PIPE             = '|';
our $STR_TOK_COMMA            = ',';
our $STR_TOK_PCDATA           = '#PCDATA';
our $STR_TOK_ATTLIST_BEG      = '<!ATTLIST';
our $STR_TOK_ATTLIST_END      = '>';
our $STR_TOK_CDATA            = 'CDATA';
our $STR_TOK_TYPE_ID          = 'ID';
our $STR_TOK_TYPE_IDREF       = 'IDREF';
our $STR_TOK_TYPE_IDREFS      = 'IDREFS';
our $STR_TOK_TYPE_ENTITY      = 'ENTITY';
our $STR_TOK_TYPE_ENTITIES    = 'ENTITIES';
our $STR_TOK_TYPE_NMTOKEN     = 'NMTOKEN';
our $STR_TOK_TYPE_NMTOKENS    = 'NMTOKENS';
our $STR_TOK_NOTATION         = 'NOTATION';
our $STR_TOK_REQUIRED         = '#REQUIRED';
our $STR_TOK_IMPLIED          = '#IMPLIED';
our $STR_TOK_FIXED            = '#FIXED';
our $STR_TOK_SECT_BEG         = '<![';
our $STR_TOK_INCLUDE          = 'INCLUDE';
our $STR_TOK_SECT_END         = ']]>';
our $STR_TOK_IGNORE           = 'IGNORE';
our $STR_TOK_EDECL_BEG        = '<!ENTITY';
our $STR_TOK_EDECL_END        = '>';
our $STR_TOK_PERCENT          = '%';
our $STR_TOK_SYSTEM           = 'SYSTEM';
our $STR_TOK_PUBLIC           = 'PUBLIC';
our $STR_TOK_NDATA            = 'NDATA';
our $STR_TOK_ENCODING         = 'encoding';
our $STR_TOK_NOTATION_BEG     = '<!NOTATION';
our $STR_TOK_NOTATION_END     = '>';
#
# All possible tokens are listed here.
# Every hash value is a CODE reference that has in input:
# $input : the source being parsed
# $pos   : the current position in the source
# The return value will always be the token if it matches, or undef
#

#
# Generic routines handling RE or STRING: same arguments as before, plus the RE or the STRING in $_[2]
#
our $REG_process = sub {
  pos($_[0]) = $_[1];
  if ($_[0] =~ /$_[2]/g) {
    return substr($_[0], $-[0], $+[0] - $-[0]);
  }
  return undef;
};

our $STR_process = sub {
  if (index($_[0], $_[2], $_[1]) == $_[1]) {
    return $_[2];
  } else {
    return undef;
  }
};

our %TOKEN = (
           X20              => sub { return &$STR_process(@_, $STR_TOK_X20) },
           S                => sub { return &$REG_process(@_, $REG_TOK_S) },
           NAME             => sub { return &$REG_process(@_, $REG_TOK_NAME) },
           CHAR             => sub { return &$REG_process(@_, $REG_TOK_CHAR) },
           NMTOKEN          => sub { return &$REG_process(@_, $REG_TOK_NMTOKEN) },
           SYSTEMLITERAL    => sub { return &$REG_process(@_, $REG_TOK_SYSTEMLITERAL) },
           PUBIDLITERAL     => sub { return &$REG_process(@_, $REG_TOK_PUBIDLITERAL) },
           CHARDATA         => sub { return &$REG_process(@_, $REG_TOK_CHARDATA) },
           COMMENT_BEG      => sub { return &$STR_process(@_, $STR_TOK_COMMENT_BEG) },
           COMMENT_END      => sub { return &$STR_process(@_, $STR_TOK_COMMENT_END) },
           COMMENT          => sub { return &$REG_process(@_, $REG_TOK_COMMENT) },
           PI_BEG           => sub { return &$STR_process(@_, $STR_TOK_PI_BEG) },
           PI_END           => sub { return &$STR_process(@_, $STR_TOK_PI_END) },
           PITARGET         => sub { return &$REG_process(@_, $REG_TOK_PITARGET) },
           PI_INTERIOR      => sub { return &$REG_process(@_, $REG_TOK_PI_INTERIOR) },
           CDSTART          => sub { return &$STR_process(@_, $STR_TOK_CDSTART) },
           CDEND            => sub { return &$STR_process(@_, $STR_TOK_CDEND) },
           XML_BEG          => sub { return &$STR_process(@_, $STR_TOK_XML_BEG) },
           XML_END          => sub { return &$STR_process(@_, $STR_TOK_XML_END) },
           VERSION          => sub { return &$STR_process(@_, $STR_TOK_VERSION) },
           DQUOTE           => sub { return &$STR_process(@_, $STR_TOK_DQUOTE) },
           SQUOTE           => sub { return &$STR_process(@_, $STR_TOK_SQUOTE) },
           EQUAL            => sub { return &$STR_process(@_, $STR_TOK_EQUAL) },
           VERSIONNUM       => sub { return &$REG_process(@_, $REG_TOK_VERSIONNUM) },
           DOCTYPE_BEG      => sub { return &$STR_process(@_, $STR_TOK_DOCTYPE_BEG) },
           DOCTYPE_END      => sub { return &$STR_process(@_, $STR_TOK_DOCTYPE_END) },
           LBRACKET         => sub { return &$STR_process(@_, $STR_TOK_LBRACKET) },
           RBRACKET         => sub { return &$STR_process(@_, $STR_TOK_RBRACKET) },
           STANDALONE       => sub { return &$STR_process(@_, $STR_TOK_STANDALONE) },
           YES              => sub { return &$STR_process(@_, $STR_TOK_YES) },
           NO               => sub { return &$STR_process(@_, $STR_TOK_NO) },
           STAG_BEG         => sub { return &$STR_process(@_, $STR_TOK_STAG_BEG) },
           STAG_END         => sub { return &$STR_process(@_, $STR_TOK_STAG_END) },
           ETAG_BEG         => sub { return &$STR_process(@_, $STR_TOK_ETAG_BEG) },
           ETAG_END         => sub { return &$STR_process(@_, $STR_TOK_ETAG_END) },
           EMPTYELEMTAG_BEG => sub { return &$STR_process(@_, $STR_TOK_EMPTYELEMTAG_BEG) },
           EMPTYELEMTAG_END => sub { return &$STR_process(@_, $STR_TOK_EMPTYELEMTAG_END) },
           ELEMENTDECL_BEG  => sub { return &$STR_process(@_, $STR_TOK_ELEMENTDECL_BEG) },
           ELEMENTDECL_END  => sub { return &$STR_process(@_, $STR_TOK_ELEMENTDECL_END) },
           EMPTY            => sub { return &$STR_process(@_, $STR_TOK_EMPTY) },
           ANY              => sub { return &$STR_process(@_, $STR_TOK_ANY) },
           QUESTION_MARK    => sub { return &$STR_process(@_, $STR_TOK_QUESTION_MARK) },
           STAR             => sub { return &$STR_process(@_, $STR_TOK_STAR) },
           PLUS             => sub { return &$STR_process(@_, $STR_TOK_PLUS) },
           LPAREN           => sub { return &$STR_process(@_, $STR_TOK_LPAREN) },
           RPAREN           => sub { return &$STR_process(@_, $STR_TOK_RPAREN) },
           RPARENSTAR       => sub { return &$STR_process(@_, $STR_TOK_RPARENSTAR) },
           PIPE             => sub { return &$STR_process(@_, $STR_TOK_PIPE) },
           COMMA            => sub { return &$STR_process(@_, $STR_TOK_COMMA) },
           PCDATA           => sub { return &$STR_process(@_, $STR_TOK_PCDATA) },
           ATTLIST_BEG      => sub { return &$STR_process(@_, $STR_TOK_ATTLIST_BEG) },
           ATTLIST_END      => sub { return &$STR_process(@_, $STR_TOK_ATTLIST_END) },
           CDATA            => sub { return &$STR_process(@_, $STR_TOK_CDATA) },
           TYPE_ID          => sub { return &$STR_process(@_, $STR_TOK_TYPE_ID) },
           TYPE_IDREF       => sub { return &$STR_process(@_, $STR_TOK_TYPE_IDREF) },
           TYPE_IDREFS      => sub { return &$STR_process(@_, $STR_TOK_TYPE_IDREFS) },
           TYPE_ENTITY      => sub { return &$STR_process(@_, $STR_TOK_TYPE_ENTITY) },
           TYPE_ENTITIES    => sub { return &$STR_process(@_, $STR_TOK_TYPE_ENTITIES) },
           TYPE_NMTOKEN     => sub { return &$STR_process(@_, $STR_TOK_TYPE_NMTOKEN) },
           TYPE_NMTOKENS    => sub { return &$STR_process(@_, $STR_TOK_TYPE_NMTOKENS) },
           NOTATION         => sub { return &$STR_process(@_, $STR_TOK_NOTATION) },
           REQUIRED         => sub { return &$STR_process(@_, $STR_TOK_REQUIRED) },
           IMPLIED          => sub { return &$STR_process(@_, $STR_TOK_IMPLIED) },
           FIXED            => sub { return &$STR_process(@_, $STR_TOK_FIXED) },
           SECT_BEG         => sub { return &$STR_process(@_, $STR_TOK_SECT_BEG) },
           INCLUDE          => sub { return &$STR_process(@_, $STR_TOK_INCLUDE) },
           SECT_END         => sub { return &$STR_process(@_, $STR_TOK_SECT_END) },
           IGNORE           => sub { return &$STR_process(@_, $STR_TOK_IGNORE) },
           IGNORE_INTERIOR  => sub { return &$REG_process(@_, $REG_TOK_IGNORE_INTERIOR) },
           CHARREF          => sub { return &$REG_process(@_, $REG_TOK_CHARREF) },
           ENTITYREF        => sub { return &$REG_process(@_, $REG_TOK_ENTITYREF) },
           PEREFERENCE      => sub { return &$REG_process(@_, $REG_TOK_PEREFERENCE) },
           EDECL_BEG        => sub { return &$STR_process(@_, $STR_TOK_EDECL_BEG) },
           EDECL_END        => sub { return &$STR_process(@_, $STR_TOK_EDECL_END) },
           PERCENT          => sub { return &$STR_process(@_, $STR_TOK_PERCENT) },
           SYSTEM           => sub { return &$STR_process(@_, $STR_TOK_SYSTEM) },
           PUBLIC           => sub { return &$STR_process(@_, $STR_TOK_PUBLIC) },
           NDATA            => sub { return &$STR_process(@_, $STR_TOK_NDATA) },
           ENCODING         => sub { return &$STR_process(@_, $STR_TOK_ENCODING) },
           ENCNAME          => sub { return &$REG_process(@_, $REG_TOK_ENCNAME) },
           NOTATION_BEG     => sub { return &$STR_process(@_, $STR_TOK_NOTATION_BEG) },
           NOTATION_END     => sub { return &$STR_process(@_, $STR_TOK_NOTATION_END) },
           ENTITYCHARDQUOTE => sub { return &$SUB_TOK_ENTITYCHARDQUOTE(@_) },
           ENTITYCHARSQUOTE => sub { return &$SUB_TOK_ENTITYCHARSQUOTE(@_) },
           ATTCHARDQUOTE    => sub { return &$SUB_TOK_ATTCHARDQUOTE(@_) },
           ATTCHARSQUOTE    => sub { return &$SUB_TOK_ATTCHARSQUOTE(@_) },
          );

1;
