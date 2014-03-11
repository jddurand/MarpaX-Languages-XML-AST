#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
    use_ok( 'MarpaX::Languages::XML::AST' ) || print "Bail out!\n";
}

my $xmlAst = MarpaX::Languages::XML::AST->new();
my $parse = eval {$xmlAst->parse(do {local $/; <DATA>})};
ok (! defined($parse));

done_testing(2);

__DATA__
<?xml version="1.0"?>
<!DOCTYPE greetings>
<greeting>Hello, world!</greeting>
