use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::StreamIn;
use Scalar::Util qw/blessed/;
use Carp qw /croak/;
use Log::Any qw/$log/;

# ABSTRACT: A simple read-only data prefetch class

# VERSION

sub new {
    my ($class, %opts) = @_;

    my $self = {
	_input   => $opts{input},                    # File handle or object or scalar
	_data    => [],                              # Array of cached data
	_length  => $opts{length} || 1*1024*1024,    # Number of characters of every cached data
	_mapend  => [],                              # Mapped position of each last data (exclusive)
	_mapbeg  => [],                              # Mapped position of each first data (inclusive)
	_eof     => 0,                               # Last buffer reached
	_blessed => 0,                               # true if input is blessed
	_fileno  => -1,                              # >= 0 if input appears to be a true filehandle
	_ndata   => 0,                               # Number of cached buffers
	_lastpos => undef,                           # Last position ever reached (does not mean it is available)
	_maxpos  => undef                            # Max pos in input (inclusive), setted only when eof
    };

    bless($self, $class);

    $self->_init();

    return $self;
}

#
# Check input capability and fetch first buffer
#
sub _init {
    my ($self) = @_;

    if (blessed($self->{_input})) {
	if (! $self->{_input}->can('read')) {
	    croak 'Blessed input must support the read() method';
	}
	$log->tracef('Input is a blessed object that can read()');
	$self->{_blessed} = 1;
    } else {
	$self->{_fileno} = fileno($self->{_input}) // -1;
	if ($self->{_fileno} >= 0) {
	    $log->tracef('Input is a file handle with fileno %d', $self->{_fileno});
	} else {
	    $log->tracef('Input is assumed to be a scalar');
	}
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
    my $idata = $#{$self->{_data}};
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
    if ($self->{_blessed}) {
	$log->tracef('Asking input for %d characters from assumed position %d in buffer No %d', $self->{_length}, $pos, $idata);
	$n = $self->{_input}->read($self->{_data}->[$idata], $self->{_length}) || 0;
    } elsif ($self->{_fileno} >= 0) {
	$log->tracef('Reading %d characters from assumed position %d in buffer No %d', $self->{_length}, $pos, $idata);
	$n = read($self->{_input}, $self->{_data}->[$idata], $self->{_length}) || 0;
    } else {
	$log->tracef('Mapping scalar into buffer No %d, faking EOF', $idata);
	#
	# Assumed to be a true scalar - no real read, fake a single whole buffer
	#
	$self->{_data}->[$idata] = $self->{_input};
	$n = length($self->{_input});
	$self->{_eof} = 1;
    }
    if ($self->{_blessed} || $self->{_fileno} >= 0) {
	if ($n <= 0) {
	    $log->tracef('EOF');
	    $self->{_eof} = 1;
	    $n = 0;
	} elsif ($n < $self->{_length}) {
	    $log->tracef('EOF after %d characters', $n);
	    $self->{_eof} = 1;
	}
    }
    if ($append && $idata > 0) {
	$self->{_mapbeg}->[$idata] =  $self->{_mapend}->[$idata-1];
    } else {
	$self->{_mapbeg}->[$idata] =  $pos;
    }
    $self->{_mapend}->[$idata] =  $self->{_mapbeg}->[$idata] + $n;
    $log->tracef('Buffer No %d maps to positions [%d-%d[', $idata, $self->{_mapbeg}->[$idata], $self->{_mapend}->[$idata]);
    $self->{_lastpos} = $self->{_mapend}->[$idata] - 1;
    $self->{_ndata} = $idata + 1;
    if ($self->{_eof}) {
	$self->{_maxpos} = $self->{_lastpos};
	$log->tracef('Input max position found to be %s', $self->{_maxpos});
    }
}

#
# $pos assumed to be >= 0
# This routine can recurse, but at max once
#
sub fetchc {
    my ($self, $pos) = @_;

    if ($self->{_ndata} <= 0) {
	#
	# No data cached
	#
	if ($self->{_eof}) {
	    #
	    # But EOF marked: nothing else is available
	    #
	    return undef;
	} else {
	    #
	    # Buffer next data
	    # This is where we technically disallow to go backwards.
	    #
	    $self->_read($self->{_lastpos} + 1);
	    return $self->fetchc($pos);
	}
    } else {
	if ($pos < $self->{_mapbeg}->[0]) {
	    croak "Attempt to fetch at position $pos < $self->{_mapbeg}->[0] (first cached position)";
	} else {
	    if ($pos >= $self->{_mapend}->[-1]) {
		#
		# Attempt to read beyond last cached data: need to append another buffer
		# Although this is not likely to happen, we prevent deep recursion
		# by doing the loop ourself
		#
		while (($pos >= $self->{_mapend}->[-1]) && ! $self->{_eof}) {
		    $self->_read($self->{_lastpos} + 1, 1);
		}
	    }
	    #
	    # Search buffer index hosting our position
	    #
	    my $idata;
	    my $found = 0;
	    for ($idata = 0; $idata < $self->{_ndata}; $idata++) {
		if ($pos >= $self->{_mapbeg}->[$idata] && $pos < $self->{_mapend}->[$idata]) {
		    $found = 1;
		    last;
		}
	    }
	    if (! $found) {
		#
		# Not found - a priori $self->{_eof} should be marked
		#
		if (! $self->{_eof}) {
		    croak "Fetch at position $pos fail and eof is not reached";
		} else {
		    return undef;
		}
	    } else {
		my $ipos = $pos - $self->{_mapbeg}->[$idata];
		# $log->tracef('Position %d found at position %d in buffer No %d that maps to [%d-%d]', $pos, $ipos, $idata, $self->{_mapbeg}->[$idata], $self->{_mapend}->[$idata]);
		return substr($self->{_data}->[$idata], $ipos, 1);
	    }
	}
    }
}

sub mapbeg {
    my ($self, $n) = @_;
    return $self->{_mapbeg}->[$n];
}

sub mapend {
    my ($self, $n) = @_;
    return $self->{_mapend}->[$n];
}

sub eof {
    my ($self) = @_;
    return $self->{_eof};
}

sub ndata {
    my ($self) = @_;
    return $self->{_ndata};
}

sub lastpos {
    my ($self) = @_;
    return $self->{_lastpos};
}

sub maxpos {
    my ($self) = @_;
    return $self->{_maxpos};
}

#
# $n assumed to be >= 0
# This routine can recurse, but at max once
#
sub fetchb {
    my ($self, $n) = @_;

    if ($self->{_ndata} <= 0) {
	#
	# No data cached
	#
	if ($self->{_eof}) {
	    #
	    # But EOF marked: nothing else is available
	    #
	    return undef;
	} else {
	    #
	    # Buffer next data
	    # This is where we technically disallow to go backwards.
	    #
	    $self->_read($self->{_lastpos} + 1);
	    return $self->fetchb($n);
	}
    } else {
	if ($n >= $self->{_ndata}) {
	    #
	    # Attempt to fetch a buffer beyond last cached data: need to append another buffer
	    # Although this is not likely to happen, we prevent deep recursion
	    # by doing the loop ourself
	    #
	    while (($n >= $self->{_ndata}) && ! $self->{_eof}) {
		$self->_read($self->{_lastpos} + 1, 1);
	    }
	}
	if ($n >= $self->{_ndata}) {
	    #
	    # Not found - a priori $self->{_eof} should be marked
	    #
	    if (! $self->{_eof}) {
		croak "Fetch of buffer $n fail and eof is not reached";
	    } else {
		return undef;
	    }
	} else {
	    # $log->tracef('Buffer %d and maps to [%d-%d]', $n, $self->{_mapbeg}->[$n], $self->{_mapend}->[$n]);
	    return $self->{_data}->[$n];
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
    for ($idata = 0; $idata < $self->{_ndata}; $idata++) {
	if ($pos >= $self->{_mapbeg}->[$idata] && $pos < $self->{_mapend}->[$idata]) {
	    $found = 1;
	    last;
	}
    }
    if ($found && $pos == $self->{_mapend}->[$idata] -1) {
	if ($idata > 0) {
	    $log->tracef('Deleting buffers No %d to %d', 0, $idata);
	} else {
	    $log->tracef('Deleting buffer No %d', $idata);
	}
	#
	# This position is the last one hosted by buffer No $idata
	#
	my $ndata = $idata + 1;
	splice(@{$self->{_data}}, 0, $ndata);
	splice(@{$self->{_mapbeg}}, 0, $ndata);
	splice(@{$self->{_mapend}}, 0, $ndata);
	$self->{_ndata} -= $ndata;
    }
}

#
# $n assumed to be >= 0
#
sub doneb {
    my ($self, $n) = @_;
    #
    # We want to forget (FOREVER) buffer at position $n
    # Eventually previous buffers will be destroyed.
    #
    if ($n < $self->{_ndata}) {
	if ($n > 0) {
	    $log->tracef('Deleting buffers No %d to %d', 0, $n);
	} else {
	    $log->tracef('Deleting buffer No %d', $n);
	}
	my $ndata = $n + 1;
	splice(@{$self->{_data}}, 0, $ndata);
	splice(@{$self->{_mapbeg}}, 0, $ndata);
	splice(@{$self->{_mapend}}, 0, $ndata);
	$self->{_ndata} -= $ndata;
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
# $n assumed to be >= 0
#
sub getb {
    my ($self, $n) = @_;

    $n //= 0;

    my $b;
    if (defined($b = $self->fetchb($n))) {
	$self->doneb($n);
    }
    return $b;
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
	while (! $self->{_eof}) {
	    $self->_read($self->{_lastpos} + 1);
	}
    }
    my $start = ($offset < 0) ? ($self->{_maxpos} + $offset) : $offset;
    my $end = defined($length) ? (($length < 0) ? ($self->{_maxpos} + $length) : ($start + $length - 1)) : $self->{_maxpos};

    #
    # Make sure end is reachable, take last offset if end is beyond eof
    #
    if (! defined($self->fetchc($end))) {
	#
	# This is okay only if we hitted eof, in which end is overwriten
	#
	if (! $self->{_eof}) {
	    $log->warnf('substr(%s, %s) converted to range [%d-%d] but position %d is not available', $offset, $length, $start, $end, $end);
	    return undef;
	}
	$log->warnf('substr(%s, %s) converted to range [%d-%d] but position %d is beyond eof: [%d-%d] applied', $offset, $length, $start, $end, $end, $start, $self->{_maxpos});
	$end = $self->{_maxpos};
    }
    #
    # Make sure start is not beyond end
    #
    if ($start > $end) {
	$log->warnf('substr(%s, %s) converted to range [%d-%d]', $offset, $length, $start, $end);
	return undef;
    }
    #
    # Make sure start is reachable
    #
    if (! defined($self->fetchc($start))) {
	$log->warnf('substr(%s, %s) converted to range [%d-%d] but position %d is not available', $offset, $length, $start, $end, $start);
	return undef;
    }
    #
    # Loop on all buffers to determine the span
    #
    my $idatastart = undef;
    my $idataend = undef;
    my $idata;
    for ($idata = 0; $idata < $self->{_ndata}; $idata++) {
	if (! defined($idatastart)) {
	    if ($start >= $self->{_mapbeg}->[$idata] && $start < $self->{_mapend}->[$idata]) {
		$idatastart = $idata;
	    }
	}
	if (! defined($idataend)) {
	    if ($end >= $self->{_mapbeg}->[$idata] && $end < $self->{_mapend}->[$idata]) {
		$idataend = $idata;
	    }
	}
	if (defined($idatastart) && defined($idataend)) {
	    last;
	}
    }
    my $rc = '';
    foreach ($idatastart..$idataend) {
	my $istart = ($_ == $idatastart) ? ($start - $self->{_mapbeg}->[$_]) : 0;
	my $iend = ($_ == $idataend) ? ($end - $self->{_mapbeg}->[$_]) : ($self->{_mapend}->[$_] - 1);
	my $ilength = $iend - $istart + 1;
	$rc .= substr($self->{_data}->[$_], $istart, $ilength);
    }
    return $rc;
}

# $hashp keys are string names
# $hashp values are string values
# This will generate a routine that is assuming in input:
# ($stream, $pos, $hashp)
# and will return the matched buffer followed by the name of matched strings in an array.
# The routine will loop on $stream->fetchc().
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
	my $length = length($stringValue);
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
		$log->warnf('More than one candidate for string \'%s\': %s', $stringValue, [ sort @{$length2Strings{$length}->{$stringValue}} ]);
	    }
	}
    }
    #
    # Loop on sorted lengths
    #
    my @content = ();
    push(@content, '  my ($stream, $pos, $hashp) = @_;');
    push(@content, '');
    my $i = 0;
    foreach (sort {$b <=> $a} keys %length2Strings) {
	my $length = $_;
	if ($i++ == 0) {
	    #
	    # First time
	    #
	    push(@content, '  my $string = $stream->substr($pos, ' . $length . ');');
	    push(@content, '  if (defined($string)) {');
	    push(@content, '    my $length = length($string);');	    
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
	    push(@content, '    if ($string eq $hashp->{\'' . $stringName . '\'}) {');
	    push(@content, '      return ($hashp->{\'' . $stringName . '\'}, ' . join(', ', map {"'$_'"} @{$length2Strings{$length}->{$stringValue}}) . ');');
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
