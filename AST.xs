#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

struct s_xml_token
{
  int name;
  char *value;
};

#include "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.c"

MODULE = MarpaX::Languages::XML::AST  PACKAGE = MarpaX::Languages::XML::AST::Grammar::XML_1_0

PROTOTYPES: DISABLE

# The first argument should be the buffer. No matter in case of multi-byte stuff, all
# tokens expected are in the ASCII range. A multi-byte will simply not match.
# The second argument is the length to take from the buffer (the generated hash
# function is doing an strncmp, so no problem if buffer does not have so many character
# or is longer.
# The third argument is the wanted token name.
#
void
match(sv, wanted)
    SV *sv
    const char *wanted
  PROTOTYPE: $$
  PPCODE:
    STRLEN len;
    char *s;
    s = SvPV(sv, len);
    const struct s_xml_token *xml_token = in_word_set_xml10(s, len);
    if (xml_token == 0 || strcmp(xml_token->value, wanted) != 0) {
      XSRETURN_UNDEF;
    }
    XSRETURN_YES;
