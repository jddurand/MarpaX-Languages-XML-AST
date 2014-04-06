use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0::Util;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) util methods

# VERSION

use Exporter 'import';
our @EXPORT_OK = qw/%MATCH %STR %STRLENGTH/;
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

#
# This hash exist because we want to do a prefetch of needed characters
# if necessary, so that $MATCH{} CODE reference will work in one go,
# not character per character
#
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
# to the next character if it is successful. The position is guaranteed to be left unchanged if
# no match.
#
# Very often MATCHes are complete in one go.
# That's why $MATCH{} routine always try the full regexp first. There is an overhead when
# the lexeme start at the end of the cached buffer and will continue with next uncached buffer.
# In such a case, a call to _isPos() will append a buffer and reposition.
#
# We check regexps are NOT up to the end of the string with a zero-length look-ahead
# assertion whenever possible, using at least \z and sometimes a character range
# to make sure everything needed was eated.
# -------------------------------------------------------------------------------------------------------------

our %MATCH = ();
$MATCH{NAME} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # ----------------------------------------------
    # NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
    # ----------------------------------------------

    if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*(?![:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]|\z)/gc) {   # Note the /c modifier
	#
	# Per def: NAME matched entirely, and there is at least one other character left in the buffer
	#
	return $&;
    } elsif ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/gc) {   # Note the /c modifier
	#
	# Buffer boundary overhead.
	#
	return $& if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	return $& if (! $self->_isPos($stream, $pos += ($+[0] - $-[0])));

	my $match = $&;                 # From now on there is a match
	while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) {    # Note the /c modifier
	    $match .= $&;
	    last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	}
	return $match;
    }
    return '';
};

$MATCH{PITARGET} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # -------------------------------
    # PITARGET is NAME without /xml/i
    # -------------------------------

    my $match = $MATCH{NAME}(@_);
    if ($match =~ /xml/i) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $-[0]);
      substr($match, $-[0]) = '';
    }
    return $match;
};

$MATCH{ENCNAME} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # ----------------------------------------------
    # ENCNAME is /${REG_ALPHA}${REG_ENCNAME_REST}*/
    # ----------------------------------------------

    if ($self->{buf} =~ m/\G([A-Za-z][A-Za-z0-9._-]*)((?![A-Za-z0-9._-]|\z))/gc) {    # Note the /c modifier
	return $&;
    } elsif ($self->{buf} =~ m/\G[A-Za-z][A-Za-z0-9._-]*/gc) {    # Note the /c modifier
	#
	# From now on there is match
	#
	return $& if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	return $& if (! $self->_isPos($stream, $pos += ($+[0] - $-[0])));
	my $match = $&;                                      # From now on there is match
	while ($self->{buf} =~ m/\G[A-Za-z0-9._-]+/gc) {  # Note the /c modifier
	    $match .= $&;
	    last if (! $self->_isPos($stream, ($pos += ($+[0] - $-[0]))));
	}
	return $match;
    }
    return '';
};

$MATCH{CHARREF} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # ---------------------------------
    # CHARREF is /&#${REG_DIGIT}+;/
    #         or /&#x${REG_HEXDIGIT}+;/
    # ---------------------------------
    if ($self->{buf} =~ m/\G&#(?:[0-9]+|x[0-9a-fA-F]+);/gc) { # Note the /c modifier
	return $&;
    } elsif ($self->{buf} =~ m/\G&#(?:[0-9]+|x[0-9a-fA-F]+);/gc) { # Note the /c modifier
      return $&;
    }
    elsif ($c0 eq '&') {                                           # For speed
      if ($self->_canPos($stream, ++$pos)) {                       # will do a buffer test + pos()
        if ($self->{buf} =~ m/\G#/g && $self->_isPos($stream, ++$pos)) {
          if ($self->{buf} =~ m/\Gx/gc) {                          # Note the /c modifier
            if ($self->_isPos($stream, ++$pos)) {
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
              } else {
                pos($self->{buf}) = $internalPos;
              }
            } else {
              pos($self->{buf}) = $internalPos;
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
            } else {
              pos($self->{buf}) = $internalPos;
            }
          }
        } else {
          pos($self->{buf}) = $internalPos;
        }
      }
    }
    return '';
};

