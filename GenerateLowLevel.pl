#!env perl
use strict;
use diagnostics;
use Marpa::R2;
use Getopt::Long;
use POSIX qw/EXIT_SUCCESS EXIT_FAILURE/;
use File::Slurp qw/read_file/;

my $command = "perl $0 " . join(' ', @ARGV);
my $bnf  = '';
my $prefix= '';
my $output = '';
GetOptions('bnf=s'    => \$bnf,
           'prefix=s' => \$prefix,
           'output=s' => \$output);
if (! $bnf || ! $prefix || ! $output) {
  print STDERR "Usage: $^X $0 --bnf grammar.bnf --prefix PREFIX --output output.file\n";
  exit(EXIT_FAILURE);
}

my %symbols = ();
my %rules = ();
doIntrospection($bnf, \%symbols, \%rules);
doOutput($command, $prefix, $output, \%symbols, \%rules);
exit(EXIT_SUCCESS);

# -----------------------------------------------------------------

sub doIntrospection {
  my ($bnf, $symbolsp, $rulesp) = @_;

  my $grammar_source = read_file($bnf);
  my $grammar = Marpa::R2::Scanless::G->new({source => \$grammar_source});
  foreach ($grammar->symbol_ids()) {
    my $name = $grammar->symbol_name($_);
    my $desc = $grammar->symbol_description($_) || $grammar->symbol_display_form($_);
    my $key = $name;
    $key =~ s/[^a-zA-Z0-9_]/_/g;
    $symbolsp->{$key} = {name => $name, desc => $desc};
  }

  foreach ($grammar->rule_ids()) {
    my ($lhs_id, @rhs_ids) = $grammar->rule_expand($_);
    $rulesp->{$lhs_id} = [ @rhs_ids ];
  }
}

# -----------------------------------------------------------------

sub doOutput {
  my ($command, $prefix, $output, $symbolsp, $rulesp) = @_;

  my $fh;
  open($fh, '>', $output) || die "Cannot open $output, $!";
  doOutputHeader($fh, $prefix, $command, $bnf);
  doOutputEnum($fh, $prefix, $symbolsp, $rulesp);
  doOutputStructAndSizes($fh, $prefix, $symbolsp, $rulesp);
  doOutputTailer($fh, $prefix);
  close($fh) || warn "Cannot close $output, $!";

}

# -----------------------------------------------------------------

sub doOutputHeader {
  my ($fh, $prefix, $command, $bnf) = @_;

  $prefix = uc($prefix);

  my $now = localtime();
  print $fh <<HEADER;
/*
 * $now
 *
 * Generated with:
 * $command
 *
 */

#ifndef ${prefix}_H
#define ${prefix}_H

#include "xmlTypes.h"

HEADER
}

# -----------------------------------------------------------------

sub doOutputTailer {
  my ($fh, $prefix) = @_;

  $prefix = uc($prefix);

  print $fh <<TAILER;

#endif /* ${prefix}_H */
TAILER
}

# -----------------------------------------------------------------

sub doOutputEnum {
  my ($fh, $prefix, $symbolsp, $rulesp) = @_;

  $prefix = uc($prefix);

  print  $fh "enum {\n";
  my $i = 0;
  foreach (sort keys %{$symbolsp}) {
    my $enum = "${prefix}_${_}";
    if ($i++ == 0) {
      $enum .= " = 0";
    }
    if ($symbolsp->{$_}->{name} ne $_ ||
        $symbolsp->{$_}->{desc} ne $_) {
      printf $fh "    %-40s, /* %s (%s) */\n", $enum, $symbolsp->{$_}->{name}, $symbolsp->{$_}->{desc};
    } else {
      printf $fh "    %-40s,\n", $enum;
    }
  }
  print  $fh "}\n";
}

# -----------------------------------------------------------------

sub doOutputStructAndSizes {
  my ($fh, $prefix, $symbolsp, $rulesp) = @_;

  my $prefixInStruct = lc($prefix);
  $prefixInStruct = ucfirst($prefix);

  $prefix = uc($prefix);

  {
    # In a block just for alignement with the printf in the foreach () {}
    print  $fh "struct sXmlSymbolId a${prefixInStruct}SymbolId[] = {\n";
    print  $fh "   /*\n";
    printf $fh "    * %2s, %-40s, %-40s, %s\n", 'Id', 'Enum', 'Name', 'Description';
    print  $fh "    */\n";
  }
  my $i = 0;
  foreach (sort keys %{$symbolsp}) {
    ++$i;
    my $enum = "${prefix}_${_}";
    printf $fh "    { %2d, %-40s, %-40s, %s },\n", -1, $enum, "\"$symbolsp->{$_}->{name}\"", "\"$symbolsp->{$_}->{desc}\"";
  }
  {
    # In a block just for alignement with the printf in the foreach () {}
    print  $fh "};\n";
  }
  print  $fh "\n";
  print  $fh "#define ${prefix}_NUMBER_OF_SYMBOLS $i\n";
}

