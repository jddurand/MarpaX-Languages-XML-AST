use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) util methods

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/%MATCH %STR %STRLENGTH/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

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

# -------------------------------------------------------------------------------------------------------------
# About regexp, unfortunately, you can try all ways you want, doing:
#
# $REG = qr//;
# ./..
# $x =~ m/$REG/g;
#
# this will always call CORE::match AND CORE::regcomp
# The better I could get was with m/$REG/go, that reduces CORE::regcomp to its minimum but NOT the calls to it.
# So the fastest is the good old one:
#
# $x =~ m/explicitregexpwithNOinterpolation/g;
#
# Note that every $MATCH{} routine is guaranteed to have already correctly positionned $self->{buf}
# to the next character if it is successful
# -------------------------------------------------------------------------------------------------------------

our %MATCH = ();
$MATCH{NAME} = sub {
    my ($self, $stream, $pos) = @_;
    # ----------------------------------------------
    # NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
    # ----------------------------------------------
    my $match = '';
    if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]/gc) {
	$match = $&;
	if ($self->_isPos($stream, $pos += ($+[0] - $-[0]))) {
	    while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) {
		$match .= $&;
		last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	    }
	}
    }
    return $match;
};

$MATCH{PITARGET} = sub {
    my ($self, $stream, $pos) = @_;
    # -----------------------------------------------------------------
    # PITARGET is NAME without /xml/i
    # -----------------------------------------------------------------
    my $match = $MATCH{NAME}(@_);
    if ($match =~ /xml/i) {
	substr($match, $-[0]) = '';
    }
    return $match;
};

$MATCH{ENCNAME} = sub {
    my ($self, $stream, $pos) = @_;
    # ----------------------------------------------
    # ENCNAME is /${REG_ALPHA}${REG_ENCNAME_REST}*/
    # ----------------------------------------------
    my $match = '';
    if ($self->{buf} =~ m/\G[A-Za-z]/gc) {
	next if (! $self->_isPos($stream, ++$pos));
	$match = $&;
	while ($self->{buf} =~ m/\G[A-Za-z0-9._-]+/gc) {
	    $match .= $&;
	    last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	}
    }
    return $match;
};

$MATCH{CHARREF} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # ---------------------------------
    # CHARREF is /&#${REG_DIGIT}+;/
    #         or /&#x${REG_HEXDIGIT}+;/
    # ---------------------------------
    if ($self->{buf} =~ m/\G&/gc) {
	next if (! $self->_isPos($stream, ++$pos));
	if ($self->{buf} =~ m/\G#/gc) {
	    next if (! $self->_isPos($stream, ++$pos));
	    if ($self->{buf} =~ m/\Gx/gc) {            # Note the /c modifier
		next if (! $self->_isPos($stream, ++$pos));
		#
		# We expect ${REG_HEXDIGIT}+ followed by ';'
		#
		my $submatch = '';
		my $submatchok = 0;
		while ($self->{buf} =~ m/\G[0-9a-fA-F]+/gc) {   # Note the /c modifier
		    $submatch .= $&;
		    $submatchok = 1;
		    last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
		}
		if ($submatchok) {
		    if ($self->{buf} =~ m/\G;/gc) {
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
		    last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
		}
		if ($submatchok) {
		    if ($self->{buf} =~ m/\G;/gc) {
			$match = '&#' . ${submatch} .';';
		    }
		}
	    }
	}
    }
    return $match;
};

$MATCH{S} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # ----------------
    # S is /${REG_S}+/
    # ----------------
    while ($self->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+/gc) {
	$match .= $&;
	last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
    }
    return $match;
};

$MATCH{NMTOKEN} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # -----------------------------
    # NMTOKEN is /${REG_NAMECHAR}+/
    # -----------------------------
    while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/g) {
	$match .= $&;
	last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
    }
    return $match;
};

