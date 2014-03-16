use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Util;

# ABSTRACT: XML Translation to AST - Class method utilities

use Exporter 'import';
use Log::Any qw/$log/;
use Carp qw/croak/;
# Marpa follows Unicode recommendation, i.e. perl's \R, that cannot be in a character class
our $NEWLINE_REGEXP = qr/(?>\x0D\x0A|\v)/;

# VERSION

# CONTRIBUTORS

our @EXPORT_OK = qw/logCroak lineAndCol showLineAndCol/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

=head1 DESCRIPTION

This modules implements some function utilities.

=head1 SUBROUTINES/METHODS

=head2 logCroak($recce, $input, $msg, $pos)

=cut

sub logCroak {
    my ($recce, $input, $msg, $pos) = @_;

    my $line_columnp = eval { lineAndCol($recce, $pos) };
    if (! $@) {
	croak("$msg, at position $pos, " . showLineAndCol(@{$line_columnp}, $input));
    } else {
	croak("$msg, at position $pos");
    }
}

sub showLineAndCol {
    my ($line, $col, $input) = @_;

    my $pointer = ($col > 0 ? '-' x ($col-1) : '') . '^';
    my $content = '';

    my $prevpos = pos($input);
    pos($input) = undef;
    my $thisline = 0;
    my $nbnewlines = 0;
    my $eos = 0;
    while ($input =~ m/\G(.*?)($NEWLINE_REGEXP|\Z)/scmg) {
      if (++$thisline == $line) {
        $content = substr($input, $-[1], $+[1] - $-[1]);
        $eos = (($+[2] - $-[2]) > 0) ? 0 : 1;
        last;
      }
    }
    $content =~ s/\t/ /g;
    if ($content) {
      $nbnewlines = (substr($input, 0, pos($input)) =~ tr/\n//);
      if ($eos) {
        ++$nbnewlines; # End of string instead of $NEWLINE_REGEXP
      }
    }
    pos($input) = $prevpos;
    #
    # We rely on any space being a true space for the pointer accuracy
    #
    $content =~ s/\s/ /g;

    return "line $nbnewlines, column $col:\n\n$content\n$pointer";
}

sub lineAndCol {
    my ($recce, $pos) = @_;

    return [ $recce->line_column($pos) ];
}

1;
