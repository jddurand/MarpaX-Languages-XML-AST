#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

struct s_xml_token
{
  int name;
  char *value;
};

#include "marpaUtil.c"
#include "xml10.c"

/********************************************************
                        XS
 ********************************************************/
MODULE = MarpaX::Languages::XML::AST  PACKAGE = MarpaX::Languages::XML::AST

PROTOTYPES: DISABLE

void
newG10()
PPCODE:
{
  Marpa_Grammar gXml10 = _xml10CreateGrammar();
  SV *sv;

  sv = sv_newmortal();
  sv_setref_pv (sv, "MarpaX::Languages::XML::AST::XML10::G", (void *) gXml10);
  XPUSHs (sv);
}

# The first argument should be the buffer. No matter in case of multi-byte stuff, all
# tokens expected are in the ASCII range. A multi-byte will simply not match.
# The second argument is the length to take from the buffer (the generated hash
# function is doing an strncmp, so no problem if buffer does not have so many character
# or is longer.
# The third argument is the wanted token name.
#
void
match(buf, offset, len, wanted)
    const char *buf
    STRLEN offset
    STRLEN len
    const char *wanted
  PROTOTYPE: $$
  PPCODE:
    const struct s_xml_token *xml_token = NULL; /* in_word_set_xml10(buf + offset, len); */
    if (xml_token == 0 || strcmp(xml_token->value, wanted) != 0) {
      XSRETURN_UNDEF;
    }
    XSRETURN_YES;
