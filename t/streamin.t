#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;
use IO::String;
use File::Temp qw/tempfile/;

BEGIN {
    use_ok( 'MarpaX::Languages::XML::AST::StreamIn' ) || print "Bail out!\n";
}

#
# SCALAR test
#
my $input = do {local $/; <DATA>};
my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input, length => 2);
foreach (0..3) {
    ok($stream->getc($_) eq "$_", "Position $_ is character \"$_\"");
}
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input, length => 2);
foreach (0..3) {
    ok($stream->fetchc($_) eq "$_", "Position $_ is character \"$_\"");
}

#
# BLESSED test
#
my $io = IO::String->new($input);
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $io, length => 2);
foreach (0..3) {
    ok($stream->getc($_) eq "$_", "Position $_ is character \"$_\"");
}
$io = IO::String->new($input);
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $io, length => 2);
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
foreach (0..3) {
    ok($stream->getc($_) eq "$_", "Position $_ is character \"$_\"");
}
close(FILE) || warn "Cannot close $filename, $!";
open(FILE, '<', $filename) || die "Cannot open $filename, $!";
$stream = MarpaX::Languages::XML::AST::StreamIn->new(input => \*FILE, length => 2);
foreach (0..3) {
    ok($stream->fetchc($_) eq "$_", "Position $_ is character \"$_\"");
}
close(FILE) || warn "Cannot close $filename, $!";

done_testing(25);

__DATA__
0123
