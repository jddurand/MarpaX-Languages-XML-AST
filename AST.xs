#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* We include marpa_slif.h instead of marpa.h, because it contains  */
/* the very handy definition of marpa_error_description[], compiled */
/* in marpa_codes.c                                                 */
#include "marpa_slif.h"
#include "xml10.h"

typedef struct sXmlToken
{
  int name;
  char *value;
} sXmlToken_;

typedef struct sXmlSymbolId {
  Marpa_Symbol_ID symbolId;
  int symbolIdEnum;
  const char *name;
} sXmlSymbolId_;

/*****************
 * _croakIfError *
 *****************/

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

/****************
 * _check_marpa *
 ****************/

static void _check_marpa()
{
  unsigned int version[3];

  _croakIfError(marpa_version(version), "marpa_version()", 0);
  _croakIfError(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION), "marpa_check_version()", 0);
}

/************
 * _createG *
 ************/

static void _createG(gp)
     Marpa_Grammar *gp;
{
  Marpa_Config marpa_configuration;
  Marpa_Grammar g;

  _check_marpa();

  marpa_c_init(&marpa_configuration);     /* This function never fails as per the doc */

  g = marpa_g_new(&marpa_configuration);
  _croakIfError(marpa_c_error(&marpa_configuration, NULL), "marpa_g_new()", g == NULL);
  *gp = g;
}

/**********
 * _fillG *
 **********/

static void _fillG(&gp)
     Marpa_Grammar *gp;
{
}

MODULE = MarpaX::Languages::XML::AST  PACKAGE = MarpaX::Languages::XML::AST

PROTOTYPES: DISABLE

void
createG10()
PPCODE:
{
  Marpa_Grammar gxml10;
  SV *sv;

  _createG(&gxml10);
  sv = sv_newmortal();
  sv_setref_pv (sv, "MarpaX::Languages::XML::AST::XML10::G", (void *) gxml10);
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
  const struct s_xml_token *xml_token = NULL; // in_word_set_xml10(buf + offset, len);
    if (xml_token == 0 || strcmp(xml_token->value, wanted) != 0) {
      XSRETURN_UNDEF;
    }
    XSRETURN_YES;
