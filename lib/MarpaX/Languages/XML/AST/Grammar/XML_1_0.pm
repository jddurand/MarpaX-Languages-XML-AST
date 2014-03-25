use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0;
use MarpaX::Languages::XML::AST::StreamIn::Match;
use MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util qw/%TOKEN/;
use MarpaX::Languages::XML::AST::Util qw/:all/;
use Carp qw/croak/;
use Marpa::R2 2.082000;
use Log::Any qw/$log/;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) written in Marpa BNF

# VERSION

our $DATA = do {local $/; <DATA>};

#
# There are several DIFFERENT top-level productions in the XML grammar
#
our %G = ();
foreach (qw/document/) {
  my $top = $_;
  $DATA =~ s/(:start\s*::=\s*)(.*)/$1$top/g;
  print STDERR "Compiling $top production\n";
  $G{$top} = Marpa::R2::Scanless::G->new({source => \$DATA, bless_package => 'XML'});
}

sub new {
  my ($class, %opts) = @_;

  my $self = {};

  bless($self, $class);

  return $self;
}

my %stats = ();
sub _doEvents {
  my ($self, $input, $pos, $recce) = @_;

  my @alternatives = ();
  my $longest = -1;
  my $value = '';
  pos($input) = $pos;
  foreach (@{$recce->events()}) {
    my ($name) = @{$_};
    #printf STDERR "? $name\n";
    #
    # We made sure that we are paused only on lexemes
    #
    my $start = Time::HiRes::gettimeofday();
    my $token = $TOKEN{$name}($input, $pos);
    my $end = Time::HiRes::gettimeofday();
    $stats{$name}{calls}++;
    $stats{$name}{time} += ($end - $start);
    if (defined($token)) {
      my $length = length($token);
      if ($length > $longest) {
        $#alternatives = -1;
        push(@alternatives, $name);
        $longest = $length;
        $value = $token;
      } elsif ($length == $longest) {
        push(@alternatives, $name);
      }
    }
  }
  if (! @alternatives) {
    logCroak($recce, $input, "No alternative", $pos);
  }
  foreach (@alternatives) {
    my $name = $_;
    #my $lp = lineAndCol($recce, $pos);
    #printf STDERR "%-10s %s \"%s\"\n", "L$lp->[0]c$lp->[1]", $name, $value;
    $recce->lexeme_alternative($name, $value);
  }
  $recce->lexeme_complete($pos, $longest);

  return $pos+$longest;
}

use Time::HiRes;
END {
  printf STDERR "%-20s %10s %s\n", "Lexeme", "Calls", "Time";
  printf STDERR "%-20s %10s %s\n", "------", "-----", "----";
  foreach (sort {$stats{$a}{time} <=> $stats{$b}{time}} keys %stats) {
    printf STDERR "%-20s %10s %s\n", $_, $stats{$_}{calls}, $stats{$_}{time};
  }
}
#
# The whole optiéisation is based on NO manipulation of cached buffer, except
# substracting from it, which is rather fast (perl's substr() has been
# defined for that).
# This mean that $buf always point to current data buffer and nothing else.
# This buffer could be extended on the stack by the internal maching closure,
# but this will NOT affect StreamIn knowedge of physical locations for a buffer.
#
# For instance:
# - Suppose that buffer x1 maps to real positions [y11, y12]
# - The matching routine will need to get data beyond y2
# - The laters will call StreamIn for another buffer, if any, that will create
#   a new buffer x2 mapping to [y21, y22], where y21 = y12+1.
# - buffer x1 could be extended to x1 + part of x2
# - StreamIn.pm will not know about this, neither this module.
#
sub parse {
  my ($self, $input) = @_;

  my $recce = Marpa::R2::Scanless::R->new( { grammar => $G{document} } );
  my $fake_input = ' ';
  my $pos = $recce->read(\$fake_input);
  #
  # We made sure we are paused at the very beginning with event '^document'
  #
  # Loop on the streamed input buffer
  #
  my $now = time();
  my $stream = MarpaX::Languages::XML::AST::StreamIn::Match->new(input => $input);
  my ($buf, $mapbeg, $mapend) = $stream->getb();
  if (defined($buf)) {
      my $bufLength = $mapend - $mapbeg;
      while (1) {
	  my @events = @{$recce->events()};
	  if (! @events) {
	      $log->tracef('No event');
	      last;
	  }
	  my @terminals_expected = map {$_->[0]} @events;
	  my ($length, $matched, @tokens) = $self->get_tokens($stream, $pos, $buf, $mapbeg, $mapend, @terminals_expected);
	  if (! @tokens) {
	      #
	      # Acceptable only if $buf is pointing to a discard character or end of buffer
	      #
	      if ($pos < $mapend && substr($buf, $pos - $mapbeg, 1) =~ /\s/) {
		  $length++;
		  $log->tracef('pos=%6d/%6d : discarding character', $pos, $mapend);
	      } elsif ($stream->eof && $pos == $mapend) {
		  $log->tracef('pos=%6d/%6d : end of stream', $pos, $mapend);
		  last;
	      } else {
		  die "Failed at position $pos: " . substr($buf, $pos - $mapbeg, 10) . "...\nContext:\n" . $recce->show_progress;
	      }
	  } else {
	      foreach (@tokens) {
		  #
		  # The array is a reference to [$name, $value], where value can be undef
		  #
		  $log->tracef('pos=%6d/%6d : lexeme_alternative("%s", "%s")', $pos, $mapend, $_, $matched);
		  $recce->lexeme_alternative($_, $matched);
	      }
	      # $log->tracef('pos=%6d/%6d : lexeme_complete(0, 1)', $pos, $mapend);
	      $recce->lexeme_complete(0, 1);
              $stream->doneMatch($pos);
	  }
          $pos += $length;
	  #
	  # Next buffer ?
	  #
	  if ($pos >= $mapend) {
	      $log->tracef('pos=%6d/%6d : Asking or next buffer', $pos, $mapend);
            ($buf, $mapbeg, $mapend) = $stream->getb();
            $buf = $stream->getb();
            if (! defined($buf)) {
              last;
            }
            $bufLength = $mapend - $mapbeg;
          }
          if (time() - $now > 300) {
            $log->tracef('Exiting');
            exit;
          }
	  #$recce->resume();
      }
  }
  my $nvalue = 0;
  while (defined($_ = $recce->value)) {
      ++$nvalue;
      #$log->tracef('Value %d: %s', $nvalue, $_);
  }
  $log->tracef('Total number of values: %d', $nvalue);
}

