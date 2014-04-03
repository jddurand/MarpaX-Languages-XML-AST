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
our %STRFIRST = ();
foreach (keys %STR) {
    $STRFIRST{$_} = substr($STR{$_}, 0, 1);
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
# to the next character if it is successful. The position is undetermined if not successful.
#
# Very often MATCHes are complete in one go.
# That's why $MATCH{} routine always try the full regexp first.
# -------------------------------------------------------------------------------------------------------------

our %MATCH = ();
$MATCH{NAME} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # ----------------------------------------------
    # NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
    # ----------------------------------------------
    if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/g) {
	my $match = $&;
        $pos += ($+[0] - $-[0]);
	if ($self->_moreDataNeeded($stream, $pos) && $self->_canPos($stream, $pos)) {
	    while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) {    # Note the /c modifier
		$match .= $&;
		last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	    }
	}
	return $match;
    }
    return '';
};

$MATCH{PITARGET} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # -----------------------------------------------------------------
    # PITARGET is NAME without /xml/i
    # -----------------------------------------------------------------
    my $match = $MATCH{NAME}(@_);
    if ($match =~ /xml/i) {
	substr($match, $-[0]) = '';
	$self->_canPos($stream, $pos + length($match));
    }
    return $match;
};

$MATCH{ENCNAME} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # ----------------------------------------------
    # ENCNAME is /${REG_ALPHA}${REG_ENCNAME_REST}*/
    # ----------------------------------------------
    if ($self->{buf} =~ m/\G[A-Za-z][A-Za-z0-9._-]*/g) {
	my $match = $&;
	$pos += ($+[0] - $-[0]);
	if ($self->_moreDataNeeded($stream, $pos) && $self->_canPos($stream, $pos)) {
	    while ($self->{buf} =~ m/\G[A-Za-z0-9._-]+/gc) {        # Note the /c modifier
		$match .= $&;
		last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	    }
	}
	return $match;
    }
    return '';
};

$MATCH{CHARREF} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # ---------------------------------
    # CHARREF is /&#${REG_DIGIT}+;/
    #         or /&#x${REG_HEXDIGIT}+;/
    # ---------------------------------
    if ($self->{buf} =~ m/\G&#(?:[0-9]+|x[0-9a-fA-F]+);/g &&
        ! $self->_moreDataNeeded($stream, $pos + $+[0] - $-[0])) {
      return $&;
    }
    elsif ($c0 eq '&' && ! $self->_canPos($stream, ++$pos)) {
	if ($self->{buf} =~ m/\G#/g && $self->_isPos($stream, ++$pos)) {
	    if ($self->{buf} =~ m/\Gx/gc && $self->_isPos($stream, ++$pos)) {
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
		if ($submatchok && substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
		    pos($self->{buf}) += 1;
		    return "&#x${submatch};";
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
		if ($submatchok && substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
		    pos($self->{buf}) += 1;
		    return "&#${submatch};";
		}
	    }
	}
    }
    return '';
};

$MATCH{S} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    my $match = '';
    # ----------------
    # S is /${REG_S}+/
    # ----------------
    while ($self->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+/gc) { # Note the /c modifier
	$match .= $&;
        $pos += ($+[0] - $-[0]);
        last if (! $self->_moreDataNeeded($stream, $pos));
	last if (! $self->_isPos($stream, $pos));
    }
    return $match;
};

$MATCH{NMTOKEN} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    my $match = '';
    # -----------------------------
    # NMTOKEN is /${REG_NAMECHAR}+/
    # -----------------------------
    while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) { # Note the /c modifier
	$match .= $&;
        $pos += ($+[0] - $-[0]);
        last if (! $self->_moreDataNeeded($stream, $pos));
	last if (! $self->_isPos($stream, $pos));
    }
    return $match;
};

$MATCH{SYSTEMLITERAL} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # -----------------------------------------------------------------
    # SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
    # -----------------------------------------------------------------
    if ($self->{buf} =~ m/\G(?:"[^"]*"|'[^']*')/g &&
        ! $self->_moreDataNeeded($stream, $pos + $+[0] - $-[0])) {
      return $&;
    }
    elsif (($c0 eq '"' || $c0 eq '\'') && $self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	my $dquoteMode = ($c0 eq '"');
	my $lastok = 1;
	while (1) {
	    $self->{buf} =~ $dquoteMode ? m/\G[^"]*/gc : m/\G[^']*/gc;   # Note this will always match
	    my $length = $+[0] - $-[0];
	    last if (! $length);
	    $match .= $&;
	    $pos += $length;
	    if (! $self->_isPos($stream, $pos)) {
		$lastok = 0;
		last;
	    }
	}
	if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
	    pos($self->{buf}) += 1;
	    return "${match}${c0}";
	}
    }
    return '';
};

