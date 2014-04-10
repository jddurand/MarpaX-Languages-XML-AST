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
our %STR2GPERFTOK = ();
$STR{X20}              = "\x{20}";
$STR{DQUOTE}           = '"';
$STR{SQUOTE}           = "'";
$STR{EQUAL}            = '=';
$STR{LBRACKET}         = '[';
$STR{RBRACKET}         = ']';
$STR{XTAG_BEG}         = '<';           $STR2GPERFTOK{XTAG_BEG} = 'TAG_BEG';
$STR{XTAG_END}         = '>';           $STR2GPERFTOK{XTAG_END} = 'TAG_END';
$STR{STAG_END}         = '>';           $STR2GPERFTOK{STAG_END} = 'TAG_END';
$STR{ETAG_END}         = '>';           $STR2GPERFTOK{ETAG_END} = 'TAG_END';
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
$STR{PI_END}           = '?>';          $STR2GPERFTOK{PI_END} = 'END';
$STR{CDSTART}          = '<![CDATA[';
$STR{CDEND}            = ']]>';         $STR2GPERFTOK{CDEND} = 'END2';
$STR{XML_BEG}          = '<?xml';
$STR{XML_END}          = '?>';          $STR2GPERFTOK{XML_END} = 'END';
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
$STR{SECT_END}         = ']]>';         $STR2GPERFTOK{SECT_ENT} = 'END2';
$STR{IGNORE}           = 'IGNORE';
$STR{EDECL_BEG}        = '<!ENTITY';
$STR{SYSTEM}           = 'SYSTEM';
$STR{PUBLIC}           = 'PUBLIC';
$STR{NDATA}            = 'NDATA';
$STR{ENCODING}         = 'encoding';
$STR{NOTATION_BEG}     = '<!NOTATION';
#
# Fill the other mappings with gperf
#
foreach (keys %STR) {
  $STR2GPERFTOK{$_} //= $_;
}
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

#
# For fixed-string lexing there is NO NEED to do character-per-character
# comparison:
# - all strings are using character that are in the ASCII range [0-128]
#
# Let M be the maximum number of characters between all these fixed strings:
# For instance, in our case, M will be 10.
#
our $M = 0;
foreach (keys %STR) {
    if (length($STR{$_}) > $M) {
	$M = length($STR{$_});
    }
}
#
# Let B be the number SUM(

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
#
# Every $MATCH{} is a CODE reference that has this signature:
# -----------------------------------------------------------
# my ($self, $stream, $pos, $c0, $value) = @_;
# -----------------------------------------------------------
# If success:
# - $pos and and $valuep will be changed, internal buffer pos() will be changed, and return value will be 1
# If failure:
# - $pos will have its initial value at return, internal buffer pos() unchanged, and return value is undef
# - $value may have something, that is irrelevant
#
# -------------------------------------------------------------------------------------------------------------

our %MATCH = ();
$MATCH{NAME} = sub {
    # my ($self, $stream, $pos, $c0, $value) = @_;

    # ----------------------------------------------
    # NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
    # ----------------------------------------------

    if ($_[0]->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*(?![:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]|\z)/gc) {   # Note the /c modifier
	#
	# Per def: NAME matched entirely, and there is at least one other character left in the buffer
	#
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }
    elsif ($_[0]->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/gc) {   # Note the /c modifier
	#
	# There is a match. Is there anything left uncached ?
	#
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	return 1 if (! $_[0]->_isPos($_[1], $_[2]));

	while ($_[0]->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) {    # Note the /c modifier
	    $_[4] .= $&;                     # $value
	    $_[2] += length($&);             # $pos
	    last if (! $_[0]->_isPos($_[1], $_[2]));
	}
	# Internal position in buffer is already correct
	return 1;
    }
    return undef;
};

