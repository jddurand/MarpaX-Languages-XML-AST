#!perl
use strict;
use warnings FATAL => 'all';
use File::Slurp qw/read_file/;
use MarpaX::Languages::XML::AST;
use Benchmark qw(:all) ;
use XML::LibXML;
use IO::File;
    use Log::Log4perl qw/:easy/;
    use Log::Any::Adapter;
    use Log::Any qw/$log/;
    #
    # Init log
    #
    our $defaultLog4perlConf = '
    log4perl.rootLogger              = TRACE, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
    Log::Log4perl::init(\$defaultLog4perlConf);
    Log::Any::Adapter->set('Log4perl');

my $file = shift;

cmpthese(5, {
              'XML::LibXML' => \&libxml,
              'MarpaX::Languages::XML::AST' => \&marpa,
             });

sub marpa {
  my $input = IO::File->new($file, 'r');
  print STDERR "MarpaX::Languages::XML::AST BEG\n";
  my $xmlAst = MarpaX::Languages::XML::AST->new();
  my $parse = eval {$xmlAst->parse($input)};
  print STDERR "$@" if ($@);
  print STDERR "MarpaX::Languages::XML::AST END\n";
}

sub libxml {
  my $input = IO::File->new($file, 'r');
  print STDERR "XML::LibXML BEG\n";
  my $parser = XML::LibXML->new();
  my $dom = eval {$parser->parse_fh($input)};
  print STDERR "$@" if ($@);
  print STDERR "XML::LibXML END\n";
  # get all the title elements
  #my @decls = $dom->getElementsByTagName("entry");
  #foreach my $decls (@decls) {
  #  print $decls->getAttribute('schema') . "\n";
  #}
}