$MATCH{S} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # ----------------
    # S is /${REG_S}+/
    # ----------------

    if ($self->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+(?![\x{20}\x{9}\x{D}\x{A}]|\z)/gc) { # Note the /c modifier
	return $&;
    }

    my $match = '';
    while ($self->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+/gc) { # Note the /c modifier
	$match .= $&;                                         # From now on there is a match
        last if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	last if (! $self->_isPos($stream, $pos += ($+[0] - $-[0])));
    }
    return $match;
};

$MATCH{NMTOKEN} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # -----------------------------
    # NMTOKEN is /${REG_NAMECHAR}+/
    # -----------------------------

    if ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+(?![:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]|\z)/gc) { # Note the /c modifier
	return $&;
    }

    my $match = '';
    while ($self->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) { # Note the /c modifier
	$match .= $&;                                          # From now on there is match
        last if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	last if (! $self->_isPos($stream, $pos += ($+[0] - $-[0])));
    }
    return $match;
};

$MATCH{SYSTEMLITERAL} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # -----------------------------------------------------------------
    # SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
    # -----------------------------------------------------------------

    if (($c0 eq '"'  && $self->{buf} =~ m/\G"[^"]*"/gc) ||  # Note the /c modifier
	($c0 eq '\'' && $self->{buf} =~ m/\G'[^']*'/gc)) {  # Note the /c modifier
	#
	# Note: call to $self->_moreDataNeededUsingInternalPos is not needed
	#
	return $&;
    }
    elsif ($c0 eq '"' || $c0 eq '\'') {                            # For speed
	if ($self->_canPos($stream, ++$pos)) {
	    my $match = $c0;
	    my $dquoteMode = ($c0 eq '"');
	    my $lastok = 1;
	    my $length;
	    while (1) {
		if ((  $dquoteMode && $self->{buf} =~ m/\G[^"]*/gc) ||    # Note this will always match
		    (! $dquoteMode && $self->{buf} =~ m/\G[^']*/gc)) {    # Note this will always match
		    $length = $+[0] - $-[0];
		    last if (! $length);
		    $match .= $&;
		}
		$pos += $length;
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		}
	    }
	    if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
		pos($self->{buf}) += 1;
		return "${match}${c0}";
	    } else {
		pos($self->{buf}) = $internalPos;
	    }
	}
    }
    return '';
};

$MATCH{PUBIDLITERAL} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # ------------------------------------------------------------------------------------
    # PUBIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/

    # ------------------------------------------------------------------------------------
    if (($c0 eq '"'  && $self->{buf} =~ m/\G"[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*"/gc) ||  # Note the /c modifier
	($c0 eq '\'' && $self->{buf} =~ m/\G'[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*'/gc)) {   # Note the /c modifier
	#
	# Note: call to $self->_moreDataNeededUsingInternalPos is not needed
	#
	return $&;
    }
    elsif ($c0 eq '"' || $c0 eq '\'') {                     # For speed
	if ($self->_canPos($stream, ++$pos)) {
	    my $match = $c0;
	    my $dquoteMode = ($c0 eq '"');
	    my $lastok = 1;
	    my $length;
	    while (1) {
		if ((  $dquoteMode && $self->{buf} =~ m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/gc) ||   # Note this will always match
		    (! $dquoteMode && $self->{buf} =~ m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*/gc)) {    # Note this will always match
		    $length = $+[0] - $-[0];
		    last if (! $length);
		    $match .= $&;
		}
		$pos += $length;
		if (! $self->_isPos($stream, $pos)) {
		    $lastok = 0;
		    last;
		}
	    }
	    if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
		pos($self->{buf}) += 1;
		return "${match}${c0}";
	    } else {
		pos($self->{buf}) = $internalPos;
	    }
	}
    }
    return '';
};

$MATCH{CHARDATA} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # -------------------------------------------------------
    # CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
    # -------------------------------------------------------

    if ($self->{buf} =~ m/\G([^<&]*)(?>\]\]>)/gc) { # Note the /c modifier
	#
	# Per def there is ']]>' after $1
	#
	pos($self->{buf}) -= 3;
	return $1;
    }
    elsif ($self->{buf} =~ m/\G[^<&]*(?![^<&]|\z)/gc) { # Note the /c modifier
	return $&;
    }

    my $match = '';
    while ($self->{buf} =~ m/\G[^<&]*/gc) { # Note the /c modifier
	my $length = $+[0] - $-[0];
	last if (! $length);
	$match .= $&;        # From now on there is match
        last if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	last if (! $self->_isPos($stream, $pos += $length));
    }
    if ((my $index = index($match, ']]>')) >= 0) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $index);
      substr($match, $index) = '';
    }
    return $match;
};

