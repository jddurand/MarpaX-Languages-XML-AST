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
	_length  => $opts{length} || 1024*1024*1024, # Number of characters of every cached data
	_mapend  => [],                              # Mapped position of each last data (exclusive)
	_mapbeg  => [],                              # Mapped position of each first data (inclusive)
	_eof     => 0,                               # Last buffer reached
	_blessed => 0,                               # true if input is blessed
	_fileno  => -1,                              # >= 0 if input appears to be a true filehandle
	_ndata   => 0                                # Number of cached buffers
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
	$log->tracef('Asking input for %d characters in buffer No %d', $self->{_length}, $idata);
	$n = $self->{_input}->read($self->{_data}->[$idata], $self->{_length}) || 0;
    } elsif ($self->{_fileno} >= 0) {
	$log->tracef('Reading %d characters in buffer No %d', $self->{_length}, $idata);
	$n = read($self->{_input}, $self->{_data}->[$idata], $self->{_length}) || 0;
    } else {
	$log->tracef('Mapping scalar into buffer No %d', $idata);
	#
	# Assumed to be a true scalar - no real read, fake a single whole buffer
	#
	$self->{_data}->[$idata] = $self->{_input};
	$n = length($self->{_input});
    }
    if ($n <= 0) {
	$log->tracef('EOF');
	$self->{_eof} = 1;
	pop($self->{_data});
    } else {
	if ($append && $idata > 0) {
	    $self->{_mapbeg}->[$idata] =  $self->{_mapend}->[$idata-1];
	} else {
	    $self->{_mapbeg}->[$idata] =  $pos;
	}
	$self->{_mapend}->[$idata] =  $self->{_mapbeg}->[$idata] + $n;
	$log->tracef('Buffer No %d maps to positions [%d-%d]', $idata, $self->{_mapbeg}->[$idata], $self->{_mapend}->[$idata]);
	$self->{_ndata} = $idata + 1;
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
	# No data yet
	#
	if ($self->{_eof}) {
	    #
	    # But EOF marked: already attempted to get data and it failed
	    #
	    return undef;
	} else {
	    #
	    # Fetch very first data
	    #
	    $self->_read($pos);
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
		    $self->_read($pos, 1);
		}
	    }
	    #
	    # Search buffer index hosting our position
	    #
	    my $idata = -1;
	    foreach (0..$self->{_ndata}) {
		if ($pos >= $self->{_mapbeg}->[$_] && $pos < $self->{_mapend}->[$_]) {
		    $idata = $_;
		    last;
		}
	    }
	    if ($idata < 0) {
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
    my $idata = -1;
    foreach (0..$self->{_ndata}) {
	if ($pos >= $self->{_mapbeg}->[$_] && $pos < $self->{_mapend}->[$_]) {
	    $idata = $_;
	    last;
	}
    }
    if ($idata >= 0 && $pos == $self->{_mapend}->[$idata] -1) {
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

1;
