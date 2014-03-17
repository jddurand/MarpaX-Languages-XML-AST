use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST;

# ABSTRACT: Translate XML source to an AST

use MarpaX::Languages::XML::AST::Grammar qw//;

use Log::Any qw/$log/;

# VERSION

=head1 DESCRIPTION

This module translates ECMAScript source into an AST tree. If you want to enable logging, be aware that this module is using Log::Any.

=head1 SYNOPSIS

    use strict;
    use warnings FATAL => 'all';
    use MarpaX::Languages::XML::AST;
    use Log::Log4perl qw/:easy/;
    use Log::Any::Adapter;
    use Log::Any qw/$log/;
    #
    # Init log
    #
    our $defaultLog4perlConf = '
    log4perl.rootLogger              = WARN, Screen
    log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
    log4perl.appender.Screen.stderr  = 0
    log4perl.appender.Screen.layout  = PatternLayout
    log4perl.appender.Screen.layout.ConversionPattern = %d %-5p %6P %m{chomp}%n
    ';
    Log::Log4perl::init(\$defaultLog4perlConf);
    Log::Any::Adapter->set('Log4perl');
    #
    # Parse XML
    #
    my $xmlSourceCode = '<test>data</test>';
    my $xmlAstObject = MarpaX::Languages::XML::AST->new();
    $log->infof('%s', $xmlAstObject->parse($xmlSourceCode));

=head1 SUBROUTINES/METHODS

=head2 new($class, %options)

Instantiate a new object. Takes as parameter an optional hash of options that can be:

=over

=item grammarName

Name of a grammar. Default is 'XML-1.0'.

=back

=cut

# ----------------------------------------------------------------------------------------
sub new {
  my ($class, %opts) = @_;

  $opts{grammarName} ||= 'XML-1.0';

  my $self  = {
      _grammarName => $opts{grammarName} || 'XML-1.0'
  };

  bless($self, $class);

  delete($opts{grammarName});
  $self->_init($self->{_grammarName}, %opts);

  return $self;
}

sub _init {
    my ($self, $grammarName, %opts) = @_;

    $self->{_grammar} = MarpaX::Languages::XML::AST::Grammar->new($grammarName, %opts);
}

=head2 parse($class, $input)

Parses the input. Takes as parameter a required input, that can an object assumed to have a perl's compatible read() method (c.f. perldoc -f read), or a reference that maps to a physical fileno(), or a scalar. The whole content of the input will be used, from position zero up to its end or an error.

=cut

sub parse {
  my ($self, $input) = @_;
  return $self->{_grammar}->parse($input);
}

1;
