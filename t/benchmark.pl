#!perl
use strict;
use warnings FATAL => 'all';
use File::Slurp qw/read_file/;
use MarpaX::Languages::XML::AST;
use Benchmark qw(:all) ;
use XML::LibXML;

my $input = read_file(shift);

timethese(1, {
#              'XML::LibXML' => \&libxml,
              'MarpaX::Languages::XML::AST' => \&marpa,
             });

sub marpa {
  print STDERR "MarpaX::Languages::XML::AST BEG\n";
  my $xmlAst = MarpaX::Languages::XML::AST->new();
  my $parse = $xmlAst->parse($input);
  print STDERR "MarpaX::Languages::XML::AST END\n";
}

sub libxml {
  print STDERR "XML::LibXML BEG\n";
  my $parser = XML::LibXML->new();
  my $dom = $parser->parse_string($input);
  print STDERR "XML::LibXML END\n";
  # get all the title elements
  my @decls = $dom->getElementsByTagName("decls");
  foreach my $decls (@decls) {
    print $decls->getAttribute('file') . "\n";
  }
}