sub get_tokens {
  my ($self, $stream, $pos, $buf, $mapbeg, $mapend, @terminals_expected) = @_;

  #
  # We maintain an internal status per terminal:
  # -1 : cannot happen
  #  0 : not fully processed
  #  1 : found

  my $length = 0;
  my @tokens = ();
  my $matched = undef;
  my %terminals = ();
  foreach (@terminals_expected) {
      my $terminal = $_;
      # $log->tracef('Trying %s', $terminal);
      my $closure = $TOKEN{$terminal};
      my $match = $stream->$closure($pos, $buf, $mapbeg, $mapend);
      if (defined($match)) {
	  # $log->tracef('%s => %s', $terminal, $match);
	  my $matchLength = length($match);
	  if (! $length || $matchLength > $length) {
	      $length = $matchLength;
	      $matched = $match;
	      @tokens = ( $terminal );
	  } elsif ($matchLength == $length) {
	      push(@tokens, $terminal);
	  }
      }
  }
  return ($length, $matched, @tokens);
}

#
# Every token is dissected using closures that expect as parameters:
# - current character (constant)
# - current (eventually partial) match for this token
# - opaque state internal to token, with a content understandable only by it
#
# states are only used in closures that map exactly to a lexeme.
#

sub wantnext {
  my ($self, $token, $c, $wanted, $nextp) = @_;
  print STDERR "$token\n";
}

