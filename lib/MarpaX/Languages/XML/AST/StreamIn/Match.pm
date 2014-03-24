use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::StreamIn::Match;
use parent 'MarpaX::Languages::XML::AST::StreamIn';
use SUPER;

# ABSTRACT: StreamIn subclass with match capability

# VERSION

#
# In any case, buf position's 0 is supposed correspond to stream's position $pos
#
sub _getBuf {
    my ($self, $pos, $buf, $length) = @_;

    if (! defined($buf)) {
	$buf = $self->substr($pos, $length);
	if (! defined($buf) || length($buf) < $length) {
	    return undef;
	}
    } else {
	if (length($buf) < $length) {
	    my $append = $self->substr($pos + length($buf), $length - length($buf));
	    if (! defined($append)) {
		return undef;
	    } else {
		$buf .= $append;
	    }
	}
    }
    return substr($buf, 0, $length);
}

#
# All methods have these three first parameters: ($self, $pos, $buf)
# where $buf is autovivified if needed, and length checked.
#

#
# Every method returns a defined value that is the match
#

sub matchChar {
    my ($self, $pos, $buf, $char) = @_;

    my $c = $self->_getBuf($pos, $buf, 1);
    return undef if (! defined($c));

    return ($c eq $char) ? $c : undef;
}

sub matchChar_closure {
    return \&matchChar;
}

#
# Here Re is supposed to be able to match a SINGLE character.
# Even if NOT the case, only current character would be returned.
#
sub matchRe {
    my ($self, $pos, $buf, $re) = @_;

    my $c = $self->_getBuf($pos, $buf, 1);
    return undef if (! defined($c));

    return ($c =~ $re) ? $c : undef;
}

sub matchRe_closure {
    return \&matchRe;
}

sub matchRange {
    my ($self, $pos, $buf, $char1, $char2) = @_;

    my $c = $self->_getBuf($pos, $buf, 1);
    return undef if (! defined($c));

    return (($c ge $char1) && ($c le $char2)) ? $c : undef;
}

sub matchRange_closure {
    return \&matchRange;
}

sub matchRanges {
    my ($self, $pos, $buf, @char12) = @_;

    my $c = $self->_getBuf($pos, $buf, 1);
    return undef if (! defined($c));

    foreach (@char12) {
	return $c if (defined($self->matchRange($pos, $buf, @{$_})));
    }

    return undef;
}

sub matchRanges_closure {
    return \&matchRanges;
}

sub matchString {
    my ($self, $pos, $buf, $string) = @_;

    my $s = $self->_getBuf($pos, $buf, length($string));
    return undef if (! defined($s));

    return ($s eq $string) ? $s : undef;
}

sub matchString_closure {
    return \&matchString;
}

sub alternative {
    my ($self, $pos, $buf, @alternativeClosures) = @_;

    foreach (@alternativeClosures) {
	my ($closure, @args) = @{$_};
	my $match = $self->$closure($pos, $buf, @args);
	return $match if (defined($match));
    }

    return undef;
}

sub alternative_closure {
    return \&alternative;
}

#
# Note: it is supposed that exclusions are mutually exclusive
#
sub exclusionString {
    my ($self, $pos, $buf, $closurep, @exclusions) = @_;

    my ($closure, @args) = @{$closurep};
    my $match = $self->$closure($pos, $buf, @args);
    return undef if (! defined($match));

    foreach (@exclusions) {
	my $pos = index($match, $_);
	if ($pos >= 0) {
	    substr($match, $pos - length($match), length($match) - $pos, '');
	    if (length($match) <= 0) {
		return 0;
	    }
	}
    }

    return undef;
}

sub exclusionString_closure {
    return \&exclusionString;
}

#
# Note: it is supposed that exclusions are mutually exclusive
#
sub exclusionRe {
    my ($self, $pos, $buf, $closurep, @exclusions) = @_;

    my ($closure, @args) = @{$closurep};
    my $match = $self->$closure($pos, $buf, @args);
    return undef if (! defined($match));

    foreach (@exclusions) {
	if ($match =~ $_) {
	    substr($match, $-[0] - length($match), length($match) - $-[0], '');
	    if (length($match) <= 0) {
		return 0;
	    }
	}
    }

    return undef;
}

sub exclusionRe_closure {
    return \&exclusionRe;
}

sub group {
    my ($self, $pos, $buf, @groupClosures) = @_;

    my $full = undef;
    my $curpos = $pos;
    foreach (@_[3..$#_]) {
	my ($closure, @args) = @{$_};
	my $match = $self->$closure($curpos, $buf, @args);
	if (! defined($match)) {
	    $full = undef;
	    last;
	}
	$full .= $match;
	my $length = length($match);
	$curpos += $length;
	substr($buf, 0, $length, '');
    }

    return $full;
}

sub group_closure {
    return \&group;
}


#
# It is supposed that:
#   $min is defined
#   $min > 0
#   $min <= $max if (defined($max))
#
# '?' is: {min,max}={0,1}
# '+' is: {min,max}={1,undef}
# '*' is: {min,max}={0,undef}
#
sub quantified {
    my ($self, $pos, $buf, $closurep, $min, $max) = @_;

    my $m = 0;
    my $full = ($min <= 0) ? '': undef;
    my ($closure, @args) = @{$closurep};
    while (++$m) {
	my $match = $self->$closure($pos, $buf, @args);
	if (defined($match)) {
	    if (defined($max) && ($m > $max)) {
		last;
	    }
	    $full .= $match;
	} else {
	    if ($m < $min) {
		$full = undef;
	    }
	    last;
	}
	my $length = length($match);
	$pos += length($match);
	substr($buf, 0, $length, '');
    }

    return $full;
}

sub quantified_closure {
    return \&quantified;
}


1;
