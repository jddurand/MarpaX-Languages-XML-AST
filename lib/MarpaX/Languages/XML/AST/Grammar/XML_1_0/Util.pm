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
our $REG_TOK_CDATA            = qr/\G(?:[^<&]*)/;
our $REG_TOK_COMMENT          = qr/\G(?:(?:${REG_CHARCOMMENT})|(?:\-${REG_CHARCOMMENT}))*/;
our $REG_TOK_PITARGET         = qr/\G(?:${REG_NAME})/;
our $REG_TOK_PI_INTERIOR      = qr/\G(?:${REG_CHAR})/;
our $REG_TOK_VERSIONNUM       = qr/\G(?:1\.[0-9]+)/;
our $REG_TOK_IGNORE_INTERIOR  = qr/\G(?:${REG_CHAR})/;
our $REG_TOK_CHARREF          = qr/\G(?:(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))/;
our $REG_TOK_ENTITYREF        = qr/\G(?:&${REG_NAME};)/;
our $REG_TOK_PEREFERENCE      = qr/\G(?:%${REG_NAME};)/;
our $REG_TOK_REFERENCE        = qr/\G(?:$REG_TOK_ENTITYREF|$REG_TOK_CHARREF)/;
our $REG_TOK_ENCNAME          = qr/\G(?:[A-Za-z][A-Za-z0-9._-]*)/;
our $REG_TOK_ATTVALUE         = qr/\G(?:(?:"(?:[^<&"]|(?:&${REG_NAME};)|(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))*")|(?:'(?:[^<&']|(?:&${REG_NAME};)|(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))*'))/;
our $REG_TOK_ENTITYVALUE      = qr/\G(?:(?:"(?:[^%&"]|(?:%${REG_NAME};)|(?:&${REG_NAME};)|(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))*")|(?:'(?:[^%&']|(?:%${REG_NAME};)|(?:&${REG_NAME};)|(?:&#[0-9]+;)|(?:&#x[0-9a-fA-F]+;))*'))/;
#
# Routines when the check is more than a single call to regexp or string comparison,
# or when the cost of regexp can be supressed.
#
#
# Hardcoded strings and lengths
#
our $STR_TOK_X20              = "\x{20}";     our $LEN_TOK_X20 = length($STR_TOK_X20);
our $STR_TOK_COMMENT_BEG      = '<!--';       our $LEN_TOK_COMMENT_BEG = length($STR_TOK_COMMENT_BEG);
our $STR_TOK_COMMENT_END      = '-->';        our $LEN_TOK_COMMENT_END = length($STR_TOK_COMMENT_END);
our $STR_TOK_PI_BEG           = '<?';         our $LEN_TOK_PI_BEG = length($STR_TOK_PI_BEG);
our $STR_TOK_PI_END           = '?>';         our $LEN_TOK_PI_END = length($STR_TOK_PI_END);
our $STR_TOK_CDSTART          = '<![CDATA[';  our $LEN_TOK_CDSTART = length($STR_TOK_CDSTART);
our $STR_TOK_CDEND            = ']]>';        our $LEN_TOK_CDEND = length($STR_TOK_CDEND);
our $STR_TOK_XML_BEG          = '<?xml';      our $LEN_TOK_XML_BEG = length($STR_TOK_XML_BEG);
our $STR_TOK_XML_END          = '?>';         our $LEN_TOK_XML_END = length($STR_TOK_XML_END);
our $STR_TOK_VERSION          = 'version';    our $LEN_TOK_VERSION = length($STR_TOK_VERSION);
our $STR_TOK_DQUOTE           = '"';          our $LEN_TOK_DQUOTE = length($STR_TOK_DQUOTE);
our $STR_TOK_SQUOTE           = "'";          our $LEN_TOK_SQUOTE = length($STR_TOK_SQUOTE);
our $STR_TOK_EQUAL            = '=';          our $LEN_TOK_EQUAL = length($STR_TOK_EQUAL);
our $STR_TOK_DOCTYPE_BEG      = '<!DOCTYPE';  our $LEN_TOK_DOCTYPE_BEG = length($STR_TOK_DOCTYPE_BEG);
our $STR_TOK_DOCTYPE_END      = '>';          our $LEN_TOK_DOCTYPE_END = length($STR_TOK_DOCTYPE_END);
our $STR_TOK_LBRACKET         = '[';          our $LEN_TOK_LBRACKET = length($STR_TOK_LBRACKET);
our $STR_TOK_RBRACKET         = ']';          our $LEN_TOK_RBRACKET = length($STR_TOK_RBRACKET);
our $STR_TOK_STANDALONE       = 'standalone'; our $LEN_TOK_STANDALONE = length($STR_TOK_STANDALONE);
our $STR_TOK_YES              = 'yes';        our $LEN_TOK_YES = length($STR_TOK_YES);
our $STR_TOK_NO               = 'no';         our $LEN_TOK_NO = length($STR_TOK_NO);
our $STR_TOK_STAG_BEG         = '<';          our $LEN_TOK_STAG_BEG = length($STR_TOK_STAG_BEG);
our $STR_TOK_STAG_END         = '>';          our $LEN_TOK_STAG_END = length($STR_TOK_STAG_END);
our $STR_TOK_ETAG_BEG         = '</';         our $LEN_TOK_ETAG_BEG = length($STR_TOK_ETAG_BEG);
our $STR_TOK_ETAG_END         = '>';          our $LEN_TOK_ETAG_END = length($STR_TOK_ETAG_END);
our $STR_TOK_EMPTYELEMTAG_BEG = '<';          our $LEN_TOK_EMPTYELEMTAG_BEG = length($STR_TOK_EMPTYELEMTAG_BEG);
our $STR_TOK_EMPTYELEMTAG_END = '/>';         our $LEN_TOK_EMPTYELEMTAG_END = length($STR_TOK_EMPTYELEMTAG_END);
our $STR_TOK_ELEMENTDECL_BEG  = '<!ELEMENT';  our $LEN_TOK_ELEMENTDECL_BEG = length($STR_TOK_ELEMENTDECL_BEG);
our $STR_TOK_ELEMENTDECL_END  = '>';          our $LEN_TOK_ELEMENTDECL_END = length($STR_TOK_ELEMENTDECL_END);
our $STR_TOK_EMPTY            = 'EMPTY';      our $LEN_TOK_EMPTY = length($STR_TOK_EMPTY);
our $STR_TOK_ANY              = 'ANY';        our $LEN_TOK_ANY = length($STR_TOK_ANY);
our $STR_TOK_QUESTION_MARK    = '?';          our $LEN_TOK_QUESTION_MARK = length($STR_TOK_QUESTION_MARK);
our $STR_TOK_STAR             = '*';          our $LEN_TOK_STAR = length($STR_TOK_STAR);
our $STR_TOK_PLUS             = '+';          our $LEN_TOK_PLUS = length($STR_TOK_PLUS);
our $STR_TOK_LPAREN           = '(';          our $LEN_TOK_LPAREN = length($STR_TOK_LPAREN);
our $STR_TOK_RPAREN           = ')';          our $LEN_TOK_RPAREN = length($STR_TOK_RPAREN);
our $STR_TOK_RPARENSTAR       = '(*';         our $LEN_TOK_RPARENSTAR = length($STR_TOK_RPARENSTAR);
our $STR_TOK_PIPE             = '|';          our $LEN_TOK_PIPE = length($STR_TOK_PIPE);
our $STR_TOK_COMMA            = ',';          our $LEN_TOK_COMMA = length($STR_TOK_COMMA);
our $STR_TOK_PCDATA           = '#PCDATA';    our $LEN_TOK_PCDATA = length($STR_TOK_PCDATA);
our $STR_TOK_ATTLIST_BEG      = '<!ATTLIST';  our $LEN_TOK_ATTLIST_BEG = length($STR_TOK_ATTLIST_BEG);
our $STR_TOK_ATTLIST_END      = '>';          our $LEN_TOK_ATTLIST_END = length($STR_TOK_ATTLIST_END);
our $STR_TOK_STRINGTYPE       = 'CDATA';      our $LEN_TOK_STRINGTYPE = length($STR_TOK_STRINGTYPE);
our $STR_TOK_TYPE_ID          = 'ID';         our $LEN_TOK_TYPE_ID = length($STR_TOK_TYPE_ID);
our $STR_TOK_TYPE_IDREF       = 'IDREF';      our $LEN_TOK_TYPE_IDREF = length($STR_TOK_TYPE_IDREF);
our $STR_TOK_TYPE_IDREFS      = 'IDREFS';     our $LEN_TOK_TYPE_IDREFS = length($STR_TOK_TYPE_IDREFS);
our $STR_TOK_TYPE_ENTITY      = 'ENTITY';     our $LEN_TOK_TYPE_ENTITY = length($STR_TOK_TYPE_ENTITY);
our $STR_TOK_TYPE_ENTITIES    = 'ENTITIES';   our $LEN_TOK_TYPE_ENTITIES = length($STR_TOK_TYPE_ENTITIES);
our $STR_TOK_TYPE_NMTOKEN     = 'NMTOKEN';    our $LEN_TOK_TYPE_NMTOKEN = length($STR_TOK_TYPE_NMTOKEN);
our $STR_TOK_TYPE_NMTOKENS    = 'NMTOKENS';   our $LEN_TOK_TYPE_NMTOKENS = length($STR_TOK_TYPE_NMTOKENS);
our $STR_TOK_NOTATION         = 'NOTATION';   our $LEN_TOK_NOTATION = length($STR_TOK_NOTATION);
our $STR_TOK_REQUIRED         = '#REQUIRED';  our $LEN_TOK_REQUIRED = length($STR_TOK_REQUIRED);
our $STR_TOK_IMPLIED          = '#IMPLIED';   our $LEN_TOK_IMPLIED = length($STR_TOK_IMPLIED);
our $STR_TOK_FIXED            = '#FIXED';     our $LEN_TOK_FIXED = length($STR_TOK_FIXED);
our $STR_TOK_SECT_BEG         = '<![';        our $LEN_TOK_SECT_BEG = length($STR_TOK_SECT_BEG);
our $STR_TOK_INCLUDE          = 'INCLUDE';    our $LEN_TOK_INCLUDE = length($STR_TOK_INCLUDE);
our $STR_TOK_SECT_END         = ']]>';        our $LEN_TOK_SECT_END = length($STR_TOK_SECT_END);
our $STR_TOK_IGNORE           = 'IGNORE';     our $LEN_TOK_IGNORE = length($STR_TOK_IGNORE);
our $STR_TOK_EDECL_BEG        = '<!ENTITY';   our $LEN_TOK_EDECL_BEG = length($STR_TOK_EDECL_BEG);
our $STR_TOK_EDECL_END        = '>';          our $LEN_TOK_EDECL_END = length($STR_TOK_EDECL_END);
our $STR_TOK_PERCENT          = '%';          our $LEN_TOK_PERCENT = length($STR_TOK_PERCENT);
our $STR_TOK_SYSTEM           = 'SYSTEM';     our $LEN_TOK_SYSTEM = length($STR_TOK_SYSTEM);
our $STR_TOK_PUBLIC           = 'PUBLIC';     our $LEN_TOK_PUBLIC = length($STR_TOK_PUBLIC);
our $STR_TOK_NDATA            = 'NDATA';      our $LEN_TOK_NDATA = length($STR_TOK_NDATA);
our $STR_TOK_ENCODING         = 'encoding';   our $LEN_TOK_ENCODING = length($STR_TOK_ENCODING);
our $STR_TOK_NOTATION_BEG     = '<!NOTATION'; our $LEN_TOK_NOTATION_BEG = length($STR_TOK_NOTATION_BEG);
our $STR_TOK_NOTATION_END     = '>';          our $LEN_TOK_NOTATION_END = length($STR_TOK_NOTATION_END);
#
# All possible tokens are listed in %TOKEN hash.
#
# Every hash value is a CODE reference that has in input:
#
# $_[0] is $input : the source being parsed
# $_[1] is $pos   : the current position in the source
# $_[2] is $comp  : either a REGEXP or a SCALAR
# $_[3] is $length: length of wanted token (undef in REGEXP, length of scalar if SCALAR)
#
# The return value will always be the token if it matches, or undef.
# In case of REGEXP, it is ASSUMED that the position in input is already correct (\G)
#

