use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::SLR;

#
# We subclass Marpa::R2::Scanless::R to get some
# of its internals
#
use parent 'Marpa::R2::SLR';

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

sub Marpa::R2::Thin::SLR::lexeme_alternative {
  # my ($thin_slr, $symbol_id, @value) = @_;
  return $_[0]->g1_alternative($_[1], @_[2..$#_]);
}

sub Marpa::R2::Thin::SLR::lexeme_complete {
  # my ($thin_slr, $start, $length) = @_;
  return $_[0]->g1_lexeme_complete($_[1], $_[2]);
}

1;