# ---------------------------------------------------------------
# Internal regexps. Designed to match at most a single character.
# ---------------------------------------------------------------
our $REG_NAMESTARTCHAR          = qr/^[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]/;
our $REG_NAMECHAR               = qr/$REG_NAMESTARTCHAR|^[-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]/;
our $REG_PUBIDCHAR_NOT_DQUOTE   = qr/^[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]/;
our $REG_PUBIDCHAR_NOT_SQUOTE   = qr/^[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]/;
our $REG_CHARCOMMENT            = qr/^[\x{9}\x{A}\x{D}\x{20}-\x{2C}\x{2E}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]/;
our $REG_CHAR                   = qr/^[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]/;
our $REG_S                      = qr/^[\x{20}\x{9}\x{D}\x{A}]/;
our $REG_NOT_DQUOTE             = qr/^[^"]/;
our $REG_NOT_SQUOTE             = qr/^[^']/;
our $REG_CHARDATA               = qr/^[^<&]/;
our $REG_DIGIT                  = qr/^[0-9]/;
our $REG_HEXDIGIT               = qr/^[0-9a-fA-F]/;
our $REG_ALPHA                  = qr/^[A-Za-z]/;
our $REG_ENCNAME_REST           = qr/^[A-Za-z0-9._-]/;
our $REG_ATTVALUE_NOT_DQUOTE    = qr/^[^<&"]/;
our $REG_ATTVALUE_NOT_SQUOTE    = qr/^[^<&']/;
our $REG_ENTITYVALUE_NOT_DQUOTE = qr/^[^%&"]/;
our $REG_ENTITYVALUE_NOT_SQUOTE = qr/^[^%&']/;

# -----------------------------------------------------------------------
# TOKEN closures
# Arguments are always: ($stream, $pos, $buf)
# -----------------------------------------------------------------------
our %TOKEN = ();
#
# NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
# ----------------------------------------------
$TOKEN{NAME} = sub {
    my $stream = shift;
    
    return
	$stream->group
	(@_,
	 # ${REG_NAMESTARTCHAR}
	 [ $stream->matchRe_closure, $REG_NAMESTARTCHAR ],
	 # ${REG_NAMECHAR}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_NAMECHAR ], 0, undef ],
	);
};
$TOKEN{NAME_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->group_closure,
	  # ${REG_NAMESTARTCHAR}
	  [ $stream->matchRe_closure, $REG_NAMESTARTCHAR ],
	  # ${REG_NAMECHAR}*
	  [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_NAMECHAR ], 0, undef ],
	];
};
our $TOKEN_NAME_CLOSURE = $TOKEN{NAME_CLOSURE};
#
# S is /${REG_S}+/
# ----------------
$TOKEN{S} = sub {
    my $stream = shift;
    
    return
	# ${REG_S}+
	$stream->quantified
	(@_,
	 [ $stream->matchRe_closure, $REG_S ],
	 1,
	 undef);
};
#
# NMTOKEN is /${REG_NAMECHAR}+/
# -----------------------------
$TOKEN{NMTOKEN} = sub {
    my $stream = shift;
    
    return
	# ${REG_NAMECHAR}+
	$stream->quantified
	(@_,
	 [ $stream->matchRe_closure, $REG_NAMECHAR ],
	 1,
	 undef);
};
#
# SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
# ------------------------------------------------------------------
$TOKEN{SYSTEMLITERAL} = sub {
    my $stream = shift;
    
    return
	$stream->alternative
	(@_,
	 [ $stream->group_closure,
	   # "
	   [ $stream->matchChar_closure, '"' ],
	   # ${REG_NOT_DQUOTE}*
	   [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_NOT_DQUOTE ], 0, undef ],
	   # "
	   [ $stream->matchChar_closure, '"' ],
	 ],
	 [ $stream->group_closure,
	   # '
	   [ $stream->matchChar_closure, '\'' ],
	   # ${REG_NOT_SQUOTE}*
	   [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_NOT_SQUOTE ], 0, undef ],
	   # "
	   [ $stream->matchChar_closure, '\'' ],
	 ]
	);
};
#
# PUDIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/
# ------------------------------------------------------------------------------------
$TOKEN{PUBIDLITERAL} = sub {
    my $stream = shift;
    
    return
	$stream->alternative,
	(@_,
	 [ $stream->group_closure,
	   # "
	   [ $stream->matchChar_closure, '"' ],
	   # ${REG_PUBIDCHAR_DQUOTE}*
	   [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_PUBIDCHAR_NOT_DQUOTE ], 0, undef ],
	   # "
	   [ $stream->matchChar_closure, '"' ],
	 ],
	 [ $stream->group_closure,
	   # '
	   [ $stream->matchChar_closure, '\'' ],
	   # ${REG_PUBIDCHAR_SQUOTE}*
	   [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_PUBIDCHAR_NOT_SQUOTE ], 0, undef ],
	   # "
	   [ $stream->matchChar_closure, '\'' ],
	 ],
	);
};
#
# CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
# -------------------------------------------------------
$TOKEN{CHARDATA} = sub {
    my $stream = shift;
    
    return
	$stream->exclusionString
	(@_,
	 # ${REG_CHARDATA}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_CHARDATA ], 0, undef ],
	 ']]>',
	)
};
#
# CDATA is /${REG_CHAR}*/ minus the sequence ']]>'
# ------------------------------------------------
$TOKEN{CDATA} = sub {
    my $stream = shift;
    
    return
	$stream->exclusionString
	(@_,
	 # ${REG_CHAR}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_CHAR ], 0, undef ],
	 ']]>',
	)
};
#
# COMMENT is CHAR* minus the sequence '--'
# ----------------------------------------
$TOKEN{COMMENT} = sub {
    my $stream = shift;
    
    return
	$stream->exclusionString
	(@_,
	 # ${REG_CHAR}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_CHAR ], 0, undef ],
	 '--',
	)
};
#
# PITARGET is NAME without /xml/i
# -------------------------------
# Perl does not like $TOKEN{NAME}(...)
our $TOKEN_NAME = $TOKEN{NAME};
$TOKEN{PITARGET} = sub {
    my $stream = shift;
    
    return
	$stream->exclusionRe
	(@_,
	 $stream->$TOKEN_NAME_CLOSURE(@_),
	 /xml/i
	)
};
#
# PI_INTERIOR is CHAR* minus the sequence '?>'
# --------------------------------------------
$TOKEN{PI_INTERIOR} = sub {
    my $stream = shift;
    
    return
	$stream->exclusionString
	(@_,
	 # ${REG_CHAR}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_CHAR ], 0, undef ],
	 '?>',
	)
};
#
# VERSIONNUM is /1.${REG_DIGIT}+/
# -------------------------------
$TOKEN{VERSIONNUM} = sub {
    my $stream = shift;
    
    return
	$stream->group
	(@_,
	 # 1.
	 [ $stream->matchString_closure, '1.' ],
	 # [0-9]+
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_DIGIT ], 1, undef ],
	);
};
#
# IGNORE_INTERIOR is /${REG_CHAR}*/ minus the sequence '<![' or ']]>'
# -------------------------------------------------------------------
$TOKEN{IGNORE_INTERIOR} = sub {
    my $stream = shift;
    
    return
	$stream->exclusionString
	(@_,
	 # ${REG_CHAR}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_CHAR ], 0, undef ],
	 '<![',
	 ']]>',
	)
};
#
# ENTITYREF is /&${NAME};/
# --------------------------------
$TOKEN{ENTITYREF} = sub {
    my $stream = shift;
    
    return
	$stream->group
	(@_,
	 # &
	 [ $stream->matchString_closure, '&' ],
	 # ${NAME}
	 $stream->$TOKEN_NAME_CLOSURE(@_),
	 # ;
	 [ $stream->matchString_closure, ';' ],
	);
};
$TOKEN{ENTITYREF_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->group_closure,
	  # &
	  [ $stream->matchString_closure, '&' ],
	  # ${NAME}
	  $stream->$TOKEN_NAME_CLOSURE(@_),
	  # ;
	  [ $stream->matchString_closure, ';' ],
	];
};
our $TOKEN_ENTITYREF_CLOSURE = $TOKEN{ENTITYREF_CLOSURE};
#
# PEREFERENCE is /%${REG_NAME};/
# ------------------------------
$TOKEN{PEREFERENCE} = sub {
    my $stream = shift;
    
    return
	$stream->group
	(@_,
	 # %
	 [ $stream->matchString_closure, '&' ],
	 # ${NAME}
	 $stream->$TOKEN_NAME_CLOSURE(@_),
	 # ;
	 [ $stream->matchString_closure, ';' ],
	);
};
$TOKEN{PEREFERENCE_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->group_closure,
	  # %
	  [ $stream->matchString_closure, '&' ],
	  # ${NAME}
	  $stream->$TOKEN_NAME_CLOSURE(@_),
	  # ;
	  [ $stream->matchString_closure, ';' ],
	];
};
our $TOKEN_PEREFERENCE_CLOSURE = $TOKEN{PEREFERENCE_CLOSURE};
#
# ENCNAME is /${REG_ALPHA}${REG_ENCNAME_REST}*/
# ---------------------------------------------
$TOKEN{ENCNAME} = sub {
    my $stream = shift;
    
    return
	$stream->group
	(@_,
	 # ${REG_ALPHA}
	 [ $stream->matchRe_closure, $REG_ALPHA ],
	 # ${REG_ENCNAME_REST}*
	 [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_ENCNAME_REST ], 0, undef ],
	);
};