$MATCH{PITARGET} = sub {
    # my ($self, $stream, $pos, $c0, $value) = @_;

    # -------------------------------
    # PITARGET is NAME without /xml/i
    # -------------------------------

    my ($savPos, $savInternalPos) = ($_[2], pos($_[0]->{buf}));
    if ($MATCH{NAME}(@_)) {
	if ($_[4] =~ /xml/i) {
	    if (! $-[0]) {                               # /xml/i is at the very beginning
		$_[2] = $savPos;                         # Restore $pos
		pos($_[0]->{buf}) = $savInternalPos;     # Restore internal position
		return undef;
	    } else {
		#
		# We have to go back with the return values
		#
		substr($_[4], $-[0]) = '';                       # $value
		my $length = length($_[4]);
		$_[2] = $savPos + $length;                       # $pos
		pos($_[0]->{buf}) = $savInternalPos + $length;   # internal position
		return 1;
	    }
	}
    }
    return undef;
};

$MATCH{ENCNAME} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # ----------------------------------------------
    # ENCNAME is /${REG_ALPHA}${REG_ENCNAME_REST}*/
    # ----------------------------------------------

    if ($_[0]->{buf} =~ m/\G([A-Za-z][A-Za-z0-9._-]*)((?![A-Za-z0-9._-]|\z))/gc) {    # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    } elsif ($_[0]->{buf} =~ m/\G[A-Za-z][A-Za-z0-9._-]*/gc) {    # Note the /c modifier
	#
	# There is a match. Is there anything left uncached ?
	#
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	return 1 if (! $_[0]->_isPos($_[1], $_[2]));

	while ($_[0]->{buf} =~ m/\G[A-Za-z0-9._-]+/gc) {  # Note the /c modifier
	    $_[4] .= $&;                     # $value
	    $_[2] += length($&);             # $pos
	    last if (! $_[0]->_isPos($_[1], $_[2]));
	}
	# Internal position in buffer is already correct
	return 1;
    }
    return undef;
};

$MATCH{CHARREF} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # ---------------------------------
    # CHARREF is /&#${REG_DIGIT}+;/
    #         or /&#x${REG_HEXDIGIT}+;/
    # ---------------------------------

    if ($_[0]->{buf} =~ m/\G&#(?:[0-9]+|x[0-9a-fA-F]+);/gc) { # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }
    elsif ($_[3] eq '&') {                                           # For speed
	my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
	if (! $_[0]->_canPos($_[1], ++$newPos)) {              # will do a buffer test + pos()
	    ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
	    return undef;
	}
        if ($_[0]->{buf} =~ m/\G#/g && ! $_[0]->_isPos($_[1], ++$newPos)) {
	    ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
	    return undef;
	}
	if ($_[0]->{buf} =~ m/\Gx/gc) {                          # Note the /c modifier
            if ($_[0]->_isPos($_[1], ++$newPos)) {
              #
              # We expect ${REG_HEXDIGIT}+ followed by ';'
              #
              my $submatch = '';
              my $submatchok = 0;
              while ($_[0]->{buf} =~ m/\G[0-9a-fA-F]+/gc) {   # Note the /c modifier
                $submatch .= $&;
                $submatchok = 1;
                last if (! $_[0]->_isPos($_[1], ($newPos += ($+[0] - $-[0]))));
              }
              if ($submatchok && substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq ';') {
                $_[4] = "&#x${submatch};";                    # $value
		$_[2] = $newPos;                              # $pos
                pos($_[0]->{buf}) += 1;                       # internal position
		return 1;
              } else {
		  ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		  return undef;
              }
            } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
            }
          } else {
            #
            # We expect ${REG_DIGIT}+ followed by ';'
            #
            my $submatch = '';
            my $submatchok = 0;
            while ($_[0]->{buf} =~ m/\G[0-9]+/gc) {   # Note the /c modifier
              $submatch .= $&;
              $submatchok = 1;
              last if (! $_[0]->_isPos($_[1], ($newPos += ($+[0] - $-[0]))));
            }
            if ($submatchok && substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq ';') {
		$_[4] = "&#${submatch};";                     # $value
		$_[2] = $newPos;                              # $pos
		pos($_[0]->{buf}) += 1;                       # internal position
		return 1;
            } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
            }
          }
    }
    return undef;
};