$MATCH{_CHAR_ANY} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    # ---------------------------
    # _CHAR_ANY is /${REG_CHAR}*/
    # ---------------------------

    if ($self->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*(?![\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]|\z)/gc) {  # Note the /c modifier
	return $&;
    }

    my $match = '';
    while ($self->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/gc) {  # Note the /c modifier
	my $length = $+[0] - $-[0];
	last if (! $length);
	$match .= $&;        # From now on there is match
        last if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	last if (! $self->_isPos($stream, $pos += $length));
    }
    return $match;
};

$MATCH{CDATA} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # -------------------------------------------
    # CDATA is _CHAR_ANY minus the sequence ']]>'
    # -------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, ']]>')) >= 0) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $index);
      substr($match, $index) = '';
    }
    return $match;
};

$MATCH{COMMENT} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # --------------------------------------------
    # COMMENT is _CHAR_ANY minus the sequence '--'
    # --------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, '--')) >= 0) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $index);
      substr($match, $index) = '';
    }
    return $match;
};

$MATCH{PI_INTERIOR} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # ------------------------------------------------
    # PI_INTERIOR is _CHAR_ANY minus the sequence '?>'
    # ------------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    if ((my $index = index($match, '?>')) >= 0) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $index);
      substr($match, $index) = '';
    }
    return $match;
};

$MATCH{IGNORE_INTERIOR} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # ---------------------------------------------------------------
    # IGNORE_INTERIOR is _CHAR_ANY minus the sequences '<![' or ']]>'
    # ---------------------------------------------------------------
    my $match = $MATCH{_CHAR_ANY}(@_);
    my $index;
    if (($index = index($match, '<![')) >= 0) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $index);
      substr($match, $index) = '';
    }
    if (($index = index($match, ']]>')) >= 0) {
      #
      # We have to reposition manually
      #
      pos($self->{buf}) -= (length($match) - $index);
      substr($match, $index) = '';
    }
    return $match;
};

$MATCH{VERSIONNUM} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
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
          if ($ok) {
            return $match;
          } else {
            pos($self->{buf}) = $internalPos;
          }
        } else {
          pos($self->{buf}) = $internalPos;
        }
      } else {
        pos($self->{buf}) = $internalPos;
      }
    }
    return '';
};

$MATCH{ENTITYREF} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # --------------------------
    # ENTITYREF   is /&${NAME};/
    # --------------------------
    if ($c0 eq '&' && $self->_canPos($stream, ++$pos)) {
      my $newInternalPos = $internalPos + 1;
      my $newc0 = substr($self->{buf}, $newInternalPos, 1);
      if (my $name = $MATCH{NAME}($self, $stream, $pos, $newc0, $newInternalPos)) {
        if ($self->_isPos($stream, ($pos += length($name)))) {
          if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
            pos($self->{buf}) += 1;
            return "&${name};";
          } else {
            pos($self->{buf}) = $internalPos;
          }
        } else {
          pos($self->{buf}) = $internalPos;
        }
      } else {
        pos($self->{buf}) = $internalPos;
      }
    }
    return '';
};

$MATCH{PEREFERENCE} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    # --------------------------
    # PEREFERENCE   is /%${NAME};/
    # --------------------------
    if ($c0 eq '%' && $self->_canPos($stream, ++$pos)) {
      my $newInternalPos = $internalPos + 1;
      my $newc0 = substr($self->{buf}, $newInternalPos, 1);
      if (my $name = $MATCH{NAME}($self, $stream, $pos, $newc0, $newInternalPos)) {
        if ($self->_isPos($stream, ($pos += length($name)))) {
          if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
            pos($self->{buf}) += 1;
            return "&${name};";
          } else {
            pos($self->{buf}) = $internalPos;
          }
        } else {
          pos($self->{buf}) = $internalPos;
        }
      } else {
        pos($self->{buf}) = $internalPos;
      }
    }
    return '';
};

