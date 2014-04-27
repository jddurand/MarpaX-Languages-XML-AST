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
my $startSymbolId = -1;
doIntrospection($bnf, \%symbols, \%rules, \$startSymbolId);
doOutput($command, $prefix, $output, \%symbols, \%rules, $startSymbolId);
exit(EXIT_SUCCESS);

# -----------------------------------------------------------------

sub doIntrospection {
  my ($bnf, $symbolsp, $rulesp, $startSymbolIdp) = @_;

  my $grammar_source = read_file($bnf);
  my $grammar = Marpa::R2::Scanless::G->new({source => \$grammar_source});
  foreach ($grammar->symbol_ids()) {
    my $name = $grammar->symbol_name($_);
    my $desc = $grammar->symbol_description($_) || $grammar->symbol_display_form($_);
    my $key = $name;
    $key =~ s/[^a-zA-Z0-9_]/_/g;
    $symbolsp->{$key} = {name => $name, desc => $desc, id => $_};
  }

  my $thick_grammar = $grammar->thick_g1_grammar;
  my $grammar_c = $thick_grammar->[Marpa::R2::Internal::Grammar::C];
  foreach ($grammar->rule_ids()) {
    my ($lhsId, @rhsIds) = $grammar->rule_expand($_);
    my $minimum = $grammar_c->sequence_min($_);
    my $min = defined($minimum) ? (($minimum <= 0) ? 0 : 1) : -1;
    $rulesp->{$_} = { lhsId => $lhsId, rhsIdp => [ @rhsIds ], desc => $grammar->rule_show($_), min => $min};
  }

  ${$startSymbolIdp} = $grammar_c->start_symbol();
}

# -----------------------------------------------------------------

sub doOutput {
  my ($command, $prefix, $output, $symbolsp, $rulesp, $startSymbolId) = @_;

  my $fh;
  open($fh, '>', $output) || die "Cannot open $output, $!";
  doOutputHeader($fh, $prefix, $command, $bnf);
  my %enum = ();
  doOutputEnum($fh, $prefix, $symbolsp, $rulesp, \%enum);
  doOutputFillG($fh, $prefix, $symbolsp, $rulesp, \%enum, $startSymbolId);
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

#ifndef ${prefix}_C
#define ${prefix}_C

#include "marpaUtil.h"

HEADER
}

# -----------------------------------------------------------------

sub doOutputTailer {
  my ($fh, $prefix) = @_;

  $prefix = uc($prefix);

  print $fh <<TAILER;

#endif /* ${prefix}_C */
TAILER
}

# -----------------------------------------------------------------

sub doOutputEnum {
  my ($fh, $prefix, $symbolsp, $rulesp, $enump) = @_;

  $prefix = uc($prefix);

  print  $fh "/* We do not need all these, just the lexemes, but this is convenient to have the whole list */\n";
  print  $fh "enum {\n";
  my $i = 0;
  foreach (sort {$symbolsp->{$a}->{id} <=> $symbolsp->{$b}->{id}} keys %{$symbolsp}) {
    my $enum = "${prefix}_${_}";
    $enump->{$symbolsp->{$_}->{id}} = $enum;
    if ($i == 0) {
      $enum .= " = 0";
    }
    if ($symbolsp->{$_}->{name} ne $_ ||
        $symbolsp->{$_}->{desc} ne $_) {
      printf $fh "    /* %3d */ %-40s, /* %s (%s) */\n", $i, $enum, $symbolsp->{$_}->{name}, $symbolsp->{$_}->{desc};
    } else {
      printf $fh "    /* %3d */ %-40s,\n", $i, $enum;
    }
    ++$i;
  }
  print  $fh "};\n";
}

# -----------------------------------------------------------------