$MATCH{S} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # ----------------
    # S is /${REG_S}+/
    # ----------------

    if ($_[0]->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+(?![\x{20}\x{9}\x{D}\x{A}]|\z)/gc) { # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }

    my $rc = undef;
    $_[4] = '';
    while ($_[0]->{buf} =~ m/\G[\x{20}\x{9}\x{D}\x{A}]+/gc) { # Note the /c modifier
	$_[4] .= $&;                                         # $value
	$_[2] += length($&);                                 # $pos
	$rc = 1;
	last if (! $_[0]->_isPos($_[1], $_[2]));
    }
    #
    # Internal position already correct
    #
    return $rc;
};

$MATCH{NMTOKEN} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # -----------------------------
    # NMTOKEN is /${REG_NAMECHAR}+/
    # -----------------------------

    if ($_[0]->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+(?![:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]|\z)/gc) { # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }

    my $rc = undef;
    while ($_[0]->{buf} =~ m/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/gc) { # Note the /c modifier
	$_[4] .= $&;                                         # $value
	$_[2] += length($&);                                 # $pos
	$rc = 1;
	last if (! $_[0]->_isPos($_[1], $_[2]));
    }
    return $rc;
};

$MATCH{SYSTEMLITERAL} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # -----------------------------------------------------------------
    # SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
    # -----------------------------------------------------------------

    if (($_[3] eq '"'  && $_[0]->{buf} =~ m/\G"[^"]*"/gc) ||  # Note the /c modifier
	($_[3] eq '\'' && $_[0]->{buf} =~ m/\G'[^']*'/gc)) {  # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }
    elsif ($_[3] eq '"' || $_[3] eq '\'') {                            # For speed
	my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
	if ($_[0]->_canPos($_[1], ++$newPos)) {
	    $_[4] = $_[3];
	    my $dquoteMode = ($_[3] eq '"');
	    my $lastok = 1;
	    my $length;
	    while (1) {
		if ((  $dquoteMode && $_[0]->{buf} =~ m/\G[^"]*/gc) ||    # Note this will always match
		    (! $dquoteMode && $_[0]->{buf} =~ m/\G[^']*/gc)) {    # Note this will always match
		    $length = $+[0] - $-[0];
		    last if (! $length);
		    $_[4] .= $&;
		    $newPos += $length;
		}
		if (! $_[0]->_isPos($_[1], $newPos)) {
		    $lastok = 0;
		    last;
		}
	    }
	    if ($lastok && substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq $_[3]) {
		pos($_[0]->{buf}) += 1;
		$_[4] .= $_[3];
		$_[2] = ++$newPos;
		return 1;
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	} else {
	    pos($_[0]->{buf}) = $savInternalPos;
	}
    }
    return undef;
};

$MATCH{PUBIDLITERAL} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # ------------------------------------------------------------------------------------
    # PUBIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/

    # ------------------------------------------------------------------------------------
    if (($_[3] eq '"'  && $_[0]->{buf} =~ m/\G"[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*"/gc) ||  # Note the /c modifier
	($_[3] eq '\'' && $_[0]->{buf} =~ m/\G'[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*'/gc)) {   # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }
    elsif ($_[3] eq '"' || $_[3] eq '\'') {                     # For speed
	my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
	if ($_[0]->_canPos($_[1], ++$newPos)) {
	    $_[4] = $_[3];
	    my $dquoteMode = ($_[3] eq '"');
	    my $lastok = 1;
	    my $length;
	    while (1) {
		if ((  $dquoteMode && $_[0]->{buf} =~ m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/gc) ||   # Note this will always match
		    (! $dquoteMode && $_[0]->{buf} =~ m/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*/gc)) {    # Note this will always match
		    $length = $+[0] - $-[0];
		    last if (! $length);
		    $_[4] .= $&;
		    $newPos += $length;
		}
		if (! $_[0]->_isPos($_[1], $newPos)) {
		    $lastok = 0;
		    last;
		}
	    }
	    if ($lastok && substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq $_[3]) {
		pos($_[0]->{buf}) += 1;
		$_[4] .= $_[3];
		$_[2] = ++$newPos;
		return 1;
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	} else {
	    pos($_[0]->{buf}) = $savInternalPos;
	}
    }
    return undef;
};

$MATCH{CHARDATA} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # -------------------------------------------------------
    # CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
    # -------------------------------------------------------

    if ($_[0]->{buf} =~ m/\G([^<&]+)(?:(?>\]\]>)|(?![^<&]|\z))/gc) { # Note the /c modifier
	#
	# Per def there is ']]>' or something else not of interest after $1
	#
	$_[4] = $1;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }

    my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
    my $rc = undef;
    $_[4] = '';
    while ($_[0]->{buf} =~ m/\G[^<&]+/gc) { # Note the /c modifier
	$_[4] .= $&;                                         # $value
	$newPos += length($&);                               # $pos
	$rc = 1;
	last if (! $_[0]->_isPos($_[1], $newPos));
    }
    if ($rc) {
      my $index = index($_[4], ']]>');
      if ($index < 0) {
        $_[2] = $newPos;
        return 1;
      } elsif ($index == 0) {
        ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
        return undef;
      } else {
        #
        # We have to go back with the return values
        #
        substr($_[4], $index) = '';                       # $value
        my $length = length($_[4]);
        $_[2] = $savPos + $length;                       # $pos
        pos($_[0]->{buf}) = $savInternalPos + $length;   # internal position
        return 1;
      }
    }
    return $rc;
};

$MATCH{_CHAR_ANY} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    # ---------------------------
    # _CHAR_ANY is /${REG_CHAR}*/
    # ---------------------------

    if ($_[0]->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*(?![\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]|\z)/gc) {  # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($&);                 # $pos
	# Internal position in buffer is already correct
	return 1;
    }

    my ($savPos, $savInternalPos) = ($_[2], pos($_[0]->{buf}));
    my $rc = undef;
    $_[4] = '';
    while ($_[0]->{buf} =~ m/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/gc) {  # Note the /c modifier
	$_[4] .= $&;                                         # $value
	$_[2] += length($&);                                 # $pos
	$rc = 1;
	last if (! $_[0]->_isPos($_[1], $_[2]));
    }
    return $rc;
};

$MATCH{_CHAR_ANY_AND_EXCLUSION} = sub {
    # my ($self, $stream, $pos, $c0, $valuep, $exclusion) = @_;
    # -------------------------------------------
    # CDATA is _CHAR_ANY minus the sequence ']]>'
    # -------------------------------------------
    my ($savPos, $savInternalPos) = ($_[2], pos($_[0]->{buf}));
    if ($MATCH{_CHAR_ANY}(@_)) {
      if ((my $index = index($_[4], $_[5])) >= 0) {
        if ($index == 0) {
          ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
          return undef;
        } else {
          #
          # We have to go back with the return values
          #
          substr($_[4], $index) = '';                       # $value
          my $length = length($_[4]);
          $_[2] = $savPos + $length;                       # $pos
          pos($_[0]->{buf}) = $savInternalPos + $length;   # internal position
          return 1;
        }
      } else {
        return 1;
      }
    }
    return undef;
};

$MATCH{_CHAR_ANY_AND_EXCLUSIONS} = sub {
    # my ($self, $stream, $pos, $c0, $valuep, $exclusionArrayp) = @_;
    # -------------------------------------------
    # CDATA is _CHAR_ANY minus the sequence ']]>'
    # -------------------------------------------
    my ($savPos, $savInternalPos) = ($_[2], pos($_[0]->{buf}));
    if ($MATCH{_CHAR_ANY}(@_)) {
      my $index;
      foreach (@{$_[5]}) {
        if (($index = index($_[4], $_)) >= 0) {
          if ($index == 0) {
            ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
            return undef;
          } else {
            #
            # We have to go back with the return values
            #
            substr($_[4], $index) = '';                       # $value
            my $length = length($_[4]);
            $_[2] = $savPos + $length;                       # $pos
            pos($_[0]->{buf}) = $savInternalPos + $length;   # internal position
          }
        }
      }
      return 1;
    }
    return undef;
};

$MATCH{CDATA} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # -------------------------------------------
    # CDATA is _CHAR_ANY minus the sequence ']]>'
    # -------------------------------------------
    return $MATCH{_CHAR_ANY_AND_EXCLUSION}(@_, ']]>');
};

$MATCH{COMMENT} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # --------------------------------------------
    # COMMENT is _CHAR_ANY minus the sequence '--'
    # --------------------------------------------
    return $MATCH{_CHAR_ANY_AND_EXCLUSION}(@_, '--');
};

