use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::StreamIn;
use Scalar::Util qw/blessed/;
use Carp qw /croak/;
use Log::Any qw/$log/;

# ABSTRACT: A simple read-only data prefetch class

# VERSION

#
# We use an blessed array instead of a blessed hahsh because this is faster
#
#use constant {
#    _INPUT   =>  0,
#    _DATA    =>  1,
#    _LENGTH  =>  2,
#    _MAPEND  =>  3,
#    _MAPBEG  =>  4,
#    _EOF     =>  5,
#    _BLESSED =>  6,
#    _FILENO  =>  7,
#    _NDATA   =>  8,
#    _LASTPOS =>  9,
#    _MAXPOS  => 10
#};
sub new {
    my ($class, %opts) = @_;

    my $self = [];
    $self->[ 0]   = $opts{input};                   # File handle or object or scalar
    $self->[ 1]    = [];                            # Array of cached data
    $self->[ 2]  = $opts{length} || 1*1024*1024;    # Number of characters of every cached data
    $self->[ 3]  = [];                              # Mapped position of each last data (exclusive)
    $self->[ 4]  = [];                              # Mapped position of each first data (inclusive)
    $self->[ 5]     = 0;                            # Last buffer reached
    $self->[ 6] = 0;                                # true if input is blessed
    $self->[ 7]  = -1;                              # >= 0 if input appears to be a true filehandle
    $self->[ 8]   = 0;                              # Number of cached buffers
    $self->[ 9] = undef;                            # Last position ever reached (does not mean it is available)
    $self->[10]  = undef;                           # Max pos in input (inclusive), setted only when eof

    bless($self, $class);

    $self->_init();

    return $self;
}

sub length {
  my ($stream) = @_;
  return $stream->[ 2];
}

#
# Check input capability and fetch first buffer
#
sub _init {
    my ($self) = @_;

    if (blessed($self->[ 0])) {
	if (! $self->[ 0]->can('read')) {
	    croak 'Blessed input must support the read() method';
	}
	#$log->tracef('Input is a blessed object that can read()');
	$self->[ 6] = 1;
    } else {
	$self->[ 7] = fileno($self->[ 0]) // -1;
    }
    #
    # Pretech first buffer
    #
    $self->_read(0);
}

#
# Read buffer
#
sub _read {
    my ($self, $pos, $append) = @_;

    my $n;
    my $idata = $#{$self->[ 1]};
    if ($idata < 0) {
	#
	# No buffer yet, fake append mode
	#
	$append = 1;
    }
    if ($append) {
	++$idata;
    }
    #
    # Note: the perl system call read() is reading CHARACTERS OF DATA
    # not bytes. I.e. it is the responsability of the caller to
    # position correctly eventual io layers.
    #
    if ($self->[ 6]) {
	# $log->tracef('Asking input for %d characters from assumed position %d in buffer No %d', $self->[ 2], $pos, $idata);
	$n = $self->[ 0]->read($self->[ 1]->[$idata], $self->[ 2]) || 0;
    } elsif ($self->[ 7] >= 0) {
	# $log->tracef('Reading %d characters from assumed position %d in buffer No %d', $self->[ 2], $pos, $idata);
	$n = read($self->[ 0], $self->[ 1]->[$idata], $self->[ 2]) || 0;
    } else {
	# $log->tracef('Mapping scalar into buffer No %d, faking EOF', $idata);
	#
	# Assumed to be a true scalar - no real read, fake a single whole buffer
	#
	$self->[ 1]->[$idata] = $self->[ 0];
	$n = CORE::length($self->[ 0]);
	$self->[ 5] = 1;
    }
    if ($self->[ 6] || $self->[ 7] >= 0) {
	if ($n <= 0) {
	    # $log->tracef('EOF');
	    $self->[ 5] = 1;
	    $n = 0;
	} elsif ($n < $self->[ 2]) {
	    # $log->tracef('EOF after %d characters', $n);
	    $self->[ 5] = 1;
	}
    }
    if ($append && $idata > 0) {
	$self->[ 4]->[$idata] =  $self->[ 3]->[$idata-1];
    } else {
	$self->[ 4]->[$idata] =  $pos;
    }
    $self->[ 3]->[$idata] =  $self->[ 4]->[$idata] + $n;
    # $log->tracef('Buffer No %d maps to positions [%d-%d[', $idata, $self->[ 4]->[$idata], $self->[ 3]->[$idata]);
    $self->[ 9] = $self->[ 3]->[$idata] - 1;
    $self->[ 8] = $idata + 1;
    if ($self->[ 5]) {
	$self->[10] = $self->[ 9];
	#$log->tracef('Input max position found to be %s', $self->[10]);
    }
    if ($n <= 0) {
	#
	# Nothing was read - this could have been done before, but happens once only, at eof
	#
	$self->doneb($idata);
    }
}