$MATCH{PUBIDLITERAL} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # ------------------------------------------------------------------------------------
    # PUBIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/
    # ------------------------------------------------------------------------------------
    if ($self->{buf} =~ m/\G(?:"[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*"|'[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*')/g &&
        ! $self->_moreDataNeeded($stream, $pos + $+[0] - $-[0])) {
      return $&;
    }
    elsif (($c0 eq '"' || $c0 eq '\'') && $self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	my $dquoteMode = ($c0 eq '"');
	my $lastok = 1;
	while (1) {
	    $self->{buf} =~ $dquoteMode ? m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/gc : m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*/gc;   # Note this will always match
	    my $length = $+[0] - $-[0];
	    last if (! $length);
	    $match .= $&;
	    $pos += $length;
	    if (! $self->_isPos($stream, $pos)) {
		$lastok = 0;
		last;
	    }
	}
	if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
	    pos($self->{buf}) += 1;
	    return "${match}${c0}";
	}
    }
    return '';
};

$MATCH{CHARDATA} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    my $match = '';
    my $origpos = $pos;
    # -------------------------------------------------------
    # CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
    # -------------------------------------------------------
    while ($self->{buf} =~ m/\G[^<&]*/gc) { # Note the /c modifier
	my $length = $+[0] - $-[0];
	last if (! $length);
	$match .= $&;
        $pos += $length;
        last if (! $self->_moreDataNeeded($stream, $pos));
	last if (! $self->_isPos($stream, $pos));
    }
    if ((my $index = index($match, ']]>')) >= 0) {
	substr($match, $index) = '';
	$self->_canPos($stream, $origpos + length($match));
    }
    return $match;
};

$MATCH{_CHAR_ANY} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    my $match = '';
    while ($self->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/g) {
	my $length = $+[0] - $-[0];
	last if (! $length);
	$match .= $&;
        $pos += $length;
        last if (! $self->_moreDataNeeded($stream, $pos));
	last if (! $self->_isPos($stream, $pos));
    }
    return $match;
};

$MATCH{CDATA} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # -------------------------------------------
    # CDATA is _CHAR_ANY minus the sequence ']]>'
    # -------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, ']]>')) >= 0) {
	substr($match, $index) = '';
	$self->_canPos($stream, $pos + length($match));
    }
    return $match;
};

$MATCH{COMMENT} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # --------------------------------------------
    # COMMENT is _CHAR_ANY minus the sequence '--'
    # --------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, '--')) >= 0) {
	substr($match, $index) = '';
	$self->_canPos($stream, $pos + length($match));
    }
    return $match;
};

$MATCH{PI_INTERIOR} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # ------------------------------------------------
    # PI_INTERIOR is _CHAR_ANY minus the sequence '?>'
    # ------------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, '?>')) >= 0) {
	substr($match, $index) = '';
	$self->_canPos($stream, $pos + length($match));
    }
    return $match;
};

$MATCH{IGNORE_INTERIOR} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # ---------------------------------------------------------------
    # IGNORE_INTERIOR is _CHAR_ANY minus the sequences '<![' or ']]>'
    # ---------------------------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    my $index;
    if (($index = index($match, '<![')) >= 0) {
	substr($match, $index) = '';
	$self->_canPos($stream, $pos + length($match));
    }
    if (($index = index($match, ']]>')) >= 0) {
	substr($match, $index) = '';
	$self->_canPos($stream, $pos + length($match));
    }
    return $match;
};

$MATCH{VERSIONNUM} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # -------------------------------
    # VERSIONNUM is /1.${REG_DIGIT}+/
    # -------------------------------
    if ($c0 eq '1' && $self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	if ($self->{buf} =~ m/\G\./g && $self->_isPos($stream, ++$pos)) {
	    $match .= '.';
	    if ($self->_isPos($stream, ++$pos)) {
		my $ok = 0;
		while ($self->{buf} =~ m/\G[0-9]+/gc) { # Note the /c modifier
		    $match .= $&;
		    $pos += ($+[0] - $-[0]);
		    $ok = 1;
		    last if (! $self->_isPos($stream, $pos));
		}
		return $match if ($ok);
	    }
	}
    }
    return '';
};

$MATCH{ENTITYREF} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # --------------------------
    # ENTITYREF   is /&${NAME};/
    # --------------------------
    if ($c0 eq '&' && $self->_canPos($stream, ++$pos)) {
	if (my $name = $MATCH{NAME}($self, $stream, $pos)) {
	    if ($self->_isPos($stream, ($pos += length($name)))) {
		if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
		    pos($self->{buf}) += 1;
		    return "&${name};";
		}
	    }
	}
    }
    return '';
};

$MATCH{PEREFERENCE} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    # --------------------------
    # ENTITYREF   is /%${NAME};/
    # --------------------------
    if ($c0 eq '%' && $self->_canPos($stream, ++$pos)) {
	if (my $name = $MATCH{NAME}($self, $stream, $pos)) {
	    if ($self->_isPos($stream, ($pos += length($name)))) {
		if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
		    pos($self->{buf}) += 1;
		    return "&${name};";
		}
	    }
	}
    }
    return '';
};

