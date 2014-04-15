#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
/* We include marpa_slif.h instead of marpa.h, because it contains  */
/* very handy definition e.g. marpa_error_description[], etc...     */
#include "marpa_slif.h"
#include "xmlTypes.h"
#include "xml10.h"

struct s_xml_token
{
  int name;
  char *value;
};

#include "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.c"

#undef ARRAY_LENGTH
#define ARRAY_LENGTH(array) (sizeof((array))/sizeof((array)[0]))

/********************************************************
 _croakIfError
 ********************************************************/
static void _croakIfError(errorCode, call, forcedCondition)
     Marpa_Error_Code errorCode;
     const char *call;
     int forcedCondition;
{
  if (forcedCondition != 0 || errorCode != MARPA_ERR_NONE) {
    const char *function = (call != NULL) ? call : "<unknown>";
    const char *msg = (errorCode >= 0 && errorCode < MARPA_ERROR_COUNT) ? marpa_error_description[errorCode].name : "Generic error";
    croak ("%s: %s", function, msg);
  }
}

/********************************************************
 _checkMarpaVersion - unused
 ********************************************************/
static void _checkMarpaVersion()
{
  unsigned int version[3];

  _croakIfError(marpa_version(version), "marpa_version()", 0);
  _croakIfError(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION), "marpa_check_version()", 0);
}

/********************************************************
 _createG
 ********************************************************/
static void _createG(gp)
     Marpa_Grammar *gp;
{
  Marpa_Config marpa_configuration;
  Marpa_Grammar g;

  /* Configuration initialisation */
  marpa_c_init(&marpa_configuration);     /* never fails as per the doc */

  /* Grammar creation */
  g = marpa_g_new(&marpa_configuration);
  _croakIfError(marpa_c_error(&marpa_configuration, NULL), "marpa_g_new()", g == NULL);

  *gp = g;
}

/********************************************************
 _fillG
 ********************************************************/
static void _fillG(g,
                   nXmlSymbolId, aXmlSymbolId           /* Symbols */
                   )
     Marpa_Grammar g;
     int nXmlSymbolId;
     struct sXmlSymbolId *aXmlSymbolId;
{
  int i;
  Marpa_Symbol_ID symbolId;

  for (i = 0; i < nXmlSymbolId; i++) {
    marpa_g_error_clear(g);
    aXmlSymbolId[i].symbolId = marpa_g_symbol_new(g);
    _croakIfError(marpa_g_error(g, NULL), "marpa_g_symbol_new()", aXmlSymbolId[i].symbolId < 0);
  }
}

/********************************************************
                        XS
 ********************************************************/
MODULE = MarpaX::Languages::XML::AST  PACKAGE = MarpaX::Languages::XML::AST

PROTOTYPES: DISABLE

void
newG10()
PPCODE:
{
  Marpa_Grammar gXml10;
  SV *sv;

  _createG(&gXml10);
  _fillG(gXml10, ARRAY_LENGTH(aXml10SymbolId), aXml10SymbolId);

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
    const struct s_xml_token *xml_token = in_word_set_xml10(buf + offset, len);
    if (xml_token == 0 || strcmp(xml_token->value, wanted) != 0) {
      XSRETURN_UNDEF;
    }
    XSRETURN_YES;