$MATCH{PI_INTERIOR} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # ------------------------------------------------
    # PI_INTERIOR is _CHAR_ANY minus the sequence '?>'
    # ------------------------------------------------
    return $MATCH{_CHAR_ANY_AND_EXCLUSION}(@_, '?>');
};

$MATCH{IGNORE_INTERIOR} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # ---------------------------------------------------------------
    # IGNORE_INTERIOR is _CHAR_ANY minus the sequences '<![' or ']]>'
    # ---------------------------------------------------------------
    return $MATCH{_CHAR_ANY_AND_EXCLUSIONS}(@_, ['<![', ']]>']);
};

$MATCH{VERSIONNUM} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # -------------------------------
    # VERSIONNUM is /1.${REG_DIGIT}+/
    # -------------------------------
    my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
    if ($_[3] eq '1' && $_[0]->_canPos($_[1], ++$newPos)) {
	$_[4] = $_[3];
	if ($_[0]->{buf} =~ m/\G\./g && $_[0]->_isPos($_[1], ++$newPos)) {
	    $_[4] .= '.';
	    if ($_[0]->_isPos($_[1], $newPos+1)) {
		my $ok = 0;
		while ($_[0]->{buf} =~ m/\G[0-9]+/gc) { # Note the /c modifier
		    $_[4] .= $&;
		    $newPos += ($+[0] - $-[0]);
		    $ok = 1;
		    last if (! $_[0]->_isPos($_[1], $newPos));
		}
		if ($ok) {
		    $_[2] = $newPos;                              # $pos
		    # value is already ok
		    # internal position is already ok
		    return 1;
		} else {
		    ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		    return undef;
		}
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	} else {
	    ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
	    return undef;
	}
    }
    return undef;
};

