use strict;
use warnings FATAL => 'all';

package MarpaX::Languages::XML::AST::Grammar::XML_1_0;;

# ABSTRACT: XML-1-0. Extensible Markup Language (XML) 1.0 (Fifth Edition) written in Marpa BNF

# VERSION

our $DATA = local {$/; <DATA>};

1;
__DATA__
:lexeme ~ <X20>
:lexeme ~ <CHAR>
:lexeme ~ <S>             pause => before event => '^S'
:lexeme ~ <NAME>
:lexeme ~ <NMTOKEN>
:lexeme ~ <SYSTEMLITERAL>
:lexeme ~ <PUBIDLITERAL>
:lexeme ~ <CHARDATA>      pause => before event => '^CHARDATA'
:lexeme ~ <COMMENT_STAG>
:lexeme ~ <COMMENT_ETAG>
:lexeme ~ <COMMENT>
:lexeme ~ <PI_STAG>
:lexeme ~ <PI_ETAG>
:lexeme ~ <PITTARGET>     pause => before event => '^PITARGET'
:lexeme ~ <PI_INTERIOR>   pause => before event => '^PI_INTERIOR'
:lexeme ~ <CDSTART>
:lexeme ~ <CDEND>

document      ::= prolog element Misc*
Char          ::= CHAR
Name          ::= NAME
Names         ::= Name+ separator => x20
Nmtoken       ::= NMTOKEN
Nmtokens      ::= Nmtoken+ separator => x20
EntityValue   ::= DQUOTE EntityValue_interior_dquote_unit_any DQUOTE
                | SQUOTE EntityValue_interior_squote_unit_any SQUOTE
AttValue      ::= DQUOTE AttValue_interior_dquote_unit_any DQUOTE
                | SQUOTE AttValue_interior_squote_unit_any SQUOTE
SystemLiteral ::= SYSTEMLITERAL
PubidLiteral  ::= PUDIDLITERAL
CharData      ::= CHARDATA
Comment       ::= COMMENT_STAG COMMENT COMMENT_ETAG
PITarget      ::= PITARGET
PI            ::= PI_STAG PITarget               PI_ETAG
                | PI_STAG PITarget S PI_INTERIOR PI_ETAG
CDSect        ::= CDSTART CData CDEND
CData         ::= CHARDATA*
#
# G1 helpers
#
x20      ::= X20
EntityValue_interior_dquote_unit ::= [^%&"] | PEReference | Reference       # " for my editor
EntityValue_interior_dquote_unit_any ::= EntityValue_interior_dquote_unit* 
EntityValue_interior_squote_unit ::= [^%&'] | PEReference | Reference       # ' for my editor
EntityValue_interior_squote_unit_any ::= EntityValue_interior_squote_unit*
AttValue_interior_dquote_unit ::= [^<&"] | Reference                        # " for my editor
AttValue_interior_dquote_unit_any ::= AttValue_interior_dquote_unit*
AttValue_interior_squote_unit ::= [^<&'] | Reference                        # ' for my editor
AttValue_interior_squote_unit_any ::= AttValue_interior_squote_unit*
#
# G0 helpers
#
_NAMESTARTCHAR ~ [:A-Z_a-z\x{C0}-\x{D6}\x{D8}-\x{F6}\x{F8}-\x{2FF}\x{370}-\x{37D}\x{37F}-\x{1FFF}\x{200C}-\x{200D}\x{2070}-\x{218F}\x{2C00}-\x{2FEF}\x{3001}-\x{D7FF}\x{F900}-\x{FDCF}\x{FDF0}-\x{FFFD}\x{10000}-\x{EFFFF}]
_NAMECHAR      ~ _NAMESTARTCHAR
               | [-.0-9\x{B7}\x{0300}-\x{036F}\x{203F}-\x{2040}]
_NAMECHAR_ANY ~ _NAMECHAR*
_NAMECHAR_MANY ~ _NAMECHAR+
_DQUOTE ~ '"'
_SQUOTE ~ [']                                                               # ' for my editor
_SYSTEMLITERAL_INTERIOR_DQUOTE_UNIT ~ [^"]                                  # " for my editor
_SYSTEMLITERAL_INTERIOR_DQUOTE_UNIT_ANY ~ _SYSTEMLITERAL_INTERIOR_DQUOTE_UNIT*
_SYSTEMLITERAL_INTERIOR_SQUOTE_UNIT ~ [^']                                  # ' for my editor
_SYSTEMLITERAL_INTERIOR_SQUOTE_UNIT_ANY ~ _SYSTEMLITERAL_INTERIOR_SQUOTE_UNIT*
_PUDIDCHAR_DQUOTE ~ [\x{20}\x{D}\x{A}a-zA-Z0-9\-'()+,./:=?;!*#@$_%]         # ' for my editor
_PUDIDCHAR_SQUOTE ~ [\x{20}\x{D}\x{A}a-zA-Z0-9\-()+,./:=?;!*#@$_%]          # / for my editor
_PUDIDCHAR_DQUOTE_ANY ~ _PUDIDCHAR_DQUOTE*
_PUDIDCHAR_SQUOTE_ANY ~ _PUDIDCHAR_SQUOTE*
_COMMENTCHAR ~ [\x{9}\x{A}\x{D}\x{20}-\x{2C}\x{2E}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]
#
# Lexemes that do not need special processing
#
CHAR        ~ [\x{9}\x{A}\x{D}\x{20}-\x{D7FF}\x{E000}-\x{FFFD}\x{10000}-\x{10FFFF}]
NAME        ~ _NAMESTARTCHAR _NAMECHAR_ANY
NMTOKEN     ~ _NAMECHAR_MANY
X20    ~ [\x{20}]
SYSTEMLITERAL ~ _DQUOTE _SYSTEMLITERAL_INTERIOR_DQUOTE_UNIT_ANY _DQUOTE
              | _SQUOTE _SYSTEMLITERAL_INTERIOR_SQUOTE_UNIT_ANY _SQUOTE
PUDIDLITERAL ~ _DQUOTE _PUDIDCHAR_DQUOTE_ANY _DQUOTE
             | _SQUOTE _PUDIDCHAR_SQUOTE_ANY _SQUOTE
COMMENT_STAG ~ '<!--'
COMMENT_ETAG ~ '-->'
COMMENT  ~ _COMMENTCHAR*
PI_STAG ~ '<?'
PI_ETAG ~ '?>'
CDSTART ~ '<![CDATA['
CDEND ~ ']]>'
#
# Dummy lexemes: some EBNF exclusions will be done programmatically
#
S           ~ [\s\S]
CHARDATA    ~ [\s\S]
PITARGET    ~ [\s\S]
PI_INTERIOR ~ [\s\S]