$MATCH{ATTVALUE} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    #
    # ------------------------------------------------------
    # ATTVALUE is /"(${REG_ATTVALUE_NOT_DQUOTE}|Reference)*"/
    #          or /'(${REG_ATTVALUE_NOT_SQUOTE}|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # ------------------------------------------------------
    if ($self->{buf} =~ m/\G(?:"(?:[^<&"]|&[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*"|'(?:[^<&']|&[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*')/g &&
        ! $self->_moreDataNeeded($stream, $pos + $+[0] - $-[0])) {
      return $&;
    }
    elsif (($c0 eq '"' || $c0 eq '\'') && $self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	my $dquoteMode = ($c0 eq '"');
	my $lastok = 1;
	while (1) {
	    my $curpos = pos($self->{buf});
	    if (
		(
		 (  $dquoteMode && $self->{buf} =~ m/\G[^<&"]*/gc) ||   # Note the /c modifier
		 (! $dquoteMode && $self->{buf} =~ m/\G[^<&']*/gc)      # Note the /c modifier
		)
		&& (my $length = $+[0] - $-[0]) > 0) {
		$match .= $&;
		$pos += $length;
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    # pos($self->{buf}) = $curpos;                               # not necessary c.f. /c modifiers upper
	    if (my $entityref = $MATCH{ENTITYREF}($self, $stream, $pos)) {
		$match .= $entityref;
		$pos += length($entityref);
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $charref = $MATCH{CHARREF}($self, $stream, $pos)) {
		$match .= $charref;
		$pos += length($charref);
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    pos($self->{buf}) = $curpos;
	    last;
	}
	if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
	    pos($self->{buf}) += 1;
	    return "${match}${c0}";
	}
    }
    return '';
};

$MATCH{ENTITYVALUE} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    #
    # ------------------------------------------------------
    # ENTITYVALUE is /"(${REG_ENTITYVALUE_NOT_DQUOTE}|PEReference|Reference)*"/
    #             or /'(${REG_ENTITYVALUE_NOT_SQUOTE}|PEReference|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # and   EntityRef  is: &${NAME};
    # and   PERference is: %${NAME};
    # ------------------------------------------------------
    if ($self->{buf} =~ m/\G(?:"(?:[^<&"]|[&%][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*"|'(?:[^<&']|[&%][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*')/gc &&
        ! $self->_moreDataNeeded($stream, $pos + $+[0] - $-[0])) {
      return $&;
    }
    elsif (($c0 eq '"' || $c0 eq '\'') && $self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	my $dquoteMode = ($c0 eq '"');
	my $lastok = 1;
	while (1) {
	    my $curpos = pos($self->{buf});
	    if (
		(
		 (  $dquoteMode && $self->{buf} =~ m/\G[^%&"]*/gc) ||  # Note the /c modifier
		 (! $dquoteMode && $self->{buf} =~ m/\G[^%&']*/gc)     # Note the /c modifier
		)
		&& (my $length = $+[0] - $-[0]) > 0) {
		$match .= $&;
		$pos += $length;
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    # pos($self->{buf}) = $curpos;                               # not necessary c.f. /c modifiers upper
	    if (my $pereference = $MATCH{PEREFERENCE}($self, $stream, $pos)) {
		$match .= $pereference;
		$pos += length($pereference);
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $entityref = $MATCH{ENTITYREF}($self, $stream, $pos)) {
		$match .= $entityref;
		$pos += length($entityref);
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    pos($self->{buf}) = $curpos;
	    if (my $charref = $MATCH{CHARREF}($self, $stream, $pos)) {
		$match .= $charref;
		$pos += length($charref);
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		} else {
		    next;
		}
	    }
	    pos($self->{buf}) = $curpos;
	    last;
	}
	if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
	    pos($self->{buf}) += 1;
	    return "${match}${c0}";
	}
    }
    return '';
};

$MATCH{_DISCARD} = sub {
    my ($self, $stream, $pos, $c0) = @_;
    my $match = '';

    while ($self->{buf} =~ m/\G\s+/gc) {     # Note the /c modifier
	$match .= $&;
        $pos += ($+[0] - $-[0]);
	last if (! $self->_moreDataNeeded($stream, $pos));
	last if (! $self->_isPos($stream, $pos));
    }

    return $match;
};

foreach my $terminal (keys %STR) {
    if ($STRLENGTH{$terminal} == 1) {
	$MATCH{$terminal} = sub {
	    my ($self, $stream, $pos, $c0) = @_;

	    if ($c0 eq $STRFIRST{$terminal}) {
		pos($self->{buf}) += 1;
		return $c0;
	    }
	    return '';
	}
    } else {
	$MATCH{$terminal} = sub {
	    my ($self, $stream, $pos, $c0) = @_;

	    if (substr($self->{buf}, pos($self->{buf}), $STRLENGTH{$terminal}) eq $STR{$terminal}) {
		pos($self->{buf}) += $STRLENGTH{$terminal};
		return $STR{$terminal};
	    }
	    return '';
	}
    }
}

1;
