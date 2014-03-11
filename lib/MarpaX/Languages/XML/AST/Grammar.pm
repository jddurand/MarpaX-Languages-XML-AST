use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar;

# ABSTRACT: Proxy class for XML grammars

use MarpaX::Languages::XML::AST::Grammar::XML_1_0;
use Carp qw/croak/;

# VERSION

=head1 DESCRIPTION

This modules returns XML grammar(s) written in Marpa BNF.
Current grammars are:
=over
=item *
XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition), as of L<http://www.w3.org/TR/2008/REC-xml-20081126/>.
=back

=head1 SYNOPSIS

    use MarpaX::Languages::ECMAScript::XML::Grammar;

    my $grammar = MarpaX::Languages::XML::AST::Grammar->new('XML-1.0');
    my $grammar_content = $grammar->content();
    my $grammar_option = $grammar->grammar_option();
    my $recce_option = $grammar->recce_option();

=head1 SUBROUTINES/METHODS

=head2 new($class, $grammarName, %grammarSpecificOptions)

Instance a new object. Takes the name of the grammar as argument. Remaining arguments are passed to the sub grammar method. Supported grammars are:

=over

=item XML-1.0

Extensible Markup Language (XML) 1.0 (Fifth Edition)

=back

=cut

sub new {
  my ($class, $grammarName, %grammarSpecificOptions) = @_;

  my $self = {};
  if (! defined($grammarName)) {
    croak 'Usage: new($grammar_Name)';
  } elsif ($grammarName eq 'XML-1.0') {
    $self->{_grammar} = MarpaX::Languages::XML::AST::Grammar::XML_1_0->new(%grammarSpecificOptions);
  } else {
    croak "Unsupported grammar name $grammarName";
  }

  return $self->{_grammar};
}

1;