#
# $pos assumed to be >= 0
# This routine can recurse, but at max once
#
sub fetchc {
    my ($self, $pos) = @_;

    if ($self->[ 8] <= 0) {
	#
	# No data cached
	#
	if ($self->[ 5]) {
	    #
	    # But EOF marked: nothing else is available
	    #
	    return undef;
	} else {
	    #
	    # Buffer next data
	    # This is where we technically disallow to go backwards.
	    #
	    $self->_read($self->[ 9] + 1);
	    return $self->fetchc($pos);
	}
    } else {
	if ($pos < $self->[ 4]->[0]) {
	    croak "Attempt to fetch at position $pos < $self->[ 4]->[0] (first cached position)";
	} else {
	    if ($pos >= $self->[ 3]->[-1]) {
		#
		# Attempt to read beyond last cached data: need to append another buffer
		# Although this is not likely to happen, we prevent deep recursion
		# by doing the loop ourself
		#
		while (($pos >= $self->[ 3]->[-1]) && ! $self->[ 5]) {
		    $self->_read($self->[ 9] + 1, 1);
		}
	    }
	    #
	    # Search buffer index hosting our position
	    #
	    my $idata;
	    my $found = 0;
	    for ($idata = 0; $idata < $self->[ 8]; $idata++) {
		if ($pos >= $self->[ 4]->[$idata] && $pos < $self->[ 3]->[$idata]) {
		    $found = 1;
		    last;
		}
	    }
	    if (! $found) {
		#
		# Not found - a priori $self->[ 5] should be marked
		#
		if (! $self->[ 5]) {
		    croak "Fetch at position $pos fail and eof is not reached";
		} else {
		    return undef;
		}
	    } else {
		my $ipos = $pos - $self->[ 4]->[$idata];
		# $log->tracef('Position %d found at position %d in buffer No %d that maps to [%d-%d]', $pos, $ipos, $idata, $self->[ 4]->[$idata], $self->[ 3]->[$idata]);
		return (substr($self->[ 1]->[$idata], $ipos, 1), $self->[ 1]->[$idata], $ipos);
	    }
	}
    }
}

sub mapbeg {
    my ($self, $n) = @_;
    return $self->[ 4]->[$n];
}

sub mapend {
    my ($self, $n) = @_;
    return $self->[ 3]->[$n];
}

sub eof {
    my ($self) = @_;
    return $self->[ 5];
}

sub ndata {
    my ($self) = @_;
    return $self->[ 8];
}

sub lastpos {
    my ($self) = @_;
    return $self->[ 9];
}

sub maxpos {
    my ($self) = @_;
    return $self->[10];
}

#
# If $n is < 0, this will fetch next uncached buffer.
# This routine can recurse, but at max once
#
sub fetchb {
    my ($self, $n) = @_;

    $n //= 0;

    if ($n < 0) {
      $n = $self->[ 8];
    }

    if ($self->[ 8] <= 0) {
	#
	# No data cached
	#
	if ($self->[ 5]) {
	    #
	    # But EOF marked: nothing else is available
	    #
	    return undef;
	} else {
	    #
	    # Buffer next data
	    # This is where we technically disallow to go backwards.
	    #
	    $self->_read($self->[ 9] + 1);
	    return $self->fetchb($n);
	}
    } else {
	if ($n >= $self->[ 8]) {
	    #
	    # Attempt to fetch a buffer beyond last cached data: need to append another buffer
	    # Although this is not likely to happen, we prevent deep recursion
	    # by doing the loop ourself
	    #
	    while (($n >= $self->[ 8]) && ! $self->[ 5]) {
		$self->_read($self->[ 9] + 1, 1);
	    }
	}
	if ($n >= $self->[ 8]) {
	    #
	    # Not found - a priori $self->[ 5] should be marked
	    #
	    if (! $self->[ 5]) {
		croak "Fetch of buffer $n fail and eof is not reached";
	    } else {
		return undef;
	    }
	} else {
	    # $log->tracef('Buffer %d and maps to [%d-%d]', $n, $self->[ 4]->[$n], $self->[ 3]->[$n]);
	    return $self->[ 1]->[$n];
	}
    }
}

