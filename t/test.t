#!perl
use strict;
use warnings FATAL => 'all';
use Test::More;
use File::Slurp qw/read_file/;

BEGIN {
    use_ok( 'MarpaX::Languages::XML::AST' ) || print "Bail out!\n";
}

my $xmlAst = MarpaX::Languages::XML::AST->new();
my $input = read_file(shift);
# my $input = do {local $/; <DATA>};
print STDERR "GO - INPUT SIZE: " . length($input) . "\n";
my $parse = $xmlAst->parse($input);

done_testing(1);

__DATA__
<?xml version='1.0' encoding='UTF-8'?>
<C>
  <decls file="C:\\Windows\\Temp\\test.c" ft="char *s1 = &quot;String1'&quot;" init="&quot;String1'&quot;" line="1" nm="s1" ty="char *" var="1" />
  <decls enum="1" nm="ANON0" ty="ANON0" type="1">
    <args file="C:\\Windows\\Temp\\test.c" ft="E1" line="4" nm="E1" ty="int" var="1" />
  </decls>
  <decls nm="s1_" struct="1" structOrUnion="1" ty="struct s1_" type="1">
    <args file="C:\\Windows\\Temp\\test.c" ft="int x" line="3" nm="x" ty="int" var="1" />
    <args file="C:\\Windows\\Temp\\test.c" ft="enum {E1, E2} e" line="4" nm="e" ty="ANON0" var="1" />
    <args nm="ANON1" struct="1" structOrUnion="1" ty="struct ANON1" type="1">
      <args file="C:\\Windows\\Temp\\test.c" ft="long y" line="6" nm="y" ty="long" var="1" />
      <args file="C:\\Windows\\Temp\\test.c" ft="double z" line="7" nm="z" ty="double" var="1" />
      <args file="C:\\Windows\\Temp\\test.c" ft="char *s[1024][32]" line="8" mod="[1024]" nm="s" ty="char *" var="1" />
    </args>
    <args file="C:\\Windows\\Temp\\test.c" ft="struct {
    long y;
    double z;
    char *s[1024][32];
  } innerStructure" line="5" nm="innerStructure" ty="struct ANON1" var="1" />
  </decls>
  <decls file="C:\\Windows\\Temp\\test.c" ft="struct s1_ {
  int x;
  enum {E1, E2} e;
  struct {
    long y;
    double z;
    char *s[1024][32];
  } innerStructure;
};" line="2" nm="ANON2" ty="struct s1_" var="1" />
  <decls file="C:\\Windows\\Temp\\test.c" ft="int f1(double x)" func="1" line="12" nm="f1" rt="int" var="1">
    <args file="C:\\Windows\\Temp\\test.c" ft="double x" line="12" nm="x" ty="double" var="1" />
  </decls>
  <decls file="C:\\Windows\\Temp\\test.c" ft="int f2(float y)" func="1" line="13" nm="f2" rt="int" var="1">
    <args file="C:\\Windows\\Temp\\test.c" ft="float y" line="13" nm="y" ty="float" var="1" />
  </decls>
</C>
