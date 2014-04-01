use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0;
use MarpaX::Languages::XML::AST::StreamIn;
use MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util qw/%TOKEN/;
use MarpaX::Languages::XML::AST::Util qw/:all/;
use Carp qw/croak/;
use Marpa::R2 2.082000;
use Log::Any qw/$log/;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) written in Marpa BNF

# VERSION

#
# Note: unfortunately, you can try all ways you want, doing:
#
# $REG = qr//;
# ./..
# $x =~ m/$REG/g;
#
# will always call CORE::match and CORE::regcomp
#
# The better I could get was with m/$REG/go, that reduces CORE::regcomp to its minimum but NOT the calls to it.
#
# So the fastest is the good old one:
#
# $x =~ m/explicitregexpwithNOinterpolation/g;
#
#
our $DATA = do {local $/; <DATA>};

# ---------------------------------------------------------------
# Internal regexps. NOT used for CORE::regcomp optimisation.
# But kept here as a scratchpad.
# ---------------------------------------------------------------
# our $REG_NAMESTARTCHAR          = qr/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]/;
# $REG_NAMESTARTCHAR|[-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]
# our $REG_NAMECHAR_ZERO_OR_MORE  = qr/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/;
# our $REG_NAMECHAR_ONE_OR_MORE   = qr/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/;
# our $REG_PUBIDCHAR_NOT_DQUOTE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]/;
# our $REG_PUBIDCHAR_NOT_DQUOTE_ZERO_OR_MORE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/;
# our $REG_PUBIDCHAR_NOT_SQUOTE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]/;
# our $REG_PUBIDCHAR_NOT_SQUOTE_ZERO_OR_MORE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*/;
# our $REG_CHARCOMMENT            = qr/\G[\x{9}\x{A}\x{D}\x{20}-\x{2C}\x{2E}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]/;
# our $REG_CHAR                   = qr/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]/;
# our $REG_CHAR_ZERO_OR_MORE      = qr/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/;
# our $REG_S_ONE_OR_MORE          = qr/\G[\x{20}\x{9}\x{D}\x{A}]+/;
# our $REG_NOT_DQUOTE             = qr/\G[^"]/;
# our $REG_NOT_DQUOTE_ZERO_OR_MORE = qr/\G[^"]*/;
# our $REG_NOT_SQUOTE             = qr/\G[^']/;
# our $REG_NOT_SQUOTE_ZERO_OR_MORE = qr/\G[^']*/;
# our $REG_CHARDATA               = qr/\G[^<&]/;
# our $REG_CHARDATA_ZERO_OR_MORE  = qr/\G[^<&]*/;
# our $REG_DIGIT                  = qr/\G[0-9]/;
# our $REG_DIGIT_ONE_OR_MORE      = qr/\G[0-9]+/;
# our $REG_HEXDIGIT               = qr/\G[0-9a-fA-F]/;
# our $REG_HEXDIGIT_ONE_OR_MORE   = qr/\G[0-9a-fA-F]+/;
# our $REG_ALPHA                  = qr/\G[A-Za-z]/;
# our $REG_ENCNAME_REST_ZERO_OR_MORE = qr/\G[A-Za-z0-9._-]*/;
# our $REG_ATTVALUE_NOT_DQUOTE    = qr/\G[^<&"]/;
# our $REG_ATTVALUE_NOT_DQUOTE_ZERO_OR_MORE = qr/\G[^<&"]*/;
# our $REG_ATTVALUE_NOT_SQUOTE    = qr/\G[^<&']/;
# our $REG_ATTVALUE_NOT_SQUOTE_ZERO_OR_MORE = qr/\G[^<&']*/;
our $REG_ENTITYVALUE_NOT_DQUOTE = qr/\G[^%&"]/;
our $REG_ENTITYVALUE_NOT_SQUOTE = qr/\G[^%&']/;

our %STR = ();
$STR{X20}              = "\x{20}";
$STR{DQUOTE}           = '"';
$STR{SQUOTE}           = "'";
$STR{EQUAL}            = '=';
$STR{LBRACKET}         = '[';
$STR{RBRACKET}         = ']';
$STR{XTAG_BEG}         = '<';
$STR{XTAG_END}         = '>';
$STR{STAG_END}         = '>';
$STR{ETAG_END}         = '>';
$STR{QUESTION_MARK}    = '?';
$STR{STAR}             = '*';
$STR{PLUS}             = '+';
$STR{LPAREN}           = '(';
$STR{RPAREN}           = ')';
$STR{PIPE}             = '|';
$STR{COMMA}            = ',';
$STR{PERCENT}          = '%';
$STR{COMMENT_BEG}      = '<!--';
$STR{COMMENT_END}      = '-->';
$STR{PI_BEG}           = '<?';
$STR{PI_END}           = '?>';
$STR{CDSTART}          = '<![CDATA[';
$STR{CDEND}            = ']]>';
$STR{XML_BEG}          = '<?xml';
$STR{XML_END}          = '?>';
$STR{VERSION}          = 'version';
$STR{DOCTYPE_BEG}      = '<!DOCTYPE';
$STR{STANDALONE}       = 'standalone';
$STR{YES}              = 'yes';
$STR{NO}               = 'no';
$STR{ETAG_BEG}         = '</';
$STR{EMPTYELEMTAG_END} = '/>';
$STR{ELEMENTDECL_BEG}  = '<!ELEMENT';
$STR{EMPTY}            = 'EMPTY';
$STR{ANY}              = 'ANY';
$STR{RPARENSTAR}       = '(*';
$STR{PCDATA}           = '#PCDATA';
$STR{ATTLIST_BEG}      = '<!ATTLIST';
$STR{STRINGTYPE}       = 'CDATA';
$STR{TYPE_ID}          = 'ID';
$STR{TYPE_IDREF}       = 'IDREF';
$STR{TYPE_IDREFS}      = 'IDREFS';
$STR{TYPE_ENTITY}      = 'ENTITY';
$STR{TYPE_ENTITIES}    = 'ENTITIES';
$STR{TYPE_NMTOKEN}     = 'NMTOKEN';
$STR{TYPE_NMTOKENS}    = 'NMTOKENS';
$STR{NOTATION}         = 'NOTATION';
$STR{REQUIRED}         = '#REQUIRED';
$STR{IMPLIED}          = '#IMPLIED';
$STR{FIXED}            = '#FIXED';
$STR{SECT_BEG}         = '<![';
$STR{INCLUDE}          = 'INCLUDE';
$STR{SECT_END}         = ']]>';
$STR{IGNORE}           = 'IGNORE';
$STR{EDECL_BEG}        = '<!ENTITY';
$STR{SYSTEM}           = 'SYSTEM';
$STR{PUBLIC}           = 'PUBLIC';
$STR{NDATA}            = 'NDATA';
$STR{ENCODING}         = 'encoding';
$STR{NOTATION_BEG}     = '<!NOTATION';
#
# For optimization, we presplit %STR into its length and list of characters
#
our %STRLENGTH = ();
foreach (keys %STR) {
  $STRLENGTH{$_} = length($STR{$_});
}
#
# Keep track of recursion using STAG_END and ETAG_END lexemes
#
our %LEXEME_INC_LEVEL = (STAG_END => 1);
our %LEXEME_DEC_LEVEL = (ETAG_END => 1);
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

#
# Exhaustive list of terminals
#
our %TERMINALS = (
    X20              => 1,
    S                => 1,
    NAME             => 1,
    CHAR             => 1,
    NMTOKEN          => 1,
    SYSTEMLITERAL    => 1,
    PUBIDLITERAL     => 1,
    CHARDATA         => 1,
    CDATA            => 1,
    COMMENT_BEG      => 1,
    COMMENT_END      => 1,
    COMMENT          => 1,
    PI_BEG           => 1,
    PI_END           => 1,
    PITARGET         => 1,
    PI_INTERIOR      => 1,
    CDSTART          => 1,
    CDEND            => 1,
    XML_BEG          => 1,
    XML_END          => 1,
    VERSION          => 1,
    DQUOTE           => 1,
    SQUOTE           => 1,
    EQUAL            => 1,
    VERSIONNUM       => 1,
    DOCTYPE_BEG      => 1,
    LBRACKET         => 1,
    RBRACKET         => 1,
    STANDALONE       => 1,
    YES              => 1,
    NO               => 1,
    XTAG_BEG         => 1,
    XTAG_END         => 1,
    ETAG_BEG         => 1,
    EMPTYELEMTAG_END => 1,
    ELEMENTDECL_BEG  => 1,
    EMPTY            => 1,
    ANY              => 1,
    QUESTION_MARK    => 1,
    STAR             => 1,
    PLUS             => 1,
    LPAREN           => 1,
    RPAREN           => 1,
    PIPE             => 1,
    COMMA            => 1,
    RPARENSTAR       => 1,
    PCDATA           => 1,
    ATTLIST_BEG      => 1,
    STRINGTYPE       => 1,
    TYPE_ID          => 1,
    TYPE_IDREF       => 1,
    TYPE_IDREFS      => 1,
    TYPE_ENTITY      => 1,
    TYPE_ENTITIES    => 1,
    TYPE_NMTOKEN     => 1,
    TYPE_NMTOKENS    => 1,
    NOTATION         => 1,
    REQUIRED         => 1,
    IMPLIED          => 1,
    FIXED            => 1,
    SECT_BEG         => 1,
    INCLUDE          => 1,
    SECT_END         => 1,
    IGNORE           => 1,
    IGNORE_INTERIOR  => 1,
    CHARREF          => 1,
    ENTITYREF        => 1,
    PEREFERENCE      => 1,
    EDECL_BEG        => 1,
    PERCENT          => 1,
    SYSTEM           => 1,
    PUBLIC           => 1,
    NDATA            => 1,
    ENCODING         => 1,
    ENCNAME          => 1,
    NOTATION_BEG     => 1,
    ATTVALUE         => 1,
    ENTITYVALUE      => 1
    );

goto noinspection;
#
# We inspect the grammars to get the G1 tree. We made sure that any lexeme in the
# grammar is always a single RHS of an unique LHS, i.e. g1 ::= G0. So we can always
# identify when a lexeme is needed
#
our %GRAPH = ();
our %TERMINAL = ();
foreach (keys %G) {
    my $top = $_;
    print STDERR "Inspecting $_\n";
    my $g = $G{$top};
    $GRAPH{$top} = [];
    $TERMINAL{$top} = [];
    my $graph = $GRAPH{$top};
    my $terminal = $TERMINAL{$top};
    #
    # Get all G0 rules
    #
    my %G0 = ();
    foreach ($g->rule_ids('L0')) {
	my $rule_id = $_;
	my ($lhs_id, @rhs_ids) = $g->rule_expand($rule_id, 'L0');
	my $name = $g->symbol_name($lhs_id, 'L0');
	$G0{$name} = 1;
    }
    foreach ($g->rule_ids()) {
	my $rule_id = $_;
	my ($lhs_id, @rhs_ids) = $g->rule_expand($rule_id);
	$graph->[$lhs_id] //= [];
	push(@{$graph->[$lhs_id]}, [ @rhs_ids ]);
	if ($#rhs_ids == 0) {
	    my $name = $g->symbol_name($rhs_ids[0]);
	    if (exists($G0{$name}) && ! defined($terminal->[$lhs_id])) {
		$terminal->[$lhs_id] = $name;
		print STDERR "==> TERMINAL " . $g->symbol_name($lhs_id) . " ::= $name\n";
	    }
	}
    }
}
our %G2LEXEME = ();

sub _lhsid2lexemes {
    my ($g, $graph, $terminal, $lhs_id, $lexemesp, $is_nullablep) = @_;

    ${$is_nullablep} //= 0;

    if (defined($terminal->[$lhs_id])) {
	print STDERR "=== === " . "$lhs_id is terminal $terminal->[$lhs_id]\n";
	push(@{$lexemesp}, $terminal->[$lhs_id]);
    } else {
	foreach (@{$graph->[$lhs_id]}) {
	    my $rhs_ids = $_;
	    print STDERR "... ... " . $g->symbol_name($lhs_id) . ' ::= ' . join(' ', map {$g->symbol_name($_)} @{$rhs_ids}) . "\n";
	    if (! @{$rhs_ids}) {
		print STDERR "... ... " . $g->symbol_name($lhs_id) . " is nullable\n";
		${$is_nullablep} = 1;
		next;
	    } else {
		foreach (@{$rhs_ids}) {
		    my $rhs_id = $_;
		    my $is_nullable = 0;
		    _lhsid2lexemes($g, $graph, $terminal, $rhs_id, $lexemesp, \$is_nullable);
		    last if (! $is_nullable);
		}
	    }
	}
    }    
}

foreach (keys %G) {
    my $top = $_;
    print STDERR "Building G1 -> lexemes of $_\n";
    $G2LEXEME{$top} = [];
    my $g = $G{$top};
    my $graph = $GRAPH{$top};
    my $terminal = $TERMINAL{$top};
    my $g2lexeme = $G2LEXEME{$top};
    foreach (0..$#{$graph}) {
	my $lhs_id = $_;
	print "... " . $g->symbol_name($lhs_id) . "\n";
	$g2lexeme->[$lhs_id] = [];
	_lhsid2lexemes($g, $graph, $terminal, $lhs_id, $g2lexeme->[$lhs_id]);
    }
}

foreach (0..$#{$G2LEXEME{document}}) {
    my $lhs_id = $_;
    my @lexemes = @{$G2LEXEME{document}->[$lhs_id]};
    if (@lexemes) {
	print STDERR $G{document}->symbol_name($lhs_id) . " => @lexemes\n";
    }
}
#exit;
noinspection:
#
# We always work with a single buffer, and handle eventual overlap
# by appending to current buffer before discarding it
#
sub new {
  my ($class, %opts) = @_;

  my $self = {buf => undef, mapbeg => 0, origmapend => 0, mapend => 0, lastBufNo => 0};

  bless($self, $class);

  return $self;
}

sub _donePos {
    # my ($self, $stream, $pos) = @_;

    # $log->tracef('_donePos %d', $_[2]);

    if ($_[2] >= $_[0]->{origmapend}) {
	#
	# Current buffer, eventually appended with content of next
	# buffer(s), is over
	#
        my $mapend;
        while (defined($mapend = $_[1]->mapend(0))) {
          if ($_[2] >= $mapend) {
            $_[1]->doneb(0);
          } else {
            last;
          }
        }
	#
	# Assigning mapend to zero is enough for us
	# to know nothing else is cached
	#
	$_[0]->{buf} = undef;
	$_[0]->{mapbeg} = 0;
	$_[0]->{mapend} = 0;
	$_[0]->{origmapend} = 0;
	$_[0]->{lastBufNo} = 0;
    }
}

#
# For performance, everything is done one the stack
# This routine check AND position buffer
#
# _isPos is functionally equivalent to _canPos, but prevent an
# unnecessary call to pos(). _isPos() should be called ONLY after
# a successful m//g or after a _canPos.
#
sub _isPos {
    # my ($self, $stream, $pos) = @_;

    if ($_[2] < $_[0]->{mapend}) {
	#
	# Current buffer. pos($self->{buf}) ASSUMED to be already correctly positionned.
	#
	# $log->tracef('_isPos %d : internal pos %s : %s', $_[2], pos($_[0]->{buf}), substr($_[0]->{buf}, pos($_[0]->{buf})));
	return 1;
    } else {
	return $_[0]->_canPos($_[1], $_[2]);
    }
}

sub _canPos {
    # my ($self, $stream, $pos) = @_;

    if ($_[2] < $_[0]->{mapend}) {
	#
	# Current buffer
	#
	pos($_[0]->{buf}) = $_[2] - $_[0]->{mapbeg};
	# $log->tracef('_canPos %d : internal pos %s : %s', $_[2], pos($_[0]->{buf}), substr($_[0]->{buf}, pos($_[0]->{buf})));
	return 1;
    } else {
	if (! $_[0]->{mapend}) {
	    #
	    # No buffer
	    #
	    $_[0]->{buf} = $_[1]->fetchb(0);
	    if (! defined($_[0]->{buf})) {
		return undef;
	    } else {
		# $log->tracef('_canPos %d : fetched buffer 0: %s', $_[2], $_[0]->{buf});
		$_[0]->{mapbeg} = $_[1]->mapbeg(0);
		$_[0]->{mapend} = $_[1]->mapend(0);
		$_[0]->{origmapend} = $_[0]->{mapend};
		$_[0]->{lastBufNo} = 0;
		return $_[0]->_canPos($_[1], $_[2]);
	    }
	} else {
	    #
	    # Need to append. We take the next uncached buffer
	    #
	    my $nextBufNo = $_[0]->{lastBufNo} + 1;
	    # $log->tracef('_canPos %d : append buffer %d', $_[2], $nextBufNo);
	    my $append = $_[1]->fetchb($nextBufNo);
	    if (defined($append)) {
		$_[0]->{buf} .= $append;
		$_[0]->{mapend} = $_[1]->mapend($nextBufNo);
		$_[0]->{lastBufNo} = $nextBufNo;
		return $_[0]->_canPos($_[1], $_[2]);
	    } else {
		return undef;
	    }
	}
    }
}

sub _progressToKey {
    my ($self, $recce) = @_;

    my $key = '';

    my @key = ();
    foreach (@{$recce->progress()}) {
      push(@key, "$_->[0].$_->[1]");
    }
    $key = join('/', @key);

    return $key;
}

sub parse {
  my ($self, $input) = @_;

  #
  # Initiate recognizer
  # We will take care of all lexemes recognition and use token-stream model
  #
  my $recce = Marpa::R2::Scanless::R->new( { grammar => $G{document} } );
  my $fake_input = ' ';
  $recce->read(\$fake_input);
  #
  # We used a single event just to pause at the very beginning. We do not
  # need this event anymore.
  #
  $recce->activate('^document', 0);
  #
  # Current buffer
  #
  my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input);
  my $pos = 0;
  my $bigtrace = 100000;
  #
  # Loop until nothing left in the buffer
  #
  my %KEY2TERMINALS = ();
  my %KEY_TOKENS_TO_NEXTKEY = ();
  #
  # We instanciate $key manually
  #
  my $level = 0;
  my $key = $self->_progressToKey($recce, $level);

  while (1) {

    last if (! $self->_canPos($stream, $pos));

    my @tokens = ();
    my $value = '';
    my $maxTokenLength = 0;

    #
    # By definition we know we can pos() here. No need to call again _canPos()
    # for a predictable result at a predictable position.
    #
    my $internalPos = pos($self->{buf});

    #
    # Loop until error, or eof, or no more terminal expected
    #
    my @terminals = @{$KEY2TERMINALS{$key} //= $recce->terminals_expected()};
    #
    # In case of fixed strings, we make sure we tried to fetch as many characters
    # as possible, ordering with longests fixed strings first
    #
    my @STR = sort {$STRLENGTH{$b} <=> $STRLENGTH{$a}} grep {exists($STRLENGTH{$_})} @terminals;
    if (@STR) {
	#
	# Try to fetch unless longest length is 1 (already done upper)
	#
	if ($STRLENGTH{$STR[0]} > 1) {
	    # $log->tracef('pos=%6d : trying to fetch %d characters', $pos, $STRLENGTH{$STR[0]});
	    $self->_canPos($stream, $pos + $STRLENGTH{$STR[0]} - 1);
	}
	#
	# We re-write terminals if there is more than one string and there is a difference in length
	#
	if ($#STR > 0 && $STRLENGTH{$STR[0]} != $STRLENGTH{$STR[-1]}) {
	    my @NONSTR = grep {! exists($STRLENGTH{$_})} @terminals;
	    @terminals = ((grep {! exists($STRLENGTH{$_})} @terminals), @STR);
	}
    }

    foreach my $terminal (@{$KEY2TERMINALS{$key} //= $recce->terminals_expected()}) {
      my $workpos = $pos;

      pos($self->{buf}) = $internalPos;

      # $log->tracef('pos=%6d : trying %s, pos($self->{buf})=%s => %s', $pos, $terminal, pos($self->{buf}), substr($self->{buf}, pos($self->{buf}), 10) . "...");

      my $match = '';
      if ($terminal eq 'NAME' || $terminal eq 'PITARGET') {
        # ----------------------------------------------
        # NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
        #
        # PITARGET is NAME without /xml/i
        #
        # ----------------------------------------------
        if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/g) {
          $match = $&;
          if ($self->_isPos($stream, $workpos + $+[0] - $-[0])) {
	      while (1) {
		  #
		  # This regexp will always match...
		  #
		  $self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/g;
		  my $length = $+[0] - $-[0];
		  last if (! $length);
		  $match .= $&;
		  last if (! $self->_isPos($stream, ($workpos += $length)));
	      }
	  }
	}
        if ($terminal eq 'PITARGET' && length($match) > 0) {
          if ($match =~ /xml/i) {
            substr($match, $-[0]) = '';
          }
        }
      }
      elsif ($terminal eq 'ENCNAME') {
        # ----------------------------------------------
        # ENCNAME is /${REG_ALPHA}${REG_ENCNAME_REST}*/
        # ----------------------------------------------
        if ($self->{buf} =~ m/\G[A-Za-z]/g) {
          next if (! $self->_isPos($stream, ++$workpos));
          $match = $&;
	  my $length = 0;
          while (1) {
            last if (($length > 0) && ! $self->_isPos($stream, ($workpos += $length)));
            last if ($self->{buf} !~ m/\G[A-Za-z0-9._-]*/g);
            $length = $+[0] - $-[0];
            last if (! $length);
            $match .= $&;
          }
        }
      }
      elsif ($terminal eq 'CHARREF') {
	  # ---------------------------------
	  # CHARREF is /&#${REG_DIGIT}+;/
	  #         or /&#x${REG_HEXDIGIT}+;/
	  # ---------------------------------
	  if ($self->{buf} =~ m/\G&/g) {
	      next if (! $self->_isPos($stream, ++$workpos));
	      if ($self->{buf} =~ m/\G#/g) {
		  next if (! $self->_isPos($stream, ++$workpos));
		  if ($self->{buf} =~ m/\Gx/gc) {            # Note the /c modifier
		      next if (! $self->_isPos($stream, ++$workpos));
		      #
		      # We expect ${REG_HEXDIGIT}+ followed by ';'
		      #
		      my $submatch = '';
		      my $submatchok = 0;
		      while ($self->{buf} =~ m/\G[0-9a-fA-F]+/gc) {   # Note the /c modifier
			  $submatch .= $&;
			  $submatchok = 1;
			  last if (! $self->_isPos($stream, ($workpos += ($+[0] - $-[0]))));
		      }
		      if ($submatchok) {
			  if ($self->{buf} =~ m/\G;/g) {
			      $match = '&#x' . ${submatch} . ';';
			  }
		      }
		  } else {
		      #
		      # We expect ${REG_DIGIT}+ followed by ';'
		      #
		      my $submatch = '';
		      my $submatchok = 0;
		      while ($self->{buf} =~ m/\G[0-9]+/gc) {   # Note the /c modifier
			  $submatch .= $&;
			  $submatchok = 1;
			  last if (! $self->_isPos($stream, ($workpos += ($+[0] - $-[0]))));
		      }
		      if ($submatchok) {
			  if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
			      $match = '&#' . ${submatch} .';';
			  }
		      }
		  }
	      }
	  }
      }
      elsif ($terminal eq 'S') {
        #
        # S is /${REG_S}+/
        # ----------------
        while ($self->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+/g) {
          $match .= $&;
          last if (! $self->_isPos($stream, ($workpos += ($+[0] - $-[0]))));
        }
      }
      elsif ($terminal eq 'NMTOKEN') {
        #
        # S is /${REG_NAMECHAR}+/
        # -----------------------
        while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/g) {
          $match .= $&;
          last if (! $self->_isPos($stream, ($workpos += ($+[0] - $-[0]))));
        }
      }
      elsif ($terminal eq 'SYSTEMLITERAL') {
	  #
	  # SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
	  # ------------------------------------------------------------------
	  if ($self->{buf} =~ m/\G["']/g) {
	      $match = my $c = $&;
	      ++$workpos;
	      while (1) {
		  last if (! $self->_isPos($stream, $workpos));
		  $self->{buf} =~ m/\G[^"]*/g;              # Note this will always match
		  my $length = $+[0] - $-[0];
		  last if (! $length);
		  $match .= $&;
		  $workpos += $length;
	      }
	      #
	      # A little overhead if SYSTEMLITERAL is "" or '' - will rarelly happen
	      #
	      if ($self->_isPos($stream, $workpos)) {
		  if ($self->{buf} =~ m/\G["']/g && $& eq $c) {
		      $match .= $&;
		  } else {
		      $match = '';
		  }
	      } else {
		  $match = '';
	      }
	  }
      }
      elsif ($terminal eq 'PUDIDLITERAL') {
	  #
	  # PUDIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/
	  # ------------------------------------------------------------------------------------
	  if ($self->{buf} =~ m/\G["']/g) {
	      $match = my $c = $&;
	      ++$workpos;
	      my $lastok = 1;
	      while (1) {
		  if (! $self->_isPos($stream, $workpos)) {
		      $lastok = 0;
		      last;
		  }
		  $self->{buf} =~ m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/g;   # Note this will always match
		  my $length = $+[0] - $-[0];
		  last if (! $length);
		  $match .= $&;
		  $workpos += $length;
	      }
	      #
	      # A little overhead if PUDIDLITERAL is "" or '' - will rarelly happen
	      #
	      if ($lastok && $self->{buf} =~ m/\G["']/g && $& eq $c) {
		  $match .= $&;
	      } else {
		  $match = '';
	      }
	  }
      }
      elsif ($terminal eq 'CHARDATA') {
	  #
	  # CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
	  # ------------------------------------------------------------------
	  while ($self->{buf} =~ m/\G[^<&]*/g) {
	      my $length = $+[0] - $-[0];
	      last if (! $length);
	      $match .= $&;
	      last if (! $self->_isPos($stream, ($workpos += $length)));
	  }
	  if ($match =~ /\]\]>/i) {
	      substr($match, $-[0]) = '';
	  }
      }
      elsif ($terminal eq 'CDATA' || $terminal eq 'COMMENT' || $terminal eq 'PI_INTERIOR' || $terminal eq 'IGNORE_INTERIOR') {
        #
        # CDATA           is /${REG_CHAR}*/ minus the sequence ']]>'
        # COMMENT         is /${REG_CHAR}*/ minus the sequence '--'
        # PI_INTERIOR     is /${REG_CHAR}*/ minus the sequence '?>'
        # IGNORE_INTERIOR is /${REG_CHAR}*/ minus the sequence '<![' or ']]>'
        # ------------------------------------------------------------------
        while ($self->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/g) {
	    my $length = $+[0] - $-[0];
	    last if (! $length);
	    $match .= $&;
	    last if (! $self->_isPos($stream, ($workpos += $length)));
        }
	if (length($match) > 0) {
	    my @exclusionString =
		($terminal eq 'CDATA') ? (quotemeta(']]>'))
		:
		($terminal eq 'COMMENT') ? (quotemeta('--'))
		:
		($terminal eq 'PI_INTERIOR') ? (quotemeta('?>'))
		: (quotemeta('<!['), quotemeta(']]>'));
	    foreach (@exclusionString) {
		if ($match =~ /$_/i) {
		    substr($match, $-[0]) = '';
		}
	    }
	}
      }
      elsif ($terminal eq 'VERSIONNUM') {
	  #
	  # VERSIONNUM is /1.${REG_DIGIT}+/
	  # -------------------------------
	  if ($self->{buf} =~ m/\G1/g) {
	      next if (! $self->_isPos($stream, ++$workpos));
	      if ($self->{buf} =~ m/\G\./g) {
		  next if (! $self->_isPos($stream, ++$workpos));
		  while ($self->{buf} =~ m/\G[0-9]+/g) {
		      $match .= $&;
		      last if (! $self->_isPos($stream, ($workpos += ($+[0] - $-[0]))));
		  }
	      }
	  }
	  $match = '1.' . $match if (length($match) > 0);
      }
      elsif ($terminal eq 'ATTVALUE') {
	  #
	  # ATTVALUE is /"(${REG_ATTVALUE_NOT_DQUOTE}|Reference)*"/
	  #          or /'(${REG_ATTVALUE_NOT_SQUOTE}|Reference)*'/
	  #
	  # where Reference is: EntityRef | CharRef
	  #
	  # and EntityRef   is /&${NAME};/
	  #     CharRef     is /&#${REG_DIGIT}+;/ or /&#x${REG_HEXDIGIT}+;/
	  # ------------------------------------------------------
	  if ($self->{buf} =~ m/\G["']/g) {
	      $match = my $c = $&;
	      ++$workpos;
	      my $dquoteMode = ($c eq '"');
	      my $lastok = 1;
	      while (1) {
		  my $length;
		  if (! $self->_isPos($stream, $workpos)) {
		      $lastok = 0;
		      last;
		  }
		  if (
		      (
		       (  $dquoteMode && $self->{buf} =~ m/\G[^<&"]*/gc) ||
		       (! $dquoteMode && $self->{buf} =~ m/\G[^<&']*/gc)
		      )
		      && ($length = $+[0] - $-[0]) > 0) {  # Note the /c modifiers
		      $match .= $&;
		      $workpos += $length;
		  } elsif ($self->{buf} =~ m/\G&/gc) {     # Note the /c modifier
		      my $subworkpos = $workpos;
		      last if (! $self->_isPos($stream, ++$subworkpos));
		      if ($self->{buf} =~ m/\G#/gc) {
			  last if (! $self->_isPos($stream, ++$subworkpos));
			  if ($self->{buf} =~ m/\Gx/gc) {          # Note the /c modifier
			      #
			      # We expect ${REG_HEXDIGIT}+ followed by ';'
			      #
			      my $submatch = '';
			      ++$subworkpos;
			      my $sublastok = 1;
			      while (1) {
				  if (! $self->_isPos($stream, $subworkpos)) {
				      $sublastok = 0;
				      last;
				  }
				  last if ($self->{buf} !~ m/\G[0-9a-fA-F]+/gc);   # Note the /c modifier
				  $submatch .= $&;
				  $subworkpos += $+[0] - $-[0];
			      }
			      if ($sublastok && length($submatch) > 0) {
				  if ($self->{buf} =~ m/\G;/gc) {
				      $match .= '&#x' . ${submatch} . ';';
				      $workpos = 4 + length($submatch);
				  } else {
				      last;
				  }
			      } else {
				  last;
			      }
			  } else {
			      #
			      # We expect ${REG_DIGIT}+ followed by ';'
			      #
			      my $submatch = '';
			      ++$subworkpos;
			      my $sublastok = 1;
			      while (1) {
				  if (! $self->_isPos($stream, $subworkpos)) {
				      $sublastok = 0;
				      last;
				  }
				  last if ($self->{buf} !~ m/\G[0-9]+/gc);   # Note the /c modifier
				  $submatch .= $&;
				  $subworkpos += $+[0] - $-[0];
			      }
			      if ($sublastok && length($submatch) > 0) {
				  if ($self->{buf} =~ m/\G;/gc) {
				      $match .= '&#' . ${submatch} . ';';
				      $workpos = 4 + length($submatch);
				  } else {
				      last;
				  }
			      } else {
				  last;
			      }
			  }
		      } else {
			  #
			  # We expect ${NAME}  followed by ';'
			  #
			  if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]/gc) {
			      my $submatch = $&;
			      ++$subworkpos;
			      my $sublastok = 1;
			      while (1) {
				  if (! $self->_isPos($stream, $subworkpos)) {
				      $sublastok = 0;
				      last;
				  }
				  last if ($self->{buf} !~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/gc);   # Note the /c modifier
				  $submatch .= $&;
				  $subworkpos += $+[0] - $-[0];
			      }
			      if ($sublastok && $self->{buf} =~ m/\G;/gc) {
				  $match .= '&' . ${submatch} . ';';
				  $workpos += 2 + length($submatch);
			      } else {
				  last;
			      }
			  } else {
			      last;
			  }
		      }
		  } else {
		      last;
		  }
	      }
	      #
	      # A little overhead if ATTVALUE is "" or '' - will rarelly happen
	      #
	      if ($lastok && $self->{buf} =~ m/\G["']/g && $& eq $c) {
		  $match .= $&;
	      } else {
		  $match = '';
	      }
	  }
      }
      elsif ($terminal eq 'ENTITYREF' || $terminal eq 'PEREFERENCE') {
	  #
	  # ENTITYREF   is /&${NAME};/
	  # PEREFERENCE is /%${NAME};/
	  # -------------------------------
	  if ($self->{buf} =~ m/\G[&%]/g) {
	      next if (! $self->_isPos($stream, ++$workpos));
	      my $c = $&;
	      #
	      # We expect ${NAME}  followed by ';'
	      #
	      if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]/g) {
		  my $submatch = $&;
		  my $sublastok = 1;
		  my $subworkpos = $workpos + 1;
		  while (1) {
		      if (! $self->_isPos($stream, $subworkpos)) {
			  $sublastok = 0;
			  last;
		      }
		      last if ($self->{buf} !~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/gc);   # Note the /c modifier
		      $submatch .= $&;
		      $subworkpos += $+[0] - $-[0];
		  }
		  if ($sublastok && $self->{buf} =~ m/\G;/g) {
		      $match .= $c . ${submatch} . ';';
		      $workpos += 2 + length($submatch);
		  }
              }
	  }
      }
      elsif (exists($STR{$terminal})) {
	  #
	  # Note we already did a _canPos that fits as maximum as possible.
	  #
	  if (substr($self->{buf}, pos($self->{buf}), $STRLENGTH{$terminal}) eq $STR{$terminal}) {
	      $match = $STR{$terminal};
	  }
      }

      my $tokenLength = length($match);
      if ($tokenLength > 0) {
	  if ($tokenLength > $maxTokenLength) {
	      # $log->tracef('pos=%6d : Replacing %s by %s', $pos, \@tokens, $terminal) if (@tokens);
	      @tokens = ($terminal);
	      $value = $match;
	      $maxTokenLength = $tokenLength;
	  } elsif ($tokenLength == $maxTokenLength) {
	      push(@tokens, $terminal);
	  }
      }
    }
    if (@tokens) {
	foreach (@tokens) {
	    #
	    # The array is a reference to [$name, $value], where value can be undef
	    #
            # $log->tracef('pos=%6d : lexeme_alternative("%s", "%s")', $pos, $_, $value);
	    # printf "pos=%6d : lexeme_alternative(\"%s\", \"%s\")\n", $pos, $_, $value;
	    # $recce->lexeme_alternative($_, $value);
	    $recce->lexeme_alternative($_);
            if (exists($LEXEME_INC_LEVEL{$_})) {
              ++$level;
              # $log->tracef('pos=%6d : level inc to %d', $pos, $level);
            } elsif (exists($LEXEME_DEC_LEVEL{$_})) {
              --$level;
              # $log->tracef('pos=%6d : level dec to %d', $pos, $level);
            }
	}
	$recce->lexeme_complete(0, 1);
	# $log->tracef('pos=%6d : +=%d, value=%s', $pos, $maxTokenLength, $value);
	$pos += $maxTokenLength;

        my $tokens = $#tokens ? join('/', sort @tokens) : $tokens[0];
	$key = ($KEY_TOKENS_TO_NEXTKEY{"[$level]$key"}->{$tokens} //= $self->_progressToKey($recce));
    } else {
	#
	# Acceptable only if there are discardable characters
	#
	$self->_canPos($stream, $pos);
	if ($self->{buf} =~ m/\G\s+/g) {
	    $log->tracef('pos=%6d : discarding %d characters', $pos, $+[0] - $-[0]);
	    $pos += $+[0] - $-[0];
	} else {
	    $log->tracef('pos=%6d : no token nor discardable character', $pos);
	    last;
	}
    }

    if ($pos >= $bigtrace) {
	$log->tracef('pos=%6d', $pos);
	$bigtrace += 100000;
        # last if ($bigtrace >= 600000);
    }

    $self->_donePos($stream, $pos);
  }
  my $nvalue = 0;
  while (defined($_ = $recce->value)) {
      ++$nvalue;
      #$log->tracef('Value %d: %s', $nvalue, $_);
  }
  $log->tracef('Total number of values: %d', $nvalue);
  if (! $nvalue) {
      print "EXPECTED: @{$recce->terminals_expected()}\n";
      print  "LATEST PROGRESS:\n";
      print $recce->show_progress();
  }
}

1;
__DATA__
inaccessible is ok by default

:start ::=      # TO BE FILLED DYNAMICALLY
:default ::= action => [values] bless => ::lhs
lexeme default = action => [start,length,value] forgiving => 1

#
# We want to pause at the very beginning
#
event '^document' = predicted <document>
document      ::= prolog element MiscAny
Char          ::= CHAR
Name          ::= NAME
Names         ::= Name
                | x20 Names
Nmtoken       ::= NMTOKEN
Nmtokens      ::= Nmtoken
                | x20 Nmtokens
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
PublicID      ::= Public WhiteSpace PubidLiteral
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
STagEnd ::= STAG_END
ETagBeg ::= ETAG_BEG
ETagEnd ::= ETAG_END
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
STAG_END         ~ _DUMMY
ETAG_END         ~ _DUMMY
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