# CHARREF is /&#${REG_DIGIT}+;/
#         or /&#x${REG_HEXDIGIT}+;/
# ---------------------------------
$TOKEN{CHARREF_INTERIOR_1_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->group_closure, 
	  # &#
	  [ $stream->matchString_closure, '&#' ],
	  # ${REG_DIGIT}+
	  [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_DIGIT ], 1, undef ],
	  # ';'
	  [ $stream->matchChar_closure, ';' ],
	];
};
our $TOKEN_CHARREF_INTERIOR_1_CLOSURE = $TOKEN{CHARREF_INTERIOR_1_CLOSURE};
$TOKEN{CHARREF_INTERIOR_2_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->group_closure, 
	  # &#x
	  [ $stream->matchString_closure, '&#x' ],
	  # ${REG_HEXDIGIT}+
	  [ $stream->quantified_closure, [ $stream->matchRe_closure, $REG_HEXDIGIT ], 1, undef ],
	  # ';'
	  [ $stream->matchChar_closure, ';' ],
	];
};
our $TOKEN_CHARREF_INTERIOR_2_CLOSURE = $TOKEN{CHARREF_INTERIOR_2_CLOSURE};
$TOKEN{CHARREF} = sub {
    my $stream = shift;
    
    return
	$stream->alternative
	(@_,
	 $stream->$TOKEN_CHARREF_INTERIOR_1_CLOSURE(@_),
	 $stream->$TOKEN_CHARREF_INTERIOR_2_CLOSURE(@_),
	);
};
$TOKEN{CHARREF_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->alternative_closure,
          $stream->$TOKEN_CHARREF_INTERIOR_1_CLOSURE(@_),
          $stream->$TOKEN_CHARREF_INTERIOR_2_CLOSURE(@_),
	];
};
our $TOKEN_CHARREF_CLOSURE = $TOKEN{CHARREF_CLOSURE};
#
# ATTVALUE is /"(${REG_ATTVALUE_NOT_DQUOTE}|Reference)*"/
#          or /'(${REG_ATTVALUE_NOT_SQUOTE}|Reference)*'/
#
# where Reference is: EntityRef | CharRef
# ------------------------------------------
$TOKEN{REFERENCE_CLOSURE} = sub {
    my $stream = shift;
    
    return
	[ $stream->alternative_closure,
	  # EntityRef
	  $stream->$TOKEN_ENTITYREF_CLOSURE(@_),
	  # CharRef
	  $stream->$TOKEN_CHARREF_CLOSURE(@_),
	];
};
our $TOKEN_REFERENCE_CLOSURE = $TOKEN{REFERENCE_CLOSURE};
$TOKEN{ATTVALUE} = sub {
    my $stream = shift;
    
    return $stream->alternative
	(@_,
	 [ $stream->group_closure,
	   # "
	   [ $stream->matchChar_closure, '"' ],
	   # (${REG_ATTVALUE_NOT_DQUOTE}|Reference)*
	   [ $stream->quantified_closure, 
	     [ $stream->alternative_closure,
	       # ${REG_ATTVALUE_NOT_DQUOTE}
	       [ $stream->matchRe_closure, $REG_ATTVALUE_NOT_DQUOTE ],
	       # Reference
	       $stream->$TOKEN_REFERENCE_CLOSURE(@_),
	     ],
	     0,
	     undef
	     ],
	   # "
	   [ $stream->matchChar_closure, '"' ],
	 ],
	 [ $stream->group_closure,
	   # '
	   [ $stream->matchChar_closure, '\'' ],
	   # (${REG_ATTVALUE_NOT_SQUOTE}|Reference)*
	   [ $stream->quantified_closure, 
	     [ $stream->alternative_closure,
	       # ${REG_ATTVALUE_NOT_SQUOTE}
	       [ $stream->matchRe_closure, $REG_ATTVALUE_NOT_SQUOTE ],
	       # Reference
	       $stream->$TOKEN_REFERENCE_CLOSURE(@_),
	     ],
	     0,
	     undef
	   ],
	   # '
	   [ $stream->matchChar_closure, '\'' ],
	 ]
	);
};

#
# ENTITYVALUE is /"(${REG_ENTITYVALUE_NOT_DQUOTE}|PEReference|Reference)*"/
#             or /'(${REG_ENTITYVALUE_NOT_DQUOTE}|PEReference|Reference)*'/
#
# where Reference is: EntityRef | CharRef
# ------------------------------------------
$TOKEN{ENTITYVALUE} = sub {
    my $stream = shift;
    
    return $stream->alternative
	(@_,
	 [ $stream->group_closure,
	   # "
	   [ $stream->matchChar_closure, '"' ],
	   # (${REG_ENTITYVALUE_NOT_DQUOTE}|Reference)*
	   [ $stream->quantified_closure, 
	     [ $stream->alternative_closure,
	       # ${REG_ENTITYVALUE_NOT_DQUOTE}
	       [ $stream->matchRe_closure, $REG_ENTITYVALUE_NOT_DQUOTE ],
	       # PEReference
	       $stream->$TOKEN_PEREFERENCE_CLOSURE(@_),
	       # Reference
	       $stream->$TOKEN_REFERENCE_CLOSURE(@_),
	     ],
	     0,
	     undef
	   ],
	   # "
	   [ $stream->matchChar_closure, '"' ],
	 ],
	 [ $stream->group_closure,
	   # '
	   [ $stream->matchChar_closure, '\'' ],
	   # (${REG_ENTITYVALUE_NOT_SQUOTE}|Reference)*
	   [ $stream->quantified_closure, 
	     # 
	     [ $stream->alternative_closure,
	       # ${REG_ENTITYVALUE_NOT_SQUOTE}
	       [ $stream->matchRe_closure, $REG_ENTITYVALUE_NOT_SQUOTE ],
	       # PEReference
	       $stream->$TOKEN_PEREFERENCE_CLOSURE(@_),
	       # Reference
	       $stream->$TOKEN_REFERENCE_CLOSURE(@_),
	     ],
	     0,
	     undef
	     ],
	   # '
	   [ $stream->matchChar_closure, '\'' ],
	 ]
	);
};

#
# Fixed strings
#
$TOKEN{X20}              = sub { my $stream = shift; return $stream->matchChar(@_, "\x{20}") };
$TOKEN{DQUOTE}           = sub { my $stream = shift; return $stream->matchChar(@_, '"') };
$TOKEN{SQUOTE}           = sub { my $stream = shift; return $stream->matchChar(@_, "'") };
$TOKEN{EQUAL}            = sub { my $stream = shift; return $stream->matchChar(@_, '=') };
$TOKEN{LBRACKET}         = sub { my $stream = shift; return $stream->matchChar(@_, '[') };
$TOKEN{RBRACKET}         = sub { my $stream = shift; return $stream->matchChar(@_, ']') };
$TOKEN{XTAG_BEG}         = sub { my $stream = shift; return $stream->matchChar(@_, '<') };
$TOKEN{XTAG_END}         = sub { my $stream = shift; return $stream->matchChar(@_, '>') };
$TOKEN{QUESTION_MARK}    = sub { my $stream = shift; return $stream->matchChar(@_, '?') };
$TOKEN{STAR}             = sub { my $stream = shift; return $stream->matchChar(@_, '*') };
$TOKEN{PLUS}             = sub { my $stream = shift; return $stream->matchChar(@_, '+') };
$TOKEN{LPAREN}           = sub { my $stream = shift; return $stream->matchChar(@_, '(') };
$TOKEN{RPAREN}           = sub { my $stream = shift; return $stream->matchChar(@_, ')') };
$TOKEN{PIPE}             = sub { my $stream = shift; return $stream->matchChar(@_, '|') };
$TOKEN{COMMA}            = sub { my $stream = shift; return $stream->matchChar(@_, ',') };
$TOKEN{PERCENT}          = sub { my $stream = shift; return $stream->matchChar(@_, '%') };

