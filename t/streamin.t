#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;
use IO::String;
use File::Temp qw/tempfile/;

BEGIN {
    use_ok( 'MarpaX::Languages::XML::AST::StreamIn' ) || print "Bail out!\n";
}

my %stringsToSub = 
    (
	X20              => "\x{20}",
	COMMENT_BEG      => '<!--',
	COMMENT_END      => '-->',
	PI_BEG           => '<?',
	PI_END           => '?>',
	CDSTART          => '<![CDATA[',
	CDEND            => ']]>',
	XML_BEG          => '<?xml',
	XML_END          => '?>',
	VERSION          => 'version',
	DQUOTE           => '"',
	SQUOTE           => "'",
	EQUAL            => '=',
	DOCTYPE_BEG      => '<!DOCTYPE',
	DOCTYPE_END      => '>',
	LBRACKET         => '[',
	RBRACKET         => ']',
	STANDALONE       => 'standalone',
	YES              => 'yes',
	NO               => 'no',
	STAG_BEG         => '<',
	STAG_END         => '>',
	ETAG_BEG         => '</',
	ETAG_END         => '>',
	EMPTYELEMTAG_BEG => '<',
	EMPTYELEMTAG_END => '/>',
	ELEMENTDECL_BEG  => '<!ELEMENT',
	ELEMENTDECL_END  => '>',
	EMPTY            => 'EMPTY',
	ANY              => 'ANY',
	QUESTION_MARK    => '?',
	STAR             => '*',
	PLUS             => '+',
	LPAREN           => '(',
	RPAREN           => ')',
	RPARENSTAR       => '(*',
	PIPE             => '|',
	COMMA            => ',',
	PCDATA           => '#PCDATA',
	ATTLIST_BEG      => '<!ATTLIST',
	ATTLIST_END      => '>',
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
	EDECL_END        => '>',
	PERCENT          => '%',
	SYSTEM           => 'SYSTEM',
	PUBLIC           => 'PUBLIC',
	NDATA            => 'NDATA',
	ENCODING         => 'encoding',
	NOTATION_BEG     => '<!NOTATION',
	NOTATION_END     => '>'
    );
my $this = '<?ffffffffffffffffffffffff';
my $s = MarpaX::Languages::XML::AST::StreamIn->new(input => $this);
my $stringsToSub = $s->stringsToSub(\%stringsToSub);
my @rc = $s->$stringsToSub(0, \%stringsToSub);
ok($#rc == 1, "stringsToSub returned 2 elements");
ok($rc[0] eq '<?', "\$rc[0] is '<?'");
ok($rc[1] eq 'PI_BEG', "\$rc[1] is 'PI_BEG'");
#
# SCALAR test
#
my $input = do {local $/; <DATA>};
my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input, length => 2);
ok($stream->substr(1, 2) eq "12", "substr(1, 2) returns '12'");
foreach (0..3) {
    ok($stream->getc($_) eq "$_", "Position $_ is character \"$_\"");
}
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input, length => 2);
ok($stream->substr(1, 2) eq "12", "substr(1, 2) returns '12'");
foreach (0..3) {
    ok($stream->fetchc($_) eq "$_", "Position $_ is character \"$_\"");
}
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input, length => 2);

#
# BLESSED test
#
my $io = IO::String->new($input);
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $io, length => 2);
ok($stream->substr(1, 2) eq "12", "substr(1, 2) returns '12'");
foreach (0..3) {
    ok($stream->getc($_) eq "$_", "Position $_ is character \"$_\"");
}
$io = IO::String->new($input);
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $io, length => 0);
ok($stream->substr(1, 2) eq "12", "substr(1, 2) returns '12'");
foreach (0..3) {
    ok($stream->fetchc($_) eq "$_", "Position $_ is character \"$_\"");
}
#
# FILEHANDLE test
#
my ($fh, $filename) = tempfile();
$fh->write($input);
$fh->close();
open(FILE, '<', $filename) || die "Cannot open $filename, $!";
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => \*FILE, length => 2);
ok($stream->substr(1, 2) eq "12", "substr(1, 2) returns '12'");
foreach (0..3) {
    ok($stream->getc($_) eq "$_", "Position $_ is character \"$_\"");
}
close(FILE) || warn "Cannot close $filename, $!";
open(FILE, '<', $filename) || die "Cannot open $filename, $!";
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => \*FILE, length => 8);
ok($stream->substr(1, 2) eq "12", "substr(1, 2) returns '12'");
foreach (0..3) {
    ok($stream->fetchc($_) eq "$_", "Position $_ is character \"$_\"");
}
close(FILE) || warn "Cannot close $filename, $!";

done_testing(34);

__DATA__
0123