our $REG_process = sub {
  # my ($input, $pos, $comp, $length) = @_;
  if ($_[0] =~ $_[2]) {
    return substr($_[0], $-[0], $+[0] - $-[0]);
  }
  return undef;
};

our $STR_process = sub {
  # my ($input, $pos, $comp, $length) = @_;
  if (substr($_[0], $_[1], $_[3]) eq $_[2]) {
    return $_[2];
  } else {
    return undef;
  }
};

our %TOKEN = (
           X20              => sub { return &$STR_process(@_, $STR_TOK_X20, $LEN_TOK_X20) },
           S                => sub { return &$REG_process(@_, $REG_TOK_S, undef) },
           NAME             => sub { return &$REG_process(@_, $REG_TOK_NAME, undef) },
           CHAR             => sub { return &$REG_process(@_, $REG_TOK_CHAR, undef) },
           NMTOKEN          => sub { return &$REG_process(@_, $REG_TOK_NMTOKEN, undef) },
           SYSTEMLITERAL    => sub { return &$REG_process(@_, $REG_TOK_SYSTEMLITERAL, undef) },
           PUBIDLITERAL     => sub { return &$REG_process(@_, $REG_TOK_PUBIDLITERAL, undef) },
           CHARDATA         => sub { return &$REG_process(@_, $REG_TOK_CHARDATA, undef) },
           CDATA            => sub { return &$REG_process(@_, $REG_TOK_CDATA, undef) },
           COMMENT_BEG      => sub { return &$STR_process(@_, $STR_TOK_COMMENT_BEG, $LEN_TOK_COMMENT_BEG) },
           COMMENT_END      => sub { return &$STR_process(@_, $STR_TOK_COMMENT_END, $LEN_TOK_COMMENT_END) },
           COMMENT          => sub { return &$REG_process(@_, $REG_TOK_COMMENT, undef) },
           PI_BEG           => sub { return &$STR_process(@_, $STR_TOK_PI_BEG, $LEN_TOK_PI_BEG) },
           PI_END           => sub { return &$STR_process(@_, $STR_TOK_PI_END, $LEN_TOK_PI_END) },
           PITARGET         => sub { return &$REG_process(@_, $REG_TOK_PITARGET, undef) },
           PI_INTERIOR      => sub { return &$REG_process(@_, $REG_TOK_PI_INTERIOR, undef) },
           CDSTART          => sub { return &$STR_process(@_, $STR_TOK_CDSTART, $LEN_TOK_CDSTART) },
           CDEND            => sub { return &$STR_process(@_, $STR_TOK_CDEND, $LEN_TOK_CDEND) },
           XML_BEG          => sub { return &$STR_process(@_, $STR_TOK_XML_BEG, $LEN_TOK_XML_BEG) },
           XML_END          => sub { return &$STR_process(@_, $STR_TOK_XML_END, $LEN_TOK_XML_END) },
           VERSION          => sub { return &$STR_process(@_, $STR_TOK_VERSION, $LEN_TOK_VERSION) },
           DQUOTE           => sub { return &$STR_process(@_, $STR_TOK_DQUOTE, $LEN_TOK_DQUOTE) },
           SQUOTE           => sub { return &$STR_process(@_, $STR_TOK_SQUOTE, $LEN_TOK_SQUOTE) },
           EQUAL            => sub { return &$STR_process(@_, $STR_TOK_EQUAL, $LEN_TOK_EQUAL) },
           VERSIONNUM       => sub { return &$REG_process(@_, $REG_TOK_VERSIONNUM, undef) },
           DOCTYPE_BEG      => sub { return &$STR_process(@_, $STR_TOK_DOCTYPE_BEG, $LEN_TOK_DOCTYPE_BEG) },
           DOCTYPE_END      => sub { return &$STR_process(@_, $STR_TOK_DOCTYPE_END, $LEN_TOK_DOCTYPE_END) },
           LBRACKET         => sub { return &$STR_process(@_, $STR_TOK_LBRACKET, $LEN_TOK_LBRACKET) },
           RBRACKET         => sub { return &$STR_process(@_, $STR_TOK_RBRACKET, $LEN_TOK_RBRACKET) },
           STANDALONE       => sub { return &$STR_process(@_, $STR_TOK_STANDALONE, $LEN_TOK_STANDALONE) },
           YES              => sub { return &$STR_process(@_, $STR_TOK_YES, $LEN_TOK_YES) },
           NO               => sub { return &$STR_process(@_, $STR_TOK_NO, $LEN_TOK_NO) },
           STAG_BEG         => sub { return &$STR_process(@_, $STR_TOK_STAG_BEG, $LEN_TOK_STAG_BEG) },
           STAG_END         => sub { return &$STR_process(@_, $STR_TOK_STAG_END, $LEN_TOK_STAG_END) },
           ETAG_BEG         => sub { return &$STR_process(@_, $STR_TOK_ETAG_BEG, $LEN_TOK_ETAG_BEG) },
           ETAG_END         => sub { return &$STR_process(@_, $STR_TOK_ETAG_END, $LEN_TOK_ETAG_END) },
           EMPTYELEMTAG_BEG => sub { return &$STR_process(@_, $STR_TOK_EMPTYELEMTAG_BEG, $LEN_TOK_EMPTYELEMTAG_BEG) },
           EMPTYELEMTAG_END => sub { return &$STR_process(@_, $STR_TOK_EMPTYELEMTAG_END, $LEN_TOK_EMPTYELEMTAG_END) },
           ELEMENTDECL_BEG  => sub { return &$STR_process(@_, $STR_TOK_ELEMENTDECL_BEG, $LEN_TOK_ELEMENTDECL_BEG) },
           ELEMENTDECL_END  => sub { return &$STR_process(@_, $STR_TOK_ELEMENTDECL_END, $LEN_TOK_ELEMENTDECL_END) },
           EMPTY            => sub { return &$STR_process(@_, $STR_TOK_EMPTY, $LEN_TOK_EMPTY) },
           ANY              => sub { return &$STR_process(@_, $STR_TOK_ANY, $LEN_TOK_ANY) },
           QUESTION_MARK    => sub { return &$STR_process(@_, $STR_TOK_QUESTION_MARK, $LEN_TOK_QUESTION_MARK) },
           STAR             => sub { return &$STR_process(@_, $STR_TOK_STAR, $LEN_TOK_STAR) },
           PLUS             => sub { return &$STR_process(@_, $STR_TOK_PLUS, $LEN_TOK_PLUS) },
           LPAREN           => sub { return &$STR_process(@_, $STR_TOK_LPAREN, $LEN_TOK_LPAREN) },
           RPAREN           => sub { return &$STR_process(@_, $STR_TOK_RPAREN, $LEN_TOK_RPAREN) },
           RPARENSTAR       => sub { return &$STR_process(@_, $STR_TOK_RPARENSTAR, $LEN_TOK_RPARENSTAR) },
           PIPE             => sub { return &$STR_process(@_, $STR_TOK_PIPE, $LEN_TOK_PIPE) },
           COMMA            => sub { return &$STR_process(@_, $STR_TOK_COMMA, $LEN_TOK_COMMA) },
           PCDATA           => sub { return &$STR_process(@_, $STR_TOK_PCDATA, $LEN_TOK_PCDATA) },
           ATTLIST_BEG      => sub { return &$STR_process(@_, $STR_TOK_ATTLIST_BEG, $LEN_TOK_ATTLIST_BEG) },
           ATTLIST_END      => sub { return &$STR_process(@_, $STR_TOK_ATTLIST_END, $LEN_TOK_ATTLIST_END) },
           STRINGTYPE       => sub { return &$STR_process(@_, $STR_TOK_STRINGTYPE, $LEN_TOK_STRINGTYPE) },
           TYPE_ID          => sub { return &$STR_process(@_, $STR_TOK_TYPE_ID, $LEN_TOK_TYPE_ID) },
           TYPE_IDREF       => sub { return &$STR_process(@_, $STR_TOK_TYPE_IDREF, $LEN_TOK_TYPE_IDREF) },
           TYPE_IDREFS      => sub { return &$STR_process(@_, $STR_TOK_TYPE_IDREFS, $LEN_TOK_TYPE_IDREFS) },
           TYPE_ENTITY      => sub { return &$STR_process(@_, $STR_TOK_TYPE_ENTITY, $LEN_TOK_TYPE_ENTITY) },
           TYPE_ENTITIES    => sub { return &$STR_process(@_, $STR_TOK_TYPE_ENTITIES, $LEN_TOK_TYPE_ENTITIES) },
           TYPE_NMTOKEN     => sub { return &$STR_process(@_, $STR_TOK_TYPE_NMTOKEN, $LEN_TOK_TYPE_NMTOKEN) },
           TYPE_NMTOKENS    => sub { return &$STR_process(@_, $STR_TOK_TYPE_NMTOKENS, $LEN_TOK_TYPE_NMTOKENS) },
           NOTATION         => sub { return &$STR_process(@_, $STR_TOK_NOTATION, $LEN_TOK_NOTATION) },
           REQUIRED         => sub { return &$STR_process(@_, $STR_TOK_REQUIRED, $LEN_TOK_REQUIRED) },
           IMPLIED          => sub { return &$STR_process(@_, $STR_TOK_IMPLIED, $LEN_TOK_IMPLIED) },
           FIXED            => sub { return &$STR_process(@_, $STR_TOK_FIXED, $LEN_TOK_FIXED) },
           SECT_BEG         => sub { return &$STR_process(@_, $STR_TOK_SECT_BEG, $LEN_TOK_SECT_BEG) },
           INCLUDE          => sub { return &$STR_process(@_, $STR_TOK_INCLUDE, $LEN_TOK_INCLUDE) },
           SECT_END         => sub { return &$STR_process(@_, $STR_TOK_SECT_END, $LEN_TOK_SECT_END) },
           IGNORE           => sub { return &$STR_process(@_, $STR_TOK_IGNORE, $LEN_TOK_IGNORE) },
           IGNORE_INTERIOR  => sub { return &$REG_process(@_, $REG_TOK_IGNORE_INTERIOR, undef) },
           CHARREF          => sub { return &$REG_process(@_, $REG_TOK_CHARREF, undef) },
           ENTITYREF        => sub { return &$REG_process(@_, $REG_TOK_ENTITYREF, undef) },
           PEREFERENCE      => sub { return &$REG_process(@_, $REG_TOK_PEREFERENCE, undef) },
           EDECL_BEG        => sub { return &$STR_process(@_, $STR_TOK_EDECL_BEG, $LEN_TOK_EDECL_BEG) },
           EDECL_END        => sub { return &$STR_process(@_, $STR_TOK_EDECL_END, $LEN_TOK_EDECL_END) },
           PERCENT          => sub { return &$STR_process(@_, $STR_TOK_PERCENT, $LEN_TOK_PERCENT) },
           SYSTEM           => sub { return &$STR_process(@_, $STR_TOK_SYSTEM, $LEN_TOK_SYSTEM) },
           PUBLIC           => sub { return &$STR_process(@_, $STR_TOK_PUBLIC, $LEN_TOK_PUBLIC) },
           NDATA            => sub { return &$STR_process(@_, $STR_TOK_NDATA, $LEN_TOK_NDATA) },
           ENCODING         => sub { return &$STR_process(@_, $STR_TOK_ENCODING, $LEN_TOK_ENCODING) },
           ENCNAME          => sub { return &$REG_process(@_, $REG_TOK_ENCNAME, undef) },
           NOTATION_BEG     => sub { return &$STR_process(@_, $STR_TOK_NOTATION_BEG, $LEN_TOK_NOTATION_BEG) },
           NOTATION_END     => sub { return &$STR_process(@_, $STR_TOK_NOTATION_END, $LEN_TOK_NOTATION_END) },
           ATTVALUE         => sub { return &$REG_process(@_, $REG_TOK_ATTVALUE, undef) },
           ENTITYVALUE      => sub { return &$REG_process(@_, $REG_TOK_ENTITYVALUE, undef) },
          );

1;