$MATCH{SYSTEMLITERAL} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # -----------------------------------------------------------------
    # SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
    # -----------------------------------------------------------------
    if ($self->{buf} =~ m/\G["']/gc) {
	$match = my $c = $&;
	++$pos;
	my $lastok = 1;
	while (1) {
	    if (! $self->_isPos($stream, $pos)) {
		$lastok = 0;
		last;
	    }
	    $self->{buf} =~ m/\G[^"]*/gc;              # Note this will always match
	    my $length = $+[0] - $-[0];
	    last if (! $length);
	    $match .= $&;
	    $pos += $length;
	}
	if ($lastok && $self->{buf} =~ m/\G["']/gc && $& eq $c) {
	    $match .= $&;
	} else {
	    $match = '';
	}
    }
    return $match;
};

$MATCH{PUBIDLITERAL} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # ------------------------------------------------------------------------------------
    # PUBIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/
    # ------------------------------------------------------------------------------------
    if ($self->{buf} =~ m/\G["']/g) {
	$match = my $c = $&;
	++$pos;
	my $lastok = 1;
	while (1) {
	    if (! $self->_isPos($stream, $pos)) {
		$lastok = 0;
		last;
	    }
	    $self->{buf} =~ m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/g;   # Note this will always match
	    my $length = $+[0] - $-[0];
	    last if (! $length);
	    $match .= $&;
	    $pos += $length;
	}
	if ($lastok && $self->{buf} =~ m/\G["']/g && $& eq $c) {
	    $match .= $&;
	} else {
	    $match = '';
	}
    }
    return $match;
};

$MATCH{CHARDATA} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # -------------------------------------------------------
    # CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
    # -------------------------------------------------------
    while ($self->{buf} =~ m/\G[^<&]*/gc) {
	my $length = $+[0] - $-[0];
	last if (! $length);
	$match .= $&;
	last if (! $self->_isPos($stream, ($pos += $length)));
    }
    if ($match =~ /\]\]>/i) {
	substr($match, $-[0]) = '';
    }
    return $match;
};

$MATCH{_CHAR_ANY} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    while ($self->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/gc) {
	my $length = $+[0] - $-[0];
	last if (! $length);
	$match .= $&;
	last if (! $self->_isPos($stream, ($pos += $length)));
    }
    return $match;
};

$MATCH{CDATA} = sub {
    my ($self, $stream, $pos) = @_;
    # -------------------------------------------
    # CDATA is _CHAR_ANY minus the sequence ']]>'
    # -------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, ']]>')) >= 0) {
	substr($match, $index) = '';
    }
    return $match;
};

$MATCH{COMMENT} = sub {
    my ($self, $stream, $pos) = @_;
    # --------------------------------------------
    # COMMENT is _CHAR_ANY minus the sequence '--'
    # --------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, '--')) >= 0) {
	substr($match, $index) = '';
    }
    return $match;
};

$MATCH{PI_INTERIOR} = sub {
    my ($self, $stream, $pos) = @_;
    # ------------------------------------------------
    # PI_INTERIOR is _CHAR_ANY minus the sequence '?>'
    # ------------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, '?>')) >= 0) {
	substr($match, $index) = '';
    }
    return $match;
};

$MATCH{IGNORE_INTERIOR} = sub {
    my ($self, $stream, $pos) = @_;
    # ---------------------------------------------------------------
    # IGNORE_INTERIOR is _CHAR_ANY minus the sequences '<![' or ']]>'
    # ---------------------------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    my $index;
    if (($index = index($match, '<![')) >= 0) {
	substr($match, $index) = '';
    }
    if (($index = index($match, ']]>')) >= 0) {
	substr($match, $index) = '';
    }
    return $match;
};

$MATCH{VERSIONNUM} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # -------------------------------
    # VERSIONNUM is /1.${REG_DIGIT}+/
    # -------------------------------
    if ($self->{buf} =~ m/\G1/gc) {
	$match = '1';
	next if (! $self->_isPos($stream, ++$pos));
	if ($self->{buf} =~ m/\G\./gc) {
	    $match .= '.';
	    next if (! $self->_isPos($stream, ++$pos));
	    while ($self->{buf} =~ m/\G[0-9]+/gc) {
		$match .= $&;
		last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	    }
	}
    }
    return $match;
};

$MATCH{ENTITYREF} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # --------------------------
    # ENTITYREF   is /&${NAME};/
    # --------------------------
    if ($self->{buf} =~ m/\G&/gc) {
	if ($self->_isPos($stream, ++$pos)) {
	    if (my $name = $MATCH{NAME}($self, $stream, $pos)) {
		if ($self->_isPos($stream, ($pos += length($name)))) {
		    if ($self->{buf} =~ m/\G;/g) {
			$match = "&$name;";
		    }
		}
	    }
	}
    }
    return $match;
};

$MATCH{PEREFERENCE} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    # --------------------------
    # ENTITYREF   is /%${NAME};/
    # --------------------------
    if ($self->{buf} =~ m/\G%/gc) {
	if ($self->_isPos($stream, ++$pos)) {
	    if (my $name = $MATCH{NAME}($self, $stream, $pos)) {
		if ($self->_isPos($stream, ($pos += length($name)))) {
		    if ($self->{buf} =~ m/\G;/g) {
			$match = "%$name;";
		    }
		}
	    }
	}
    }
    return $match;
};