$TOKEN{COMMENT_BEG}      = sub { my $stream = shift; return $stream->matchString(@_, '<!--') };
$TOKEN{COMMENT_END}      = sub { my $stream = shift; return $stream->matchString(@_, '-->') };
$TOKEN{PI_BEG}           = sub { my $stream = shift; return $stream->matchString(@_, '<?') };
$TOKEN{PI_END}           = sub { my $stream = shift; return $stream->matchString(@_, '?>') };
$TOKEN{CDSTART}          = sub { my $stream = shift; return $stream->matchString(@_, '<![CDATA[') };
$TOKEN{CDEND}            = sub { my $stream = shift; return $stream->matchString(@_, ']]>') };
$TOKEN{XML_BEG}          = sub { my $stream = shift; return $stream->matchString(@_, '<?xml') };
$TOKEN{XML_END}          = sub { my $stream = shift; return $stream->matchString(@_, '?>') };
$TOKEN{VERSION}          = sub { my $stream = shift; return $stream->matchString(@_, 'version') };
$TOKEN{DOCTYPE_BEG}      = sub { my $stream = shift; return $stream->matchString(@_, '<!DOCTYPE') };
$TOKEN{STANDALONE}       = sub { my $stream = shift; return $stream->matchString(@_, 'standalone') };
$TOKEN{YES}              = sub { my $stream = shift; return $stream->matchString(@_, 'yes') };
$TOKEN{NO}               = sub { my $stream = shift; return $stream->matchString(@_, 'no') };
$TOKEN{ETAG_BEG}         = sub { my $stream = shift; return $stream->matchString(@_, '</') };
$TOKEN{EMPTYELEMTAG_END} = sub { my $stream = shift; return $stream->matchString(@_, '/>') };
$TOKEN{ELEMENTDECL_BEG}  = sub { my $stream = shift; return $stream->matchString(@_, '<!ELEMENT') };
$TOKEN{EMPTY}            = sub { my $stream = shift; return $stream->matchString(@_, 'EMPTY') };
$TOKEN{ANY}              = sub { my $stream = shift; return $stream->matchString(@_, 'ANY') };
$TOKEN{RPARENSTAR}       = sub { my $stream = shift; return $stream->matchString(@_, '(*') };
$TOKEN{PCDATA}           = sub { my $stream = shift; return $stream->matchString(@_, '#PCDATA') };
$TOKEN{ATTLIST_BEG}      = sub { my $stream = shift; return $stream->matchString(@_, '<!ATTLIST') };
$TOKEN{STRINGTYPE}       = sub { my $stream = shift; return $stream->matchString(@_, 'CDATA') };
$TOKEN{TYPE_ID}          = sub { my $stream = shift; return $stream->matchString(@_, 'ID') };
$TOKEN{TYPE_IDREF}       = sub { my $stream = shift; return $stream->matchString(@_, 'IDREF') };
$TOKEN{TYPE_IDREFS}      = sub { my $stream = shift; return $stream->matchString(@_, 'IDREFS') };
$TOKEN{TYPE_ENTITY}      = sub { my $stream = shift; return $stream->matchString(@_, 'ENTITY') };
$TOKEN{TYPE_ENTITIES}    = sub { my $stream = shift; return $stream->matchString(@_, 'ENTITIES') };
$TOKEN{TYPE_NMTOKEN}     = sub { my $stream = shift; return $stream->matchString(@_, 'NMTOKEN') };
$TOKEN{TYPE_NMTOKENS}    = sub { my $stream = shift; return $stream->matchString(@_, 'NMTOKENS') };
$TOKEN{NOTATION}         = sub { my $stream = shift; return $stream->matchString(@_, 'NOTATION') };
$TOKEN{REQUIRED}         = sub { my $stream = shift; return $stream->matchString(@_, '#REQUIRED') };
$TOKEN{IMPLIED}          = sub { my $stream = shift; return $stream->matchString(@_, '#IMPLIED') };
$TOKEN{FIXED}            = sub { my $stream = shift; return $stream->matchString(@_, '#FIXED') };
$TOKEN{SECT_BEG}         = sub { my $stream = shift; return $stream->matchString(@_, '<![') };
$TOKEN{INCLUDE}          = sub { my $stream = shift; return $stream->matchString(@_, 'INCLUDE') };
$TOKEN{SECT_END}         = sub { my $stream = shift; return $stream->matchString(@_, ']]>') };
$TOKEN{IGNORE}           = sub { my $stream = shift; return $stream->matchString(@_, 'IGNORE') };
$TOKEN{EDECL_BEG}        = sub { my $stream = shift; return $stream->matchString(@_, '<!ENTITY') };
$TOKEN{SYSTEM}           = sub { my $stream = shift; return $stream->matchString(@_, 'SYSTEM') };
$TOKEN{PUBLIC}           = sub { my $stream = shift; return $stream->matchString(@_, 'PUBLIC') };
$TOKEN{NDATA}            = sub { my $stream = shift; return $stream->matchString(@_, 'NDATA') };
$TOKEN{ENCODING}         = sub { my $stream = shift; return $stream->matchString(@_, 'encoding') };
$TOKEN{NOTATION_BEG}     = sub { my $stream = shift; return $stream->matchString(@_, '<!NOTATION') };

1;
__DATA__
inaccessible is ok by default

:start ::=      # TO BE FILLED DYNAMICALLY
:default ::= action => [values] bless => ::lhs
lexeme default = action => [start,length,value] forgiving => 1

