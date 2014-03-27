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
our $REG_NAMESTARTCHAR          = qr/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]/;
# $REG_NAMESTARTCHAR|[-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]
our $REG_NAMECHAR_ZERO_OR_MORE  = qr/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]*/;
our $REG_NAMECHAR_ONE_OR_MORE   = qr/\G[:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}\-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]+/;
our $REG_PUBIDCHAR_NOT_DQUOTE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]/;
our $REG_PUBIDCHAR_NOT_DQUOTE_ZERO_OR_MORE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,.\/:=\?;!\*\#\@\$_\%]*/;
our $REG_PUBIDCHAR_NOT_SQUOTE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]/;
our $REG_PUBIDCHAR_NOT_SQUOTE_ZERO_OR_MORE   = qr/\G[\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,.\/:=\?;!\*\#\@\$_\%]*/;
our $REG_CHARCOMMENT            = qr/\G[\x{9}\x{A}\x{D}\x{20}-\x{2C}\x{2E}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]/;
our $REG_CHAR                   = qr/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]/;
our $REG_CHAR_ZERO_OR_MORE      = qr/\G[\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]*/;
our $REG_S_ONE_OR_MORE          = qr/\G[\x{20}\x{9}\x{D}\x{A}]+/;
our $REG_NOT_DQUOTE             = qr/\G[^"]/;
our $REG_NOT_DQUOTE_ZERO_OR_MORE = qr/\G[^"]*/;
our $REG_NOT_SQUOTE             = qr/\G[^']/;
our $REG_NOT_SQUOTE_ZERO_OR_MORE = qr/\G[^']*/;
our $REG_CHARDATA               = qr/\G[^<&]/;
our $REG_CHARDATA_ZERO_OR_MORE  = qr/\G[^<&]*/;
our $REG_DIGIT                  = qr/\G[0-9]/;
our $REG_DIGIT_ONE_OR_MORE      = qr/\G[0-9]+/;
our $REG_HEXDIGIT               = qr/\G[0-9a-fA-F]/;
our $REG_HEXDIGIT_ONE_OR_MORE   = qr/\G[0-9a-fA-F]+/;
our $REG_ALPHA                  = qr/\G[A-Za-z]/;
our $REG_ENCNAME_REST_ZERO_OR_MORE = qr/\G[A-Za-z0-9._-]*/;
our $REG_ATTVALUE_NOT_DQUOTE    = qr/\G[^<&"]/;
our $REG_ATTVALUE_NOT_DQUOTE_ZERO_OR_MORE = qr/\G[^<&"]*/;
our $REG_ATTVALUE_NOT_SQUOTE    = qr/\G[^<&']/;
our $REG_ATTVALUE_NOT_SQUOTE_ZERO_OR_MORE  = qr/\G[^<&']*/;
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
# We always work with a single buffer, and handle eventual overlap
# by appending to current buffer before discarding it
#
sub new {
  my ($class, %opts) = @_;

  my $self = {buf => undef, mapbeg => undef, mapend => undef};

  bless($self, $class);

  return $self;
}

sub _donePos {
    my ($self, $stream, $pos) = @_;

    if ($pos >= $self->{mapend}) {
	#
	# Current buffer, eventually appended with content of next
	# buffer, is over
	#
	$stream->doneb(0);
	#
	# Assigning mapend to zero is enough for us
	# to know nothing else is cached
	#
	$self->{mapend} = 0;
    }
}

#
# For performance, everything is done one the stack
#
sub _canPos {
    # my ($self, $stream, $pos) = @_;

    if (defined($_[0]->{mapend}) && $_[2] < $_[0]->{mapend}) {
      #
      # Usually this is current buffer.
      #
      pos($_[0]->{buf}) = $_[2] - $_[0]->{mapbeg};
      return 1;
  } else {
      if (! defined($_[0]->{mapend})) {
	  #
	  # No buffer
	  #
	  ($_[0]->{buf}, $_[0]->{mapbeg}, $_[0]->{mapend}) = $_[1]->getb();
	  if (! defined($_[0]->{buf})) {
	      return undef;
	  } else {
	      return $_[0]->_canPos($_[1], $_[2]);
	  }
      } else {
	  #
	  # Need to append
	  #
	  my $append = $_[1]->substr($_[0]->{mapend}, $_[2] - $_[0]->{mapend} + 1);
	  if (defined($append)) {
	      $_[0]->{buf} .= $append;
	      $_[0]->{mapend} = $_[2]+1;
	      return $_[0]->_canPos($_[1], $_[2]);
	  } else {
	      return undef;
	  }
      }
  }

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
  # Current buffer
  #
  my $stream = MarpaX::Languages::XML::AST::StreamIn->new(input => $input);
  my $pos = 0;
  #
  # Loop until nothing left in the buffer
  #
  my $now = time();
  while (1) {

    my @tokens = ();
    my $discard = 0;
    my $value = '';
    my $maxTokenLength = 0;

    foreach (@{$recce->events()}) {
      my ($terminal) = @{$_};
      my $workpos = $pos;
      last if (! $self->_canPos($stream, $workpos));

      my $match = '';
      if ($terminal eq 'NAME' || $terminal eq 'PITARGET') {
        # ----------------------------------------------
        # NAME is /${REG_NAMESTARTCHAR}${REG_NAMECHAR}*/
        #
        # PITARGET is NAME without /xml/i
        #
        # ----------------------------------------------
        if ($self->{buf} =~ m/$REG_NAMESTARTCHAR/go) {
          next if (! $self->_canPos($stream, ++$workpos));
          $match = $&;
          my $length = 0;
          while (1) {
            last if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length)));
            last if ($self->{buf} !~ m/$REG_NAMECHAR_ZERO_OR_MORE/go);
            $length = $+[0] - $-[0];
            last if ($length <= 0);
            $match .= $&;
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
        if ($self->{buf} =~ m/$REG_ALPHA/go) {
          next if (! $self->_canPos($stream, ++$workpos));
          $match = $&;
          my $length = 0;
          while (1) {
            last if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length)));
            last if ($self->{buf} !~ m/$REG_ENCNAME_REST_ZERO_OR_MORE/go);
            $length = $+[0] - $-[0];
            last if ($length <= 0);
            $match .= $&;
          }
        }
      }
      elsif ($terminal eq 'CHARREF') {
        # ---------------------------------
        # CHARREF is /&#${REG_DIGIT}+;/
        #         or /&#x${REG_HEXDIGIT}+;/
        # ---------------------------------
        if (substr($self->{buf}, pos($self->{buf}), 1) eq '&') {
          next if (! $self->_canPos($stream, ++$workpos));
          if (substr($self->{buf}, pos($self->{buf}), 1) eq '#') {
            next if (! $self->_canPos($stream, ++$workpos));
            if (substr($self->{buf}, pos($self->{buf}), 1) eq 'x') {
              #
              # We expect ${REG_HEXDIGIT}+ followed by ';'
              #
              my $submatch = '';
              my $lastok = 1;
              while ($self->{buf} =~ m/$REG_HEXDIGIT_ONE_OR_MORE/goc) {   # Note the /c modifier
                $submatch .= $&;
                if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0])))) {
                  $lastok = 0;
                  last;
                }
              }
              if ($lastok && length($submatch) > 0) {
                if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
                  $match = "&#x${submatch};";
                }
              }
            } else {
              #
              # We expect ${REG_DIGIT}+ followed by ';'
              #
              my $submatch = '';
              my $lastok = 1;
              while ($self->{buf} =~ m/$REG_DIGIT_ONE_OR_MORE/goc) {   # Note the /c modifier
                $submatch .= $&;
                if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0])))) {
                  $lastok = 0;
                  last;
                }
              }
              if ($lastok && length($submatch) > 0) {
                if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
                  $match = "&#${submatch};";
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
          last if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0]))));
        }
      }
      elsif ($terminal eq 'NMTOKEN') {
        #
        # S is /${REG_NAMECHAR}+/
        # -----------------------
        while ($self->{buf} =~ m/$REG_NAMECHAR_ONE_OR_MORE/go) {
          $match .= $&;
          last if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0]))));
        }
      }
      elsif ($terminal eq 'SYSTEMLITERAL') {
        #
        # SYSTEMLITERAL is /"${REG_NOT_DQUOTE}*"/ or /'${REG_NOT_SQUOTE}*'/
        # ------------------------------------------------------------------
        if (substr($self->{buf}, pos($self->{buf}), 1) eq '"') {
          next if (! $self->_canPos($stream, ++$workpos));
          my $submatch = '';
          my $length = 0;
          my $lastok = 1;
          while (1) {
            if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length))) {
              $lastok = 0;
              last;
            }
            last if ($self->{buf} !~ m/$REG_NOT_DQUOTE_ZERO_OR_MORE/goc);   # Note the /c modifier
            $length = $+[0] - $-[0];
            last if ($length <= 0);
            $submatch .= $&;
          }
          if ($lastok) {
            if (substr($self->{buf}, pos($self->{buf}), 1) eq '"') {
              $match = "\"${submatch}\"";
            }
          }
        }
        elsif (substr($self->{buf}, pos($self->{buf}), 1) eq '\'') {
          next if (! $self->_canPos($stream, ++$workpos));
          my $submatch = '';
          my $length = 0;
          my $lastok = 1;
          while (1) {
            if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length))) {
              $lastok = 0;
              last;
            }
            last if ($self->{buf} !~ m/$REG_NOT_SQUOTE_ZERO_OR_MORE/goc);   # Note the /c modifier
            $length = $+[0] - $-[0];
            last if ($length <= 0);
            $submatch .= $&;
          }
          if ($lastok) {
            if (substr($self->{buf}, pos($self->{buf}), 1) eq '\'') {
              $match = "'${submatch}'";
            }
          }
        }
      }
      elsif ($terminal eq 'PUDIDLITERAL') {
        #
        # PUDIDLITERAL is /"${REG_PUBIDCHAR_NOT_DQUOTE}*"/ or /'${REG_PUBIDCHAR_NOT_SQUOTE}*'/
        # ------------------------------------------------------------------------------------
        if (substr($self->{buf}, pos($self->{buf}), 1) eq '"') {
          next if (! $self->_canPos($stream, ++$workpos));
          my $submatch = '';
          my $length = 0;
          my $lastok = 1;
          while (1) {
            if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length))) {
              $lastok = 0;
              last;
            }
            last if ($self->{buf} !~ m/$REG_PUBIDCHAR_NOT_DQUOTE_ZERO_OR_MORE/goc);   # Note the /c modifier
            $length = $+[0] - $-[0];
            last if ($length <= 0);
            $submatch .= $&;
          }
          if ($lastok) {
            if (substr($self->{buf}, pos($self->{buf}), 1) eq '"') {
              $match = "\"${submatch}\"";
            }
          }
        }
        elsif (substr($self->{buf}, pos($self->{buf}), 1) eq '\'') {
          next if (! $self->_canPos($stream, ++$workpos));
          my $submatch = '';
          my $length = 0;
          my $lastok = 1;
          while (1) {
            if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length))) {
              $lastok = 0;
              last;
            }
            last if ($self->{buf} !~ m/$REG_PUBIDCHAR_NOT_SQUOTE_ZERO_OR_MORE/goc);   # Note the /c modifier
            $length = $+[0] - $-[0];
            last if ($length <= 0);
            $submatch .= $&;
          }
          if ($lastok) {
            if (substr($self->{buf}, pos($self->{buf}), 1) eq '\'') {
              $match = "'${submatch}'";
            }
          }
        }
      }
      elsif ($terminal eq 'CHARDATA') {
        #
        # CHARDATA is /${REG_CHARDATA}*/ minus the sequence ']]>'
        # ------------------------------------------------------------------
        while ($self->{buf} =~ m/$REG_CHARDATA_ZERO_OR_MORE/go) {
          last if ($-[0] == $+[0]);
          $match .= $&;
          last if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0]))));
        }
        if (length($match) > 0) {
          if ($match =~ /\]\]>/i) {
            substr($match, $-[0]) = '';
          }
        }
      }
      elsif ($terminal eq 'CDATA' || $terminal eq 'COMMENT' || $terminal eq 'PI_INTERIOR' || $terminal eq 'IGNORE_INTERIOR') {
        #
        # CDATA           is /${REG_CHAR}*/ minus the sequence ']]>'
        # COMMENT         is /${REG_CHAR}*/ minus the sequence '--'
        # PI_INTERIOR     is /${REG_CHAR}*/ minus the sequence '?>'
        # IGNORE_INTERIOR is /${REG_CHAR}*/ minus the sequence '<![' or ']]>'
        # ------------------------------------------------------------------
        while ($self->{buf} =~ m/$REG_CHAR_ZERO_OR_MORE/go) {
          last if ($-[0] == $+[0]);
          $match .= $&;
          last if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0]))));
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
        if (substr($self->{buf}, pos($self->{buf}), 1) eq '1') {
          next if (! $self->_canPos($stream, ++$workpos));
          if (substr($self->{buf}, pos($self->{buf}), 1) eq '.') {
            next if (! $self->_canPos($stream, ++$workpos));
            while ($self->{buf} =~ m/$REG_DIGIT_ONE_OR_MORE/go) {
              $match .= $&;
              last if (! $self->_canPos($stream, ($workpos += ($+[0] - $-[0]))));
            }
          }
        }
        $match = "1.$match" if (length($match) > 0);
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
        my $c = substr($self->{buf}, pos($self->{buf}), 1);
        if ($c eq '"' || $c eq '\'') {
          next if (! $self->_canPos($stream, ++$workpos));
          my $length = 0;
          my $lastok = 1;
          $match = $c;
          while (1) {
            if (($length > 0) && ! $self->_canPos($stream, ($workpos += $length))) {
              $lastok = 0;
              last;
            }
            if ($self->{buf} =~ m/$REG_ATTVALUE_NOT_DQUOTE_ZERO_OR_MORE/goc && $-[0] != $+[0]) {  # Note the /c modifier
              $length = $+[0] - $-[0];
              $match .= $&;
            } elsif (substr($self->{buf}, pos($self->{buf}), 1) eq '&') {
		my $subworkpos = $workpos;
              last if (! $self->_canPos($stream, ++$subworkpos));
              if (substr($self->{buf}, pos($self->{buf}), 1) eq '#') {
                last if (! $self->_canPos($stream, ++$subworkpos));
                if (substr($self->{buf}, pos($self->{buf}), 1) eq 'x') {
                  #
                  # We expect ${REG_HEXDIGIT}+ followed by ';'
                  #
                  my $submatch = '';
                  my $sublastok = 1;
                  while ($self->{buf} =~ m/$REG_HEXDIGIT_ONE_OR_MORE/go) {   # Note the /c modifier
                    $submatch .= $&;
                    if (! $self->_canPos($stream, ($subworkpos += ($+[0] - $-[0])))) {
                      $sublastok = 0;
                      last;
                    }
                  }
                  if ($sublastok && length($submatch) > 0) {
                    if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
                      $match .= "&#x${submatch};";
                      $length = 4 + length($submatch);
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
                  my $sublastok = 1;
                  while ($self->{buf} =~ m/$REG_DIGIT_ONE_OR_MORE/goc) {   # Note the /c modifier
                    $submatch .= $&;
                    if (! $self->_canPos($stream, ($subworkpos += ($+[0] - $-[0])))) {
                      $sublastok = 0;
                      last;
                    }
                  }
                  if ($sublastok && length($submatch) > 0) {
                    if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
                      $match .= "&#${submatch};";
                      $length = 3 + length($submatch);
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
                my $submatch = '';
                my $sublastok = 1;
                if ($self->{buf} =~ m/$REG_NAMESTARTCHAR/go) {
                  $submatch = $&;
                  my $sublength = 1;
                  while (1) {
                    if (! $self->_canPos($stream, ($subworkpos += $sublength))) {
                      $sublastok = 0;
                      last;
                    }
                    last if ($self->{buf} !~ m/$REG_NAMECHAR_ZERO_OR_MORE/goc);   # Note the /c modifier
                    $sublength = $+[0] - $-[0];
                    last if ($sublength <= 0);
                    $submatch .= $&;
                  }
                  if ($sublastok) {
                    if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
                      $match .= "&${submatch};";
                      $length = 2 + length($submatch);
                    } else {
                      last;
                    }
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
          if ($lastok) {
            if (substr($self->{buf}, pos($self->{buf}), 1) eq $c) {
              $match .= $c;
            } else {
              $match = '';
            }
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
        my $c = substr($self->{buf}, pos($self->{buf}), 1);
        if ($c eq '&' || $c eq '%') {
          next if (! $self->_canPos($stream, ++$workpos));
          #
          # We expect ${NAME}  followed by ';'
          #
          my $submatch = '';
          my $sublastok = 1;
          if ($self->{buf} =~ m/$REG_NAMESTARTCHAR/go) {
            $submatch = $&;
            my $sublength = 1;
            while (1) {
              if (! $self->_canPos($stream, ($workpos += $sublength))) {
                $sublastok = 0;
                last;
              }
              last if ($self->{buf} !~ m/$REG_NAMECHAR_ZERO_OR_MORE/goc);   # Note the /c modifier
              $sublength = $+[0] - $-[0];
              last if ($sublength <= 0);
              $submatch .= $&;
            }
            if ($sublastok) {
              if (substr($self->{buf}, pos($self->{buf}), 1) eq ';') {
                $match = "${c}${submatch};";
              }
            }
          }
        }
      }
      elsif (exists($STR{$terminal})) {
        my $lastok = 1;
        foreach (0..length($STR{$terminal})-1) {
          if ($_ > 0 && ! $self->_canPos($stream, ++$workpos)) {
            $lastok = 0;
            last;
          }
          if (substr($self->{buf}, pos($self->{buf}), 1) ne substr($STR{$terminal}, $_, 1)) {
            $lastok = 0;
            last;
          }
        }
        if ($lastok) {
          $match = $STR{$terminal};
        }
      }

      my $tokenLength = length($match);
      if ($tokenLength > 0) {
	  if ($tokenLength > $maxTokenLength) {
	      @tokens = ($terminal);
	      $value = $match;
	      $maxTokenLength = $tokenLength;
	  } elsif ($tokenLength == $maxTokenLength) {
	      push(@tokens, $terminal);
	  }
      } else {
	  #
	  # Acceptable only if this is a discarded characters
	  #
	  pos($self->{buf}) = $pos;
          if ($self->{buf} =~ m/\G\s+/go) {
	      $discard = $+[0] - $-[0];
	  }
      }
    }
    if (@tokens) {
	foreach (@tokens) {
	    #
	    # The array is a reference to [$name, $value], where value can be undef
	    #
	    $log->tracef('pos=%6d : lexeme_alternative("%s", "%s")', $pos, $_, $value);
	    $recce->lexeme_alternative($_, $value);
	}
	$recce->lexeme_complete(0, 1);
	$pos += $maxTokenLength;
    } elsif ($discard) {
	$pos += $discard;
    } else {
	last;
    }
    if (time() - $now > 10) {
      $log->tracef('Exiting');
      exit;
    }
    $self->_donePos($stream, $pos);
  }
  print STDERR $recce->show_progress;
  my $nvalue = 0;
  while (defined($_ = $recce->value)) {
      ++$nvalue;
      #$log->tracef('Value %d: %s', $nvalue, $_);
  }
  $log->tracef('Total number of values: %d', $nvalue);
}


# -----------------------------------------------------------------------
# TOKEN closures
# Arguments are always: ($stream, $pos)
# -----------------------------------------------------------------------
our %TOKEN = ();

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
	  #$stream->$TOKEN_ENTITYREF_CLOSURE(@_),
	  # CharRef
	  #$stream->$TOKEN_CHARREF_CLOSURE(@_),
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
	       #$stream->$TOKEN_PEREFERENCE_CLOSURE(@_),
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
	       #$stream->$TOKEN_PEREFERENCE_CLOSURE(@_),
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