#
# $pos assumed to be >= 0
#
sub donec {
    my ($self, $pos) = @_;
    #
    # We want to forget (FOREVER) character at position $pos
    # If position is the last one hosted by a buffer, this buffer and
    # eventually previous buffers will be destroyed.
    #
    my $idata;
    my $found = 0;
    for ($idata = 0; $idata < $self->[ 8]; $idata++) {
	if ($pos >= $self->[ 4]->[$idata] && $pos < $self->[ 3]->[$idata]) {
	    $found = 1;
	    last;
	}
    }
    if ($found && $pos == $self->[ 3]->[$idata] -1) {
	#
	# This position is the last one hosted by buffer No $idata
	#
	my $ndata = $idata + 1;
	splice(@{$self->[ 1]}, 0, $ndata);
	splice(@{$self->[ 4]}, 0, $ndata);
	splice(@{$self->[ 3]}, 0, $ndata);
	$self->[ 8] -= $ndata;
    }
}

#
# $n assumed to be >= 0
#
sub doneb {
    my ($self, $n) = @_;

    $n //= 0;
    #
    # We want to forget (FOREVER) buffer at position $n
    # Eventually previous buffers will be destroyed.
    #
    if ($n < $self->[ 8]) {
        # $log->tracef('Destroying buffer No %d [%d-%d[', $n, $self->mapbeg($n), $self->mapend($n));
	my $ndata = $n + 1;
	splice(@{$self->[ 1]}, 0, $ndata);
	splice(@{$self->[ 4]}, 0, $ndata);
	splice(@{$self->[ 3]}, 0, $ndata);
	$self->[ 8] -= $ndata;
    }
}

#
# getc is an alias to fetchc and donec
# $pos assumed to be >= 0
#
sub getc {
    my ($self, $pos) = @_;
    my $c;
    if (defined($c = $self->fetchc($pos))) {
	$self->donec($pos);
    }
    return $c;
}

#
# getb is an alias to fetchb and doneb
# $n assumed to be >= 0.
# Returns buffer and its mapped positions
#
sub getb {
    my ($self, $n) = @_;

    $n //= 0;

    my ($b, $mapbeg, $mapend) = (undef, undef, undef);
    if (defined($b = $self->fetchb($n))) {
      $mapbeg = $self->mapbeg($n);
      $mapend = $self->mapend($n);
      $self->doneb($n);
    }
    return ($b, $mapbeg, $mapend);
}

#
# substr could be an alias to a loop on fetchc, and is instead
# rewriten using ranges for optimisation.
#
sub substr {
    my ($self, $offset, $length) = @_;

    if ($offset < 0 || ! defined($length) || ($length < 0)) {
	#
	# We need to reach eof
	#
	while (! $self->[ 5]) {
	    $self->_read($self->[ 9] + 1);
	}
    }
    my $start = ($offset < 0) ? ($self->[10] + $offset) : $offset;
    my $end = defined($length) ? (($length < 0) ? ($self->[10] + $length) : ($start + $length - 1)) : $self->[10];

    #
    # Make sure end is reachable, take last offset if end is beyond eof
    #
    if (! defined($self->fetchc($end))) {
	#
	# This is okay only if we hitted eof, in which end is overwriten
	#
	if (! $self->[ 5]) {
	    #$log->warnf('substr(%s, %s) converted to range [%d-%d] but position %d is not available', $offset, $length, $start, $end, $end);
	    return undef;
	}
	#$log->warnf('substr(%s, %s) converted to range [%d-%d] but position %d is beyond eof: [%d-%d] applied', $offset, $length, $start, $end, $end, $start, $self->[10]);
	$end = $self->[10];
    }
    #
    # Make sure start is not beyond end
    #
    if ($start > $end) {
	#$log->warnf('substr(%s, %s) converted to range [%d-%d]', $offset, $length, $start, $end);
	return undef;
    }
    #
    # Make sure start is reachable
    #
    if (! defined($self->fetchc($start))) {
	#$log->warnf('substr(%s, %s) converted to range [%d-%d] but position %d is not available', $offset, $length, $start, $end, $start);
	return undef;
    }
    #
    # Loop on all buffers to determine the span
    #
    my $idatastart = undef;
    my $idataend = undef;
    my $idata;
    for ($idata = 0; $idata < $self->[ 8]; $idata++) {
	if (! defined($idatastart)) {
	    if ($start >= $self->[ 4]->[$idata] && $start < $self->[ 3]->[$idata]) {
		$idatastart = $idata;
	    }
	}
	if (! defined($idataend)) {
	    if ($end >= $self->[ 4]->[$idata] && $end < $self->[ 3]->[$idata]) {
		$idataend = $idata;
	    }
	}
	if (defined($idatastart) && defined($idataend)) {
	    last;
	}
    }
    my $rc = '';
    foreach ($idatastart..$idataend) {
	my $istart = ($_ == $idatastart) ? ($start - $self->[ 4]->[$_]) : 0;
	my $iend = ($_ == $idataend) ? ($end - $self->[ 4]->[$_]) : ($self->[ 3]->[$_] - 1);
	my $ilength = $iend - $istart + 1;
	$rc .= substr($self->[ 1]->[$_], $istart, $ilength);
    }
    return $rc;
}