#
# We want to pause at the very beginning
#
document      ::= prolog element MiscAny
Char          ::= CHAR
Name          ::= NAME
Names         ::= Name+ separator => x20
Nmtoken       ::= NMTOKEN
Nmtokens      ::= Nmtoken+ separator => x20
EntityValue   ::= ENTITYVALUE
AttValue      ::= ATTVALUE
SystemLiteral ::= SYSTEMLITERAL
PubidLiteral  ::= PUBIDLITERAL
CharData      ::= CHARDATA
Comment       ::= CommentBeg CommentInterior CommentEnd
PITarget      ::= PITARGET
PI            ::= PiBeg PITarget               PiEnd
                | PiBeg PITarget WhiteSpace PiInterior PiEnd
CDSect        ::= CDStart CData CDEnd
CDStart       ::= CDSTART
CData         ::= CDATA
CDEnd         ::= CDEND
prolog        ::= XMLDeclMaybe MiscAny
                | XMLDeclMaybe MiscAny doctypedecl MiscAny
XMLDecl       ::= XmlBeg VersionInfo EncodingDeclMaybe SDDeclMaybe SMaybe XmlEnd
VersionInfo   ::= WhiteSpace Version Eq Squote VersionNum Squote
                | WhiteSpace Version Eq Dquote VersionNum Dquote
Eq            ::= SMaybe Equal SMaybe
VersionNum    ::= VERSIONNUM
Misc          ::= Comment
                | PI
                | WhiteSpace
doctypedecl   ::= DoctypeBeg WhiteSpace Name SMaybe                                     DoctypeEnd
                | DoctypeBeg WhiteSpace Name SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd
                | DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe                                     DoctypeEnd
                | DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd
DeclSep       ::= PEReference
                | WhiteSpace
intSubset     ::= intSubsetUnitAny
markupdecl    ::= elementdecl
                | AttlistDecl
                | EntityDecl
                | NotationDecl
                | PI
                | Comment
extSubset     ::=          extSubsetDecl
                | TextDecl extSubsetDecl
extSubsetDecl ::= extSubsetDeclUnitAny
SDDecl        ::= WhiteSpace Standalone Eq Squote Yes Squote
                | WhiteSpace Standalone Eq Squote No  Squote
                | WhiteSpace Standalone Eq Dquote Yes Dquote
                | WhiteSpace Standalone Eq Dquote No  Dquote
element       ::= EmptyElemTag
                | STag content ETag
STag          ::= STagBeg Name STagInteriorAny SMaybe STagEnd
Attribute     ::= Name Eq AttValue
ETag          ::= ETagBeg Name SMaybe ETagEnd
content       ::= CharDataMaybe ContentInteriorAny
EmptyElemTag  ::= EmptyElemTagBeg Name EmptyElemTagInteriorAny SMaybe EmptyElemTagEnd
elementdecl   ::= ElementDeclBeg WhiteSpace Name WhiteSpace contentspec SMaybe ElementDeclEnd
contentspec   ::= Empty
                | Any
                | Mixed
                | children
children      ::= choice QuantifierMaybe
                | seq QuantifierMaybe
cp            ::= Name QuantifierMaybe
                | choice QuantifierMaybe
                | seq QuantifierMaybe
choice        ::= Lparen SMaybe cp ChoiceInteriorMany SMaybe Rparen
seq           ::= Lparen SMaybe cp SeqInteriorAny SMaybe Rparen
Mixed         ::= Lparen SMaybe Pcdata MixedInteriorAny SMaybe RparenStar
                | Lparen SMaybe Pcdata SMaybe Rparen
AttlistDecl   ::= AttlistBeg WhiteSpace Name AttDefAny SMaybe AttlistEnd
AttDef        ::= WhiteSpace Name WhiteSpace AttType WhiteSpace DefaultDecl
AttType       ::= StringType
                | TokenizedType
                | EnumeratedType
StringType    ::= STRINGTYPE
TokenizedType ::= TypeId
                | TypeIdref
                | TypeIdrefs
                | TypeEntity
                | TypeEntities
                | TypeNmtoken
                | TypeNmtokens
EnumeratedType ::= NotationType
                | Enumeration
NotationType  ::= Notation WhiteSpace Lparen SMaybe Name NotationTypeInteriorAny SMaybe Rparen
Enumeration   ::= Lparen SMaybe Nmtoken EnumerationInteriorAny SMaybe Rparen
DefaultDecl   ::= Required
                | Implied
                |         AttValue
                | Fixed WhiteSpace AttValue
conditionalSect ::= includeSect
                  | ignoreSect
includeSect   ::= SectBeg SMaybe Include SMaybe Lbracket extSubsetDecl SectEnd
ignoreSect    ::= SectBeg SMaybe TOKIgnore SMaybe Lbracket ignoreSectContentsAny SectEnd
ignoreSectContents ::= Ignore ignoreSectContentsInteriorAny
Ignore        ::=  IGNORE_INTERIOR
CharRef       ::= CHARREF
Reference     ::= EntityRef
                | CharRef
EntityRef     ::= ENTITYREF
PEReference   ::= PEREFERENCE
EntityDecl    ::= GEDecl
                | PEDecl
GEDecl	      ::= EdeclBeg WhiteSpace Name WhiteSpace EntityDef SMaybe EdeclEnd
PEDecl        ::= EdeclBeg WhiteSpace Percent WhiteSpace Name WhiteSpace PEDef SMaybe EdeclEnd
EntityDef     ::= EntityValue
                | ExternalID
                | ExternalID NDataDecl
PEDef         ::= EntityValue
                | ExternalID
ExternalID    ::= System WhiteSpace SystemLiteral
                | Public WhiteSpace PubidLiteral WhiteSpace SystemLiteral
NDataDecl     ::= WhiteSpace Ndata WhiteSpace Name
TextDecl      ::= XmlBeg VersionInfoMaybe EncodingDecl SMaybe XmlEnd
extParsedEnt  ::=          content
                | TextDecl content
EncodingDecl  ::= WhiteSpace Encoding Eq Dquote EncName Dquote
                | WhiteSpace Encoding Eq Squote EncName Squote
