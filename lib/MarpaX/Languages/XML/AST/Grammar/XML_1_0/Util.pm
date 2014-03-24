use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) util methods

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/%TOKEN %FIXED_STRINGS/;
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

our $REG_process = sub {
  # my ($input, $pos, $comp, $length) = @_;
  if ($_[0] =~ $_[2]) {
    return substr($_[0], $-[0], $+[0] - $-[0]);
  }
  return undef;
};

our %TOKEN = (
           S                => sub { return &$REG_process(@_, $REG_TOK_S, undef) },
           NAME             => sub { return &$REG_process(@_, $REG_TOK_NAME, undef) },
           CHAR             => sub { return &$REG_process(@_, $REG_TOK_CHAR, undef) },
           NMTOKEN          => sub { return &$REG_process(@_, $REG_TOK_NMTOKEN, undef) },
           SYSTEMLITERAL    => sub { return &$REG_process(@_, $REG_TOK_SYSTEMLITERAL, undef) },
           PUBIDLITERAL     => sub { return &$REG_process(@_, $REG_TOK_PUBIDLITERAL, undef) },
           CHARDATA         => sub { return &$REG_process(@_, $REG_TOK_CHARDATA, undef) },
           CDATA            => sub { return &$REG_process(@_, $REG_TOK_CDATA, undef) },
           COMMENT          => sub { return &$REG_process(@_, $REG_TOK_COMMENT, undef) },
           PITARGET         => sub { return &$REG_process(@_, $REG_TOK_PITARGET, undef) },
           PI_INTERIOR      => sub { return &$REG_process(@_, $REG_TOK_PI_INTERIOR, undef) },
           VERSIONNUM       => sub { return &$REG_process(@_, $REG_TOK_VERSIONNUM, undef) },
           IGNORE_INTERIOR  => sub { return &$REG_process(@_, $REG_TOK_IGNORE_INTERIOR, undef) },
           CHARREF          => sub { return &$REG_process(@_, $REG_TOK_CHARREF, undef) },
           ENTITYREF        => sub { return &$REG_process(@_, $REG_TOK_ENTITYREF, undef) },
           PEREFERENCE      => sub { return &$REG_process(@_, $REG_TOK_PEREFERENCE, undef) },
           ENCNAME          => sub { return &$REG_process(@_, $REG_TOK_ENCNAME, undef) },
           ATTVALUE         => sub { return &$REG_process(@_, $REG_TOK_ATTVALUE, undef) },
           ENTITYVALUE      => sub { return &$REG_process(@_, $REG_TOK_ENTITYVALUE, undef) },
          );

our %FIXED_STRINGS = 
    (
	COMMENT_BEG      => '<!--',
	COMMENT_END      => '-->',
	PI_BEG           => '<?',
	PI_END           => '?>',
	CDSTART          => '<![CDATA[',
	CDEND            => ']]>',
	XML_BEG          => '<?xml',
	XML_END          => '?>',
	VERSION          => 'version',
	DOCTYPE_BEG      => '<!DOCTYPE',
	STANDALONE       => 'standalone',
	YES              => 'yes',
	NO               => 'no',
	ETAG_BEG         => '</',
	EMPTYELEMTAG_END => '/>',
	ELEMENTDECL_BEG  => '<!ELEMENT',
	EMPTY            => 'EMPTY',
	ANY              => 'ANY',
	RPARENSTAR       => '(*',
	PCDATA           => '#PCDATA',
	ATTLIST_BEG      => '<!ATTLIST',
	STRINGTYPE       => 'CDATA',
	TYPE_ID          => 'ID',
	TYPE_IDREF       => 'IDREF',
	TYPE_IDREFS      => 'IDREFS',
	TYPE_ENTITY      => 'ENTITY',
	TYPE_ENTITIES    => 'ENTITIES',
	TYPE_NMTOKEN     => 'NMTOKEN',
	TYPE_NMTOKENS    => 'NMTOKENS',
	NOTATION         => 'NOTATION',
	REQUIRED         => '#REQUIRED',
	IMPLIED          => '#IMPLIED',
	FIXED            => '#FIXED',
	SECT_BEG         => '<![',
	INCLUDE          => 'INCLUDE',
	SECT_END         => ']]>',
	IGNORE           => 'IGNORE',
	EDECL_BEG        => '<!ENTITY',
	SYSTEM           => 'SYSTEM',
	PUBLIC           => 'PUBLIC',
	NDATA            => 'NDATA',
	ENCODING         => 'encoding',
	NOTATION_BEG     => '<!NOTATION',
    );
1;