$MATCH{ATTVALUE} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    #
    # ------------------------------------------------------
    # ATTVALUE is /"(${REG_ATTVALUE_NOT_DQUOTE}|Reference)*"/
    #          or /'(${REG_ATTVALUE_NOT_SQUOTE}|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # ------------------------------------------------------  
    if (($c0 eq '"'  && $self->{buf} =~ m/\G"(?:[^<&"]|&[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*"/gc) ||  # Note the /c modifier
	($c0 eq '\'' && $self->{buf} =~ m/\G'(?:[^<&']|&[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*'/gc)) {  # Note the /c modifier
      return $&;
    }
    elsif ($c0 eq '"' || $c0 eq '\'') {           # For speed
      if ($self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	my $dquoteMode = ($c0 eq '"');
	my $lastok = 1;
        my $newInternalPos = $internalPos + 1;
        my $newc0 = substr($self->{buf}, $newInternalPos, 1);
        my $subTokenName;
        my $subTokenValue;
	while (1) {
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
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          if (my $subTokenValue = $MATCH{CHARREF}($self, $stream, $pos, $newc0, $newInternalPos)) {
            $match .= $subTokenValue;
            my $length = length($subTokenValue);
            $pos += $length;
            if (! $self->_isPos($stream, $pos)) {
              $lastok = 0;
              last;
            } else {
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          if (my $subTokenValue = $MATCH{ENTITYREF}($self, $stream, $pos, $newc0, $newInternalPos)) {
            $match .= $subTokenValue;
            my $length = length($subTokenValue);
            $pos += $length;
            if (! $self->_isPos($stream, $pos)) {
              $lastok = 0;
              last;
            } else {
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          last;
	}
	if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
          pos($self->{buf}) += 1;
          return "${match}${c0}";
	} else {
          pos($self->{buf}) = $internalPos;
        }
      }
    }
    return '';
};

$MATCH{ENTITYVALUE} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;

    #
    # ------------------------------------------------------
    # ENTITYVALUE is /"(${REG_ENTITYVALUE_NOT_DQUOTE}|PEReference|Reference)*"/
    #             or /'(${REG_ENTITYVALUE_NOT_SQUOTE}|PEReference|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # and   EntityRef  is: &${NAME};
    # and   PERference is: %${NAME};
    # ------------------------------------------------------
    if ((($c0 eq '"'  && $self->{buf} =~ m/\G"(?:[^<&"]|[&%][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*"/gc) ||                # Note the /c modifier
	 ($c0 eq '\'' && $self->{buf} =~ m/\G'(?:[^<&']|[&%][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*'/gc))                  # Note the /c modifier
        && ! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf}))) {
      return $&;
    }
    elsif ($c0 eq '"' || $c0 eq '\'') {   # For speed
      if ($self->_canPos($stream, ++$pos)) {
	my $match = $c0;
	my $dquoteMode = ($c0 eq '"');
	my $lastok = 1;
        my $newInternalPos = $internalPos + 1;
        my $newc0 = substr($self->{buf}, $newInternalPos, 1);
        my $subTokenName;
        my $subTokenValue;
	while (1) {
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
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          if (my $subTokenValue = $MATCH{CHARREF}($self, $stream, $pos, $newc0, $newInternalPos)) {
            $match .= $subTokenValue;
            my $length = length($subTokenValue);
            $pos += $length;
            if (! $self->_isPos($stream, $pos)) {
              $lastok = 0;
              last;
            } else {
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          if (my $subTokenValue = $MATCH{ENTITYREF}($self, $stream, $pos, $newc0, $newInternalPos)) {
            $match .= $subTokenValue;
            my $length = length($subTokenValue);
            $pos += $length;
            if (! $self->_isPos($stream, $pos)) {
              $lastok = 0;
              last;
            } else {
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          if (my $subTokenValue = $MATCH{PEREFERENCE}($self, $stream, $pos, $newc0, $newInternalPos)) {
            $match .= $subTokenValue;
            my $length = length($subTokenValue);
            $pos += $length;
            if (! $self->_isPos($stream, $pos)) {
              $lastok = 0;
              last;
            } else {
              $newInternalPos += $length;
              $newc0 = substr($self->{buf}, $newInternalPos, 1);
              next;
            }
          }
          last;
	}
	if ($lastok && substr($self->{buf}, pos($self->{buf}), 1) eq $c0) {
          pos($self->{buf}) += 1;
          return "${match}${c0}";
	} else {
          pos($self->{buf}) = $internalPos;
        }
      }
    }
    return '';
};

$MATCH{_DISCARD} = sub {
    my ($self, $stream, $pos, $c0, $internalPos) = @_;
    my $match = '';

    while ($self->{buf} =~ m/\G\s+/gc) {     # Note the /c modifier
	$match .= $&;
        last if (! $self->_moreDataNeededUsingInternalPos($stream, pos($self->{buf})));
	last if (! $self->_isPos($stream, $pos += ($+[0] - $-[0])));
    }

    return $match;
};

$MATCH{X20}              = sub { return ($_[0]->{buf} =~ m/\G\x{20}/gc)      ? $& : ''; };
$MATCH{DQUOTE}           = sub { return ($_[0]->{buf} =~ m/\G"/gc)           ? $& : ''; };
$MATCH{SQUOTE}           = sub { return ($_[0]->{buf} =~ m/\G'/gc)           ? $& : ''; };
$MATCH{EQUAL}            = sub { return ($_[0]->{buf} =~ m/\G=/gc)           ? $& : ''; };
$MATCH{LBRACKET}         = sub { return ($_[0]->{buf} =~ m/\G\[/gc)          ? $& : ''; };
$MATCH{RBRACKET}         = sub { return ($_[0]->{buf} =~ m/\G\]/gc)          ? $& : ''; };
$MATCH{XTAG_BEG}         = sub { return ($_[0]->{buf} =~ m/\G</gc)           ? $& : ''; };
$MATCH{XTAG_END}         = sub { return ($_[0]->{buf} =~ m/\G>/gc)           ? $& : ''; };
$MATCH{STAG_END}         = sub { return ($_[0]->{buf} =~ m/\G>/gc)           ? $& : ''; };
$MATCH{ETAG_END}         = sub { return ($_[0]->{buf} =~ m/\G>/gc)           ? $& : ''; };
$MATCH{QUESTION_MARK}    = sub { return ($_[0]->{buf} =~ m/\G\?/gc)          ? $& : ''; };
$MATCH{STAR}             = sub { return ($_[0]->{buf} =~ m/\G\*/gc)          ? $& : ''; };
$MATCH{PLUS}             = sub { return ($_[0]->{buf} =~ m/\G\+/gc)          ? $& : ''; };
$MATCH{LPAREN}           = sub { return ($_[0]->{buf} =~ m/\G\(/gc)          ? $& : ''; };
$MATCH{RPAREN}           = sub { return ($_[0]->{buf} =~ m/\G\)/gc)          ? $& : ''; };
$MATCH{PIPE}             = sub { return ($_[0]->{buf} =~ m/\G\|/gc)          ? $& : ''; };
$MATCH{COMMA}            = sub { return ($_[0]->{buf} =~ m/\G,/gc)           ? $& : ''; };
$MATCH{PERCENT}          = sub { return ($_[0]->{buf} =~ m/\G%/gc)           ? $& : ''; };
$MATCH{COMMENT_BEG}      = sub { return ($_[0]->{buf} =~ m/\G<!\-\-/gc)      ? $& : ''; };
$MATCH{COMMENT_END}      = sub { return ($_[0]->{buf} =~ m/\G\-\->/gc)       ? $& : ''; };
$MATCH{PI_BEG}           = sub { return ($_[0]->{buf} =~ m/\G<\?/gc)         ? $& : ''; };
$MATCH{PI_END}           = sub { return ($_[0]->{buf} =~ m/\G\?>/gc)         ? $& : ''; };
$MATCH{CDSTART}          = sub { return ($_[0]->{buf} =~ m/\G<!\[CDATA\[/gc) ? $& : ''; };
$MATCH{CDEND}            = sub { return ($_[0]->{buf} =~ m/\G\]\]>/gc)       ? $& : ''; };
$MATCH{XML_BEG}          = sub { return ($_[0]->{buf} =~ m/\G<\?xml/gc)      ? $& : ''; };
$MATCH{XML_END}          = sub { return ($_[0]->{buf} =~ m/\G\?>/gc)         ? $& : ''; };
$MATCH{VERSION}          = sub { return ($_[0]->{buf} =~ m/\Gversion/gc)     ? $& : ''; };
$MATCH{DOCTYPE_BEG}      = sub { return ($_[0]->{buf} =~ m/\G<!DOCTYPE/gc)   ? $& : ''; };
$MATCH{STANDALONE}       = sub { return ($_[0]->{buf} =~ m/\Gstandalone/gc)  ? $& : ''; };
$MATCH{YES}              = sub { return ($_[0]->{buf} =~ m/\Gyes/gc)         ? $& : ''; };
$MATCH{NO}               = sub { return ($_[0]->{buf} =~ m/\Gno/gc)          ? $& : ''; };
$MATCH{ETAG_BEG}         = sub { return ($_[0]->{buf} =~ m/\G<\//gc)         ? $& : ''; };
$MATCH{EMPTYELEMTAG_END} = sub { return ($_[0]->{buf} =~ m/\G\/>/gc)         ? $& : ''; };
$MATCH{ELEMENTDECL_BEG}  = sub { return ($_[0]->{buf} =~ m/\G<!ELEMENT/gc)   ? $& : ''; };
$MATCH{EMPTY}            = sub { return ($_[0]->{buf} =~ m/\GEMPTY/gc)       ? $& : ''; };
$MATCH{ANY}              = sub { return ($_[0]->{buf} =~ m/\GANY/gc)         ? $& : ''; };
$MATCH{RPARENSTAR}       = sub { return ($_[0]->{buf} =~ m/\G\(\*/gc)        ? $& : ''; };
$MATCH{PCDATA}           = sub { return ($_[0]->{buf} =~ m/\G#PCDATA/gc)     ? $& : ''; };
$MATCH{ATTLIST_BEG}      = sub { return ($_[0]->{buf} =~ m/\G<!ATTLIST/gc)   ? $& : ''; };
$MATCH{STRINGTYPE}       = sub { return ($_[0]->{buf} =~ m/\GCDATA/gc)       ? $& : ''; };
$MATCH{TYPE_ID}          = sub { return ($_[0]->{buf} =~ m/\GID/gc)          ? $& : ''; };
$MATCH{TYPE_IDREF}       = sub { return ($_[0]->{buf} =~ m/\GIDREF/gc)       ? $& : ''; };
$MATCH{TYPE_IDREFS}      = sub { return ($_[0]->{buf} =~ m/\GIDREFS/gc)      ? $& : ''; };
$MATCH{TYPE_ENTITY}      = sub { return ($_[0]->{buf} =~ m/\GENTITY/gc)      ? $& : ''; };
$MATCH{TYPE_ENTITIES}    = sub { return ($_[0]->{buf} =~ m/\GENTITIES/gc)    ? $& : ''; };
$MATCH{TYPE_NMTOKEN}     = sub { return ($_[0]->{buf} =~ m/\GNMTOKEN/gc)     ? $& : ''; };
$MATCH{TYPE_NMTOKENS}    = sub { return ($_[0]->{buf} =~ m/\GNMTOKENS/gc)    ? $& : ''; };
$MATCH{NOTATION}         = sub { return ($_[0]->{buf} =~ m/\GNOTATION/gc)    ? $& : ''; };
$MATCH{REQUIRED}         = sub { return ($_[0]->{buf} =~ m/\G#REQUIRED/gc)   ? $& : ''; };
$MATCH{IMPLIED}          = sub { return ($_[0]->{buf} =~ m/\G#IMPLIED/gc)    ? $& : ''; };
$MATCH{FIXED}            = sub { return ($_[0]->{buf} =~ m/\G#FIXED/gc)      ? $& : ''; };
$MATCH{SECT_BEG}         = sub { return ($_[0]->{buf} =~ m/\G<!\[/gc)        ? $& : ''; };
$MATCH{INCLUDE}          = sub { return ($_[0]->{buf} =~ m/\GINCLUDE/gc)     ? $& : ''; };
$MATCH{SECT_END}         = sub { return ($_[0]->{buf} =~ m/\G\]\]>/gc)       ? $& : ''; };
$MATCH{IGNORE}           = sub { return ($_[0]->{buf} =~ m/\GIGNORE/gc)      ? $& : ''; };
$MATCH{EDECL_BEG}        = sub { return ($_[0]->{buf} =~ m/\G<!ENTITY/gc)    ? $& : ''; };
$MATCH{SYSTEM}           = sub { return ($_[0]->{buf} =~ m/\GSYSTEM/gc)      ? $& : ''; };
$MATCH{PUBLIC}           = sub { return ($_[0]->{buf} =~ m/\GPUBLIC/gc)      ? $& : ''; };
$MATCH{NDATA}            = sub { return ($_[0]->{buf} =~ m/\GNDATA/gc)       ? $& : ''; };
$MATCH{ENCODING}         = sub { return ($_[0]->{buf} =~ m/\Gencoding/gc)    ? $& : ''; };
$MATCH{NOTATION_BEG}     = sub { return ($_[0]->{buf} =~ m/\G<!NOTATION/gc)  ? $& : ''; };

1;
