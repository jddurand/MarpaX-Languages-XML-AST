use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::SLR;

# ABSTRACT: Marpa::R2's SLR extension

use Marpa::R2;

# VERSION

sub Marpa::R2::Scanless::R::thin_slr {
  my ($slr) = @_;
  return $slr->[Marpa::R2::Internal::Scanless::R::C];
}

sub Marpa::R2::Scanless::R::symbol_id {
  my ( $slr, $symbol_name ) = @_;
  my $thin_slr = $slr->[Marpa::R2::Internal::Scanless::R::C];

  Marpa::R2::exception(
                       "slr->alternative(): symbol name is undefined\n",
                       "    The symbol name cannot be undefined\n"
                      ) if not defined $symbol_name;

  my $slg        = $slr->[Marpa::R2::Internal::Scanless::R::GRAMMAR];
  my $g1_grammar = $slg->[Marpa::R2::Internal::Scanless::G::THICK_G1_GRAMMAR];
  my $g1_tracer  = $g1_grammar->tracer();
  my $symbol_id  = $g1_tracer->symbol_by_name($symbol_name);
  if ( not defined $symbol_id ) {
    Marpa::R2::exception(
                         qq{slr->alternative(): symbol "$symbol_name" does not exist});
  }
  return $symbol_id;
}

1;