EncName       ::= ENCNAME
NotationDecl  ::= NotationBeg WhiteSpace Name WhiteSpace ExternalID SMaybe NotationEnd
                | NotationBeg WhiteSpace Name WhiteSpace PublicID   SMaybe NotationEnd
PublicID      ::= PUBLIC WhiteSpace PubidLiteral
#
# G1 helpers
#
x20      ::= X20
XMLDeclMaybe ::= XMLDecl
XMLDeclMaybe ::=
MiscAny ::= Misc*
EncodingDeclMaybe ::= EncodingDecl
EncodingDeclMaybe ::=
SDDeclMaybe ::= SDDecl
SDDeclMaybe ::=
SMaybe ::= WhiteSpace
SMaybe ::=
ContentInterior ::= element CharDataMaybe
                   | Reference CharDataMaybe
                   | CDSect CharDataMaybe
                   | PI CharDataMaybe
                   | Comment CharDataMaybe
ContentInteriorAny ::= ContentInterior*
intSubsetUnit ::= markupdecl
                  | DeclSep
intSubsetUnitAny ::= intSubsetUnit*
extSubsetDeclUnit ::= markupdecl
                     | conditionalSect
                     | DeclSep
extSubsetDeclUnitAny ::= extSubsetDeclUnit*
STagInterior ::= WhiteSpace Attribute
STagInteriorAny ::= STagInterior*
CharDataMaybe ::= CharData
CharDataMaybe ::=
EmptyElemTagInterior ::= WhiteSpace Attribute
EmptyElemTagInteriorAny ::= EmptyElemTagInterior*
Quantifier ::= QuestionMark
             | Star
             | Plus