$MATCH{ATTVALUE} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    #
    # ------------------------------------------------------
    # ATTVALUE is /"(${REG_ATTVALUE_NOT_DQUOTE}|Reference)*"/
    #          or /'(${REG_ATTVALUE_NOT_SQUOTE}|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # ------------------------------------------------------
    if ($self->{buf} =~ m/\G["']/g) {
	$match = my $c = $&;
	++$pos;
	my $dquoteMode = ($c eq '"');
	my $lastok = 1;
	while (1) {
	    if (! $self->_isPos($stream, $pos)) {
		$lastok = 0;
		last;
	    }
	    my $curpos = pos($self->{buf});
	    if (
		(
		 (  $dquoteMode && $self->{buf} =~ m/\G[^<&"]*/gc) ||
		 (! $dquoteMode && $self->{buf} =~ m/\G[^<&']*/gc)
		)
		&& (my $length = $+[0] - $-[0]) > 0) {  # Note the /c modifiers
		$match .= $&;
		$pos += $length;
		next;
	    }
	    # pos($self->{buf}) = $curpos;              # that means this call is not necessary
	    if (my $entityref = $MATCH{ENTITYREF}($self, $stream, $pos)) {
		$match .= $entityref;
		$pos += length($entityref);
		next;
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $charref = $MATCH{CHARREF}($self, $stream, $pos)) {
		$match .= $charref;
		$pos += length($charref);
		next;
	    }
	    pos($self->{buf}) = $curpos;
	    last;
	}
	if ($lastok && $self->{buf} =~ m/\G["']/g && $& eq $c) {
	    $match .= $c;
	} else {
	    $match = '';
	}
    }
    return $match;
};

$MATCH{ENTITYVALUE} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';
    #
    # ------------------------------------------------------
    # ATTVALUE is /"(${REG_ENTITYVALUE_NOT_DQUOTE}|PEReference|Reference)*"/
    #          or /'(${REG_ENTITYVALUE_NOT_SQUOTE}|PEReference|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # ------------------------------------------------------
    if ($self->{buf} =~ m/\G["']/g) {
	$match = my $c = $&;
	++$pos;
	my $dquoteMode = ($c eq '"');
	my $lastok = 1;
	while (1) {
	    if (! $self->_isPos($stream, $pos)) {
		$lastok = 0;
		last;
	    }
	    my $curpos = pos($self->{buf});
	    if (
		(
		 (  $dquoteMode && $self->{buf} =~ m/\G[^%&"]*/gc) ||
		 (! $dquoteMode && $self->{buf} =~ m/\G[^%&']*/gc)
		)
		&& (my $length = $+[0] - $-[0]) > 0) {  # Note the /c modifiers
		$match .= $&;
		$pos += $length;
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $pereference = $MATCH{PEREFERENCE}($self, $stream, $pos)) {
		$match .= $pereference;
		$pos += length($pereference);
		next;
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $entityref = $MATCH{ENTITYREF}($self, $stream, $pos)) {
		$match .= $entityref;
		$pos += length($entityref);
		next;
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $charref = $MATCH{CHARREF}($self, $stream, $pos)) {
		$match .= $charref;
		$pos += length($charref);
		next;
	    }
	    pos($self->{buf}) = $curpos;
	    last;
	}
	#
	# A little overhead if ATTVALUE is "" or '' - will rarelly happen
	#
	if ($lastok && $self->{buf} =~ m/\G["']/g && $& eq $c) {
	    $match .= $c;
	} else {
	    $match = '';
	}
    }
    return $match;
};

$MATCH{_FIXED_STRING} = sub {
    my ($self, $stream, $pos, $terminal) = @_;
    my $match = '';

    if (substr($self->{buf}, pos($self->{buf}), $STRLENGTH{$terminal}) eq $STR{$terminal}) {
	return $STR{$terminal};
    } else {
	return '';
    }
};

$MATCH{_DISCARD} = sub {
    my ($self, $stream, $pos) = @_;
    my $match = '';

    if ($self->{buf} =~ m/\G\s+/g) {
	$match = $&;
    }
    return $match;
};

foreach (keys %STR) {
    my $sub = "\$MATCH{$_} = sub { return \$MATCH{_FIXED_STRING}(\@_, '$_'); }";
    eval $sub;
}

1;