sub doOutputStructAndSizes {
  my ($fh, $prefix, $symbolsp, $rulesp, $enump) = @_;

  my $prefixInStruct = lc($prefix);
  $prefixInStruct = ucfirst($prefix);

  $prefix = uc($prefix);

  my $nbSymbol = keys %{$symbolsp};
  print  $fh "    int nbSymbols =  $nbSymbol;\n";

  {
    # In a block just for alignement with the printf in the foreach () {}
    print  $fh "    struct sSymbolId a${prefixInStruct}SymbolId[$nbSymbol] = {\n";
    print  $fh "       /*\n";
    printf $fh "        * %2s, %-40s, %s\n", 'Id', 'Name', 'Description';
    print  $fh "        */\n";
  }
  foreach (sort {$symbolsp->{$a}->{id} <=> $symbolsp->{$b}->{id}} keys %{$symbolsp}) {
    printf $fh "        { %2d, %-40s, %s }, /* enum: %s */\n", -1, "\"$symbolsp->{$_}->{name}\"", "\"$symbolsp->{$_}->{desc}\"", $enump->{$symbolsp->{$_}->{id}};
  }
  {
    # In a block just for alignement with the printf in the foreach () {}
    print  $fh "    };\n";
  }
}

# -----------------------------------------------------------------

sub doOutputFillG {
  my ($fh, $prefix, $symbolsp, $rulesp, $enump, $startSymbolId) = @_;

  my $prefixInSub = lc($prefix);
  $prefix = uc($prefix);

  {
    # In a block just for alignement with the printf in the foreach () {}
    print  $fh "\n";
    print  $fh "static Marpa_Grammar _${prefixInSub}CreateGrammar()\n";
    print  $fh "{\n";
    print  $fh "    Marpa_Grammar g;\n";
    print  $fh "\n";
    print  $fh "    /* Room to map our enums to real Ids */\n";
    doOutputStructAndSizes(@_);
    print  $fh "\n";
    print  $fh "    /* Create the grammar */\n";
    print  $fh "    marpaUtilCreateGrammar(&g);\n";
    print  $fh "\n";
    print  $fh "    /* Create all the symbols */\n";
    print  $fh "    marpaUtilSetSymbols(g, nbSymbols, aXml10SymbolId);\n";
    print  $fh "\n";
    print  $fh "    /* Populate the rules */\n";
  }
  foreach (sort keys %{$rulesp}) {
    my ($lhsId, $rhsIdp, $desc, $min) = ("aXml10SymbolId[" . $enump->{$rulesp->{$_}->{lhsId}} . "].symbolId", $rulesp->{$_}->{rhsIdp}, $rulesp->{$_}->{desc}, $rulesp->{$_}->{min});
    my $numRhs = scalar(@{$rhsIdp});
    if ($numRhs > 0) {
      printf $fh "    {\n";
      printf $fh "        /* %s */\n", $desc;
      print  $fh "        Marpa_Symbol_ID rhsIds[] = {\n";
      foreach (0..$#{$rhsIdp}) {
        printf $fh "                                     aXml10SymbolId[%s].symbolId%s\n", $enump->{$rhsIdp->[$_]}, $_ < $#{$rhsIdp} ? ',' : '' ;
      }
      print  $fh "                                   };\n";
      printf $fh "        marpaUtilSetRule(g, %s , %d, &(rhsIds[0]), %d, -1, 0, 0);\n", $lhsId, $numRhs, $min;
      print  $fh "    }\n";
    } else {
      printf $fh "    { /* %s */\n", $desc;
      printf $fh "        marpaUtilSetRule(g, %s , 0, NULL, %d, -1, 0, 0);\n", $lhsId, $min;
      print  $fh "    }\n";
    }
  }
  {
    print  $fh "\n";
    print  $fh "    /* Set start symbol */\n";
    printf $fh "    marpaUtilSetStartSymbol(g, aXml10SymbolId[%s].symbolId);\n", $enump->{$startSymbolId};
    print  $fh "\n";
    print  $fh "    /* Precompute grammar */\n";
    printf $fh "    marpaUtilPrecomputeG(g);\n";
    print  $fh "\n";
    printf $fh "    return g;\n";
    print  $fh "}\n";
    print  $fh "\n";
  }
}
