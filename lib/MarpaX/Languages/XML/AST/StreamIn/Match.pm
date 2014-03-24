use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::StreamIn::Match;
use parent 'MarpaX::Languages::XML::AST::StreamIn';
use SUPER;

# ABSTRACT: StreamIn subclass with match capability

# VERSION

sub new {
  my $self = super();
  $self->[20] = {};
  return $self;
}

sub doneMatch {
  # my ($self, $pos) = @_;
  foreach (grep {$_ <= $_[1]} keys %{$_[0]->[20]}) {
    delete($_[0]->[20]->{$_});
  }
}

#
# Match is always working on user's buf, and can extend
# it if needed, without telling so to the caller.
# This will be without side-effect: the buffer can be
# extended (taking part of the next cached buffer(s)), but
# never truncated.
#
# $buf is expected to never be undef and to always map to
# a physical location >= $pos
#
sub _getBuf {
  # my ($self, $pos, $buf, $mapbeg, $mapend, $length) = @_;

  my $full = undef;
  my $ipos = $_[1];
  my $i = 0;
  while (++$i <= $_[5]) {
    my $c = $_[0]->_getC($ipos++, $_[2], $_[3], $_[4]);
    return undef if (! defined($c));
    $full .= $c;
  }

  return $full;
 jdd:
  my $end = $_[1] + $_[5] - 1;
  if ($end >= $_[4]) {
    my $append = $_[0]->substr($_[4], $end - $_[4] + 1);
    if (! defined($append)) {
      return undef;
    } else {
      $_[2] .= $append;
    }
  }

  return substr($_[2], $_[1] - $_[3], $_[5]);
}

sub _getC {
  # my ($self, $pos, $buf, $mapbeg, $mapend) = @_;

  if (! defined($_[0]->[20]->{$_[1]})) {
    if ($_[1] >= $_[3] && $_[1] < $_[4]) {
      return $_[0]->[20]->{$_[1]} = substr($_[2], $_[1], 1);
    } else {
      return undef;
    }
  } else {
    return $_[0]->[20]->{$_[1]};
  }

}

#
# All methods have these three first parameters: ($self, $pos, $buf)
# where $buf is autovivified if needed, and length checked.
#

#
# Every method returns a defined value that is the match
#

sub matchChar {
    # my ($self, $pos, $buf, $mapbeg, $mapend, $char) = @_;

    my $c = $_[0]->_getC($_[1], $_[2], $_[3], $_[4]);
    return undef if (! defined($c));

    return ($c eq $_[5]) ? $c : undef;
}

sub matchChar_closure {
    return \&matchChar;
}

#
# Here Re is supposed to be able to match a SINGLE character.
# Even if NOT the case, only current character would be returned.
#
sub matchRe {
    # my ($self, $pos, $buf, $mapbeg, $mapend, $re) = @_;

    my $c = $_[0]->_getC($_[1], $_[2], $_[3], $_[4]);
    return undef if (! defined($c));

    return ($c =~ $_[5]) ? $c : undef;
}

sub matchRe_closure {
    return \&matchRe;
}

sub matchRange {
    # my ($self, $pos, $buf, $mapbeg, $mapend, $char1, $char2) = @_;

    my $c = $_[0]->_getC($_[1], $_[2], $_[3], $_[4]);
    return undef if (! defined($c));

    #
    # If $_[6] is undef, this is assumed to be a single char
    #
    if (defined($_[6])) {
      return (($c ge $_[5]) && ($c le $_[6])) ? $c : undef;
    } else {
      return ($c eq $_[5]) ? $c : undef;
    }
}

sub matchRange_closure {
    return \&matchRange;
}

sub matchRanges {
    # my ($self, $pos, $buf, $mapbeg, $mapend, @char12) = @_;

    my $c = $_[0]->_getC($_[1], $_[2], $_[3], $_[4]);
    return undef if (! defined($c));

    foreach (@_[5..$#_]) {
	return $c if (defined($_[0]->matchRange($_[1], $_[2], $_[3], $_[4], @{$_})));
    }

    return undef;
}

sub matchRanges_closure {
    return \&matchRanges;
}

sub matchString {
    # my ($self, $pos, $buf, $mapbeg, $mapend, $string) = @_;

    my $s = $_[0]->_getBuf($_[1], $_[2], $_[3], $_[4], length($_[5]));
    return undef if (! defined($s));

    return ($s eq $_[5]) ? $s : undef;
}

sub matchString_closure {
    return \&matchString;
}

sub alternative {
    # my ($self, $pos, $buf, $mapbeg, $mapend, @alternativeClosures) = @_;

    foreach (@_[5..$#_]) {
	my ($closure, @args) = @{$_};
	my $match = $_[0]->$closure($_[1], $_[2], $_[3], $_[4], @args);
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
    # my ($self, $pos, $buf, $mapbeg, $mapend, $closurep, @exclusions) = @_;

    my ($closure, @args) = @{$_[5]};
    my $match = $_[0]->$closure($_[1], $_[2], $_[3], $_[4], @args);
    return undef if (! defined($match));

    foreach (@_[6..$#_]) {
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
    # my ($self, $pos, $buf, $mapbeg, $mapend, $closurep, @exclusions) = @_;

    my ($closure, @args) = @{$_[5]};
    my $match = $_[0]->$closure($_[1], $_[2], $_[3], $_[4], @args);
    return undef if (! defined($match));

    foreach (@_[6..$#_]) {
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
    # my ($self, $pos, $buf, $mapbeg, $mapend, @groupClosures) = @_;

    my $full = undef;
    my $curpos = $_[1];
    foreach (@_[5..$#_]) {
	my ($closure, @args) = @{$_};
	my $match = $_[0]->$closure($curpos, $_[2], $_[3], $_[4], @args);
	if (! defined($match)) {
	    $full = undef;
	    last;
	}
	$full .= $match;
	my $length = length($match);
	$curpos += $length;
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
    # my ($self, $pos, $buf, $mapbeg, $mapend, $closurep, $min, $max) = @_;

    my $m = 0;
    my $full = ($_[6] <= 0) ? '': undef;
    my ($closure, @args) = @{$_[5]};
    my $pos = $_[1];
    while (++$m) {
	my $match = $_[0]->$closure($pos, $_[2], $_[3], $_[4], @args);
	if (defined($match)) {
	    if (defined($_[7]) && ($m > $_[7])) {
		last;
	    }
	    $full .= $match;
	} else {
	    if ($m < $_[6]) {
		$full = undef;
	    }
	    last;
	}
	my $length = length($match);
	$pos += length($match);
    }

    return $full;
}

sub quantified_closure {
    return \&quantified;
}


1;
