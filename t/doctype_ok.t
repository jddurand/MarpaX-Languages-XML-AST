#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
    use_ok( 'MarpaX::Languages::XML::AST' ) || print "Bail out!\n";
}

my $xmlAst = MarpaX::Languages::XML::AST->new();
my $parse = $xmlAst->parse(do {local $/; <DATA>});

done_testing(1);

__DATA__
<?xml version="1.0"?>
<!DOCTYPE greeting>
<greeting>Hello, world!</greeting>