$MATCH{ENTITYREF} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # --------------------------
    # ENTITYREF   is /&${NAME};/
    # --------------------------
    my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
    if ($_[3] eq '&' && $_[0]->_canPos($_[1], ++$newPos)) {
	my $newc0 = substr($_[0]->{buf}, pos($_[0]->{buf}), 1);
	my $name;
	if ($MATCH{NAME}($_[0], $_[1], $newPos, $newc0, $name)) {
	    if (substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq ';') {
		$_[4] = "&${name};";               # $value
		$_[2] = ++$newPos;                 # $pos
		pos($_[0]->{buf}) += 1;            # internal buffer position
		return 1;
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	} else {
	    ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
	    return undef;
	}
    }
    return undef;
};

$MATCH{PEREFERENCE} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    # ----------------------------
    # PEREFERENCE   is /%${NAME};/
    # ----------------------------
    my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
    if ($_[3] eq '%' && $_[0]->_canPos($_[1], ++$newPos)) {
	my $newc0 = substr($_[0]->{buf}, pos($_[0]->{buf}), 1);
	my $name;
	if ($MATCH{NAME}($_[0], $_[1], $newPos, $newc0, $name)) {
	    if (substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq ';') {
		$_[4] = "&${name};";               # $value
		$_[2] = ++$newPos;                 # $pos
		pos($_[0]->{buf}) += 1;            # internal buffer position
		return 1;
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	} else {
	    ($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
	    return undef;
	}
    }
    return undef;
};

$MATCH{ATTVALUE} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    #
    # ------------------------------------------------------
    # ATTVALUE is /"(${REG_ATTVALUE_NOT_DQUOTE}|Reference)*"/
    #          or /'(${REG_ATTVALUE_NOT_SQUOTE}|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # ------------------------------------------------------  
    if (($_[3] eq '"'  && $_[0]->{buf} =~ m/\G"(?:[^<&"]|&[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*"/gc) ||  # Note the /c modifier
	($_[3] eq '\'' && $_[0]->{buf} =~ m/\G'(?:[^<&']|&[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*'/gc)) {  # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }
    elsif ($_[3] eq '"' || $_[3] eq '\'') {           # For speed
	my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
	if ($_[0]->_canPos($_[1], ++$newPos)) {
	    $_[4] = $_[3];
	    my $dquoteMode = ($_[3] eq '"');
	    my $lastok = 1;
	    my $newInternalPos = $savInternalPos + 1;
	    my $newc0 = substr($_[0]->{buf}, $newInternalPos, 1);
	    my $subTokenName;
	    my $subTokenValue;
	    while (1) {
		if (
		    (
		     (  $dquoteMode && $_[0]->{buf} =~ m/\G[^<&"]*/gc) ||   # Note the /c modifier
		     (! $dquoteMode && $_[0]->{buf} =~ m/\G[^<&']*/gc)      # Note the /c modifier
		    )
		    && (my $length = $+[0] - $-[0]) > 0) {
		    $_[4] .= $&;
		    $newPos += $length;
		    if (! $_[0]->_isPos($_[1], $newPos)) {
			$lastok = 0;
			last;
		    } else {
			$newInternalPos += $length;
			$newc0 = substr($_[0]->{buf}, $newInternalPos, 1);
			next;
		    }
		}
		my $subTokenValue = undef;
		foreach (qw/CHARREF ENTITYREF/) {
		    if ($MATCH{$_}($_[0], $_[1], $newPos, $newc0, $subTokenValue)) {
			$_[4] .= $subTokenValue;
			my $length = length($subTokenValue);
			$newPos += $length;
			if (! $_[0]->_isPos($_[1], $newPos)) {
			    $lastok = 0;
			} else {
			    $newInternalPos += $length;
			    $newc0 = substr($_[0]->{buf}, $newInternalPos, 1);
			}
			last;
		    }
		}
		last if (! defined($subTokenValue) || ! $lastok);
	    }
	    if ($lastok && substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq $_[3]) {
		$_[4] .= $_[3];                     # $value
		$_[2] = ++$newPos;                  # $pos
		pos($_[0]->{buf}) += 1;             # internal buffer position
		return 1;
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	}
    }
    return undef;
};

$MATCH{ENTITYVALUE} = sub {
    # my ($self, $stream, $pos, $c0, $internalPos) = @_;

    #
    # ------------------------------------------------------
    # ENTITYVALUE is /"(${REG_ENTITYVALUE_NOT_DQUOTE}|PEReference|Reference)*"/
    #             or /'(${REG_ENTITYVALUE_NOT_SQUOTE}|PEReference|Reference)*'/
    #
    # where Reference is: EntityRef | CharRef
    # and   EntityRef  is: &${NAME};
    # and   PERference is: %${NAME};
    # ------------------------------------------------------
    if (($_[3] eq '"'  && $_[0]->{buf} =~ m/\G"(?:[^<&"]|[&%][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*"/gc) ||                # Note the /c modifier
	($_[3] eq '\'' && $_[0]->{buf} =~ m/\G'(?:[^<&']|[&%][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}][:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*;|&#[0-9]+;|&#x[0-9a-fA-F]+;)*'/gc)) {                # Note the /c modifier
	$_[4] = $&;                          # $value
	$_[2] += length($_[4]);              # $pos
	# Internal position in buffer is already correct
	return 1;
    }
    elsif ($_[3] eq '"' || $_[3] eq '\'') {           # For speed
	my ($savPos, $newPos, $savInternalPos) = ($_[2], $_[2], pos($_[0]->{buf}));
	if ($_[0]->_canPos($_[1], ++$newPos)) {
	    $_[4] = $_[3];
	    my $dquoteMode = ($_[3] eq '"');
	    my $lastok = 1;
	    my $newInternalPos = $savInternalPos + 1;
	    my $newc0 = substr($_[0]->{buf}, $newInternalPos, 1);
	    my $subTokenName;
	    my $subTokenValue;
	    while (1) {
		if (
		    (
		     (  $dquoteMode && $_[0]->{buf} =~ m/\G[^<&"]*/gc) ||   # Note the /c modifier
		     (! $dquoteMode && $_[0]->{buf} =~ m/\G[^<&']*/gc)      # Note the /c modifier
		    )
		    && (my $length = $+[0] - $-[0]) > 0) {
		    $_[4] .= $&;
		    $newPos += $length;
		    if (! $_[0]->_isPos($_[1], $newPos)) {
			$lastok = 0;
			last;
		    } else {
			$newInternalPos += $length;
			$newc0 = substr($_[0]->{buf}, $newInternalPos, 1);
			next;
		    }
		}
		my $subTokenValue = undef;
		foreach (qw/CHARREF ENTITYREF PEREFERENCE/) {
		    if ($MATCH{$_}($_[0], $_[1], $newPos, $newc0, $subTokenValue)) {
			$_[4] .= $subTokenValue;
			my $length = length($subTokenValue);
			$newPos += $length;
			if (! $_[0]->_isPos($_[1], $newPos)) {
			    $lastok = 0;
			} else {
			    $newInternalPos += $length;
			    $newc0 = substr($_[0]->{buf}, $newInternalPos, 1);
			}
			last;
		    }
		}
		last if (! defined($subTokenValue) || ! $lastok);
	    }
	    if ($lastok && substr($_[0]->{buf}, pos($_[0]->{buf}), 1) eq $_[3]) {
		$_[4] .= $_[3];                     # $value
		$_[2] = ++$newPos;                  # $pos
		pos($_[0]->{buf}) += 1;             # internal buffer position
		return 1;
	    } else {
		($_[2], pos($_[0]->{buf})) = ($savPos, $savInternalPos);
		return undef;
	    }
	}
    }
    return undef;
};

$MATCH{_DISCARD} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;

    my $rc = undef;
    $_[4] = '';
    while ($_[0]->{buf} =~ m/\G\s+/gc) {     # Note the /c modifier
	$_[4] .= $&;
	last if (! $_[0]->_isPos($_[1], $_[2] += ($+[0] - $-[0])));
    }

    return $rc;
};

foreach (keys %STR) {
  my $string = $_;
  $MATCH{$string} = sub {
    # my ($self, $stream, $pos, $c0, $valuep) = @_;
    if (MarpaX::Languages::XML::AST::Grammar::XML_1_0::match
        (
         substr($_[0]->{buf}, pos($_[0]->{buf}), $STRLENGTH{$string}),
         $STR2GPERFTOK{$string}
        )
       ) {
      $_[4] = $string;                           # $value
      $_[2] += $STRLENGTH{$string};              # $pos
      pos($_[0]->{buf}) += $STRLENGTH{$string};  # internal buffer position
    } else {
      return undef;
    }
  };
}

1;