QuantifierMaybe ::= Quantifier
QuantifierMaybe ::=
ChoiceInterior ::= SMaybe Pipe SMaybe cp
ChoiceInteriorMany ::= ChoiceInterior+
SeqInterior ::= SMaybe Comma SMaybe cp
SeqInteriorAny ::= SeqInterior*
MixedInterior ::= SMaybe Pipe SMaybe Name
MixedInteriorAny ::= MixedInterior*
AttDefAny ::= AttDef*
NotationTypeInterior ::= SMaybe Pipe SMaybe Name
NotationTypeInteriorAny ::= NotationTypeInterior*
EnumerationInterior ::= SMaybe Pipe SMaybe Nmtoken
EnumerationInteriorAny ::= EnumerationInterior*
ignoreSectContentsAny ::= ignoreSectContents*
ignoreSectContentsInterior ::= SectBeg ignoreSectContents SectEnd Ignore
ignoreSectContentsInteriorAny ::= ignoreSectContentsInterior*
VersionInfoMaybe ::= VersionInfo
VersionInfoMaybe ::=
WhiteSpace ::= S
CommentBeg ::= COMMENT_BEG
CommentEnd ::= COMMENT_END
CommentInterior ::= COMMENT
PiInterior ::= PI_INTERIOR
XmlBeg ::= XML_BEG
XmlEnd ::= XML_END
Version ::= VERSION
Squote ::= SQUOTE
Dquote ::= DQUOTE
Equal ::= EQUAL
DoctypeBeg ::= DOCTYPE_BEG
DoctypeEnd ::= XTagEnd
Lbracket ::= LBRACKET
Rbracket ::= RBRACKET
Standalone ::= STANDALONE
Yes ::= YES
No ::= NO
XTagBeg ::= XTAG_BEG
STagBeg ::= XTagBeg
XTagEnd ::= XTAG_END
STagEnd ::= XTagEnd
ETagBeg ::= ETAG_BEG
ETagEnd ::= XTagEnd
EmptyElemTagBeg ::= XTagBeg
EmptyElemTagEnd ::= EMPTYELEMTAG_END
ElementDeclBeg ::= ELEMENTDECL_BEG
ElementDeclEnd ::= XTagEnd
Empty ::= EMPTY
Any ::= ANY
QuestionMark ::= QUESTION_MARK
Star ::= STAR
Plus ::= PLUS
Lparen ::= LPAREN
Rparen ::= RPAREN
RparenStar ::= RPARENSTAR
Pipe ::= PIPE
Comma ::= COMMA
AttlistBeg ::= ATTLIST_BEG
AttlistEnd ::= XTagEnd
TypeId ::= TYPE_ID
TypeIdref ::= TYPE_IDREF
TypeIdrefs ::= TYPE_IDREFS
TypeEntity ::= TYPE_ENTITY
TypeEntities ::= TYPE_ENTITIES
TypeNmtoken ::= TYPE_NMTOKEN
TypeNmtokens ::= TYPE_NMTOKENS
Notation ::= NOTATION
NotationBeg ::= NOTATION_BEG
NotationEnd ::= XTagEnd
Required ::= REQUIRED
Implied ::= IMPLIED
Fixed ::= FIXED
SectBeg ::= SECT_BEG
SectEnd ::= SECT_END
Include ::= INCLUDE
EdeclBeg ::= EDECL_BEG
EdeclEnd ::= XTagEnd
Percent ::= PERCENT
System ::= SYSTEM
Public ::= PUBLIC
Ndata ::= NDATA
Encoding ::= ENCODING
TOKIgnore ::= IGNORE
Pcdata ::= PCDATA
PiBeg ::= PI_BEG
PiEnd ::= PI_END
#
# Lexemes: they are all dummy, this is taken care in userspace
# ------------------------------------------------------------
_DUMMY           ~ [^\s\S]
X20              ~ _DUMMY
S                ~ _DUMMY
NAME             ~ _DUMMY
CHAR             ~ _DUMMY
NMTOKEN          ~ _DUMMY
SYSTEMLITERAL    ~ _DUMMY
PUBIDLITERAL     ~ _DUMMY
CHARDATA         ~ _DUMMY
CDATA            ~ _DUMMY
COMMENT_BEG      ~ _DUMMY
COMMENT_END      ~ _DUMMY
COMMENT          ~ _DUMMY
PI_BEG           ~ _DUMMY
PI_END           ~ _DUMMY
PITARGET         ~ _DUMMY
PI_INTERIOR      ~ _DUMMY
CDSTART          ~ _DUMMY
CDEND            ~ _DUMMY
XML_BEG          ~ _DUMMY
XML_END          ~ _DUMMY
VERSION          ~ _DUMMY
DQUOTE           ~ _DUMMY
SQUOTE           ~ _DUMMY
EQUAL            ~ _DUMMY
VERSIONNUM       ~ _DUMMY
DOCTYPE_BEG      ~ _DUMMY
LBRACKET         ~ _DUMMY
RBRACKET         ~ _DUMMY
STANDALONE       ~ _DUMMY
YES              ~ _DUMMY
NO               ~ _DUMMY
XTAG_BEG         ~ _DUMMY
XTAG_END         ~ _DUMMY
ETAG_BEG         ~ _DUMMY
EMPTYELEMTAG_END ~ _DUMMY
ELEMENTDECL_BEG  ~ _DUMMY
EMPTY            ~ _DUMMY
ANY              ~ _DUMMY
QUESTION_MARK    ~ _DUMMY
STAR             ~ _DUMMY
PLUS             ~ _DUMMY
LPAREN           ~ _DUMMY
RPAREN           ~ _DUMMY
PIPE             ~ _DUMMY
COMMA            ~ _DUMMY
RPARENSTAR       ~ _DUMMY
PCDATA           ~ _DUMMY
ATTLIST_BEG      ~ _DUMMY
STRINGTYPE       ~ _DUMMY
TYPE_ID          ~ _DUMMY
TYPE_IDREF       ~ _DUMMY
TYPE_IDREFS      ~ _DUMMY
TYPE_ENTITY      ~ _DUMMY
TYPE_ENTITIES    ~ _DUMMY
TYPE_NMTOKEN     ~ _DUMMY
TYPE_NMTOKENS    ~ _DUMMY
NOTATION         ~ _DUMMY
REQUIRED         ~ _DUMMY
IMPLIED          ~ _DUMMY
FIXED            ~ _DUMMY
SECT_BEG         ~ _DUMMY
INCLUDE          ~ _DUMMY
SECT_END         ~ _DUMMY
IGNORE           ~ _DUMMY
IGNORE_INTERIOR  ~ _DUMMY
CHARREF          ~ _DUMMY
ENTITYREF        ~ _DUMMY
PEREFERENCE      ~ _DUMMY
EDECL_BEG        ~ _DUMMY
PERCENT          ~ _DUMMY
SYSTEM           ~ _DUMMY
PUBLIC           ~ _DUMMY
NDATA            ~ _DUMMY
ENCODING         ~ _DUMMY
ENCNAME          ~ _DUMMY
NOTATION_BEG     ~ _DUMMY
ATTVALUE         ~ _DUMMY
ENTITYVALUE      ~ _DUMMY
#
# G0 events
# ---------
event X20              = predicted x20
event S                = predicted WhiteSpace
event NAME             = predicted Name
event CHAR             = predicted Char
event NMTOKEN          = predicted Nmtoken
event SYSTEMLITERAL    = predicted SystemLiteral
event PUBIDLITERAL     = predicted PubidLiteral
event CHARDATA         = predicted CharData
event CDATA            = predicted CData
event COMMENT_BEG      = predicted CommentBeg
event COMMENT_END      = predicted CommentEnd
event COMMENT          = predicted CommentInterior
event PI_BEG           = predicted PiBeg
event PI_END           = predicted PiEnd
event PITARGET         = predicted PITarget
event PI_INTERIOR      = predicted PiInterior
event CDSTART          = predicted CDStart
event CDEND            = predicted CDEnd
event XML_BEG          = predicted XmlBeg
event XML_END          = predicted XmlEnd
event VERSION          = predicted Version
event DQUOTE           = predicted Dquote
event SQUOTE           = predicted Squote
event EQUAL            = predicted Equal
event VERSIONNUM       = predicted VersionNum
event DOCTYPE_BEG      = predicted DoctypeBeg
event LBRACKET         = predicted Lbracket
event RBRACKET         = predicted Rbracket
event STANDALONE       = predicted Standalone
event YES              = predicted Yes
event NO               = predicted No
event XTAG_BEG         = predicted XTagBeg
event XTAG_END         = predicted XTagEnd
event ETAG_BEG         = predicted ETagBeg
event EMPTYELEMTAG_END = predicted EmptyElemTagEnd
event ELEMENTDECL_BEG  = predicted ElementDeclBeg
event EMPTY            = predicted Empty
event ANY              = predicted Any
event QUESTION_MARK    = predicted QuestionMark
event STAR             = predicted Star
event PLUS             = predicted Plus
event LPAREN           = predicted Lparen
event RPAREN           = predicted Rparen
event PIPE             = predicted Pipe
event COMMA            = predicted Comma
event RPARENSTAR       = predicted RparenStar
event PCDATA           = predicted Pcdata
event ATTLIST_BEG      = predicted AttlistBeg
event STRINGTYPE       = predicted StringType
event TYPE_ID          = predicted TypeId
event TYPE_IDREF       = predicted TypeIdref
event TYPE_IDREFS      = predicted TypeIdrefs
event TYPE_ENTITY      = predicted TypeEntity
event TYPE_ENTITIES    = predicted TypeEntities
event TYPE_NMTOKEN     = predicted TypeNmtoken
event TYPE_NMTOKENS    = predicted TypeNmtokens
event NOTATION         = predicted Notation
event REQUIRED         = predicted Required
event IMPLIED          = predicted Implied
event FIXED            = predicted Fixed
event SECT_BEG         = predicted SectBeg
event INCLUDE          = predicted Include
event SECT_END         = predicted SectEnd
event IGNORE           = predicted TOKIgnore
event IGNORE_INTERIOR  = predicted Ignore
event CHARREF          = predicted CharRef
event ENTITYREF        = predicted EntityRef
event PEREFERENCE      = predicted PEReference
event EDECL_BEG        = predicted EdeclBeg
event PERCENT          = predicted Percent
event SYSTEM           = predicted System
event PUBLIC           = predicted Public
event NDATA            = predicted Ndata
event ENCODING         = predicted Encoding
event ENCNAME          = predicted EncName
event NOTATION_BEG     = predicted NotationBeg
event ATTVALUE         = predicted AttValue
event ENTITYVALUE      = predicted EntityValue