# $hashp keys are string names
# $hashp values are string values
# This will generate a routine that is assuming in input:
# ($stream, $pos, $hashp, $string)
# where $string is the eventual buffer known by the application at position $pos.
# If $string is defined and need to be expanded, the generated stub will do so.
# Take care: for optimisation, all variables are manipulated directly from the stack.
# This mean that eventual expansion of $string will be seen visible by the application.
# The generated stub will return an array of string names that matched in an array.
# The match itself is not return because it is already known by the application via $hashp.
#
sub stringsToSub {
    my ($self, $hashp) = @_;

    #
    # Get a length2Strings hash with index {length}{stringValue} and values an array ref of stringName
    #
    my %length2Strings = ();
    foreach (keys %{$hashp}) {
	my $stringName = $_;
	my $stringValue = $hashp->{$stringName};
	my $length = CORE::length($stringValue);
	if (! exists($length2Strings{$length})) {
	    $length2Strings{$length} = {};
	}
	if (! exists($length2Strings{$length}->{$stringValue})) {
	    $length2Strings{$length}->{$stringValue} = [];
	}
	push(@{$length2Strings{$length}->{$stringValue}}, $stringName);
    }
    #
    # Issue some warnings
    #
    foreach (keys %length2Strings) {
	my $length = $_;
	foreach (keys %{$length2Strings{$length}}) {
	    my $stringValue = $_;
	    if ($#{$length2Strings{$length}->{$stringValue}} > 0) {
		#$log->warnf('More than one candidate for string \'%s\': %s', $stringValue, [ sort @{$length2Strings{$length}->{$stringValue}} ]);
	    }
	}
    }
    #
    # Loop on sorted lengths
    #
    my @content = ();
    push(@content, '  # my ($stream, $pos, $hashp, $string) = @_;');
    push(@content, '');
    my $i = 0;
    foreach (sort {$b <=> $a} keys %length2Strings) {
	my $length = $_;
	if ($i++ == 0) {
	    #
	    # First time
	    #
	    push(@content, '  my ($string, $length);');
	    push(@content, '  if (defined($_[3])) {');
	    push(@content, '    $length = CORE::length($_[3]);');
	    push(@content, '    if ($length < ' . $length . ') {');
	    push(@content, '      my $more = $_[0]->substr($_[1] + $length, ' . $length . ' - $length);');
	    push(@content, '      if (defined($more)) {');
	    push(@content, '        $_[3] .= $more;');
	    push(@content, '      }');
	    push(@content, '    }');
	    push(@content, '    $string = $_[3];');
	    push(@content, '  } else {');
	    push(@content, '    $string = $_[0]->substr($_[1], ' . $length . ');');
	    push(@content, '  }');
	    push(@content, '  if (defined($string)) {');
	    push(@content, '    $length = CORE::length($string);');	    
	} else {
	    push(@content, '    if ($length > ' . $length . ') {');
	    push(@content, '      CORE::substr($string, ' . $length . ', $length - ' . $length . ', \'\');');
	    push(@content, '      $length = ' . $length . ';');
	    push(@content, '    }');
	}
	foreach (keys %{$length2Strings{$length}}) {
	    my $stringValue = $_;
	    #
	    # Take any stringName, if many they are guaranteed to all have the same value
	    #
	    my $stringName = $length2Strings{$length}->{$stringValue}->[0];
	    push(@content, '    if ($string eq $_[2]->{\'' . $stringName . '\'}) {');
	    push(@content, '      return (' . join(', ', map {"'$_'"} @{$length2Strings{$length}->{$stringValue}}) . ');');
	    push(@content, '    }');
	}
    }
    push(@content, '  }');
    my $content = join("\n", @content) . "\n";
    my $rc = eval "sub {\n$content\n}\n";
    if ($@) {
	croak "Oups, $@";
    }
    return $rc;
}

1;
