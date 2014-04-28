#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "marpaUtil.h"
/* We include marpa_slif.h because it contains very handy definition e.g. marpa_error_description[], etc... */
#include "marpa_slif.h"

/********************************************************
 _marpaUtil_croakIfError
 ********************************************************/
static void _marpaUtil_croakIfError(Marpa_Error_Code errorCode, const char *call, int forcedCondition)
{
  if (forcedCondition != 0 || errorCode != MARPA_ERR_NONE) {
    const char *function = (call != NULL) ? call : "<unknown>";
    const char *msg = (errorCode >= 0 && errorCode < MARPA_ERROR_COUNT) ? marpa_error_description[errorCode].name : "Generic error";
    croak("%s: %s", function, msg);
  }
}

/********************************************************
 marpaUtil_checkVersion
 ********************************************************/
void marpaUtil_checkVersion()
{
  unsigned int version[3];

  _marpaUtil_croakIfError(marpa_version(version), "marpa_version()", 0);
  _marpaUtil_croakIfError(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION), "marpa_check_version()", 0);
}

/********************************************************
 marpaUtil_createGrammar
 ********************************************************/
void marpaUtil_createGrammar(Marpa_Grammar *gp)
{
  Marpa_Config marpa_configuration;
  Marpa_Grammar g;

  /* Configuration initialisation */
  marpa_c_init(&marpa_configuration);     /* never fails as per the doc */

  /* Grammar creation */
  g = marpa_g_new(&marpa_configuration);
  _marpaUtil_croakIfError(marpa_c_error(&marpa_configuration, NULL), "marpa_g_new()", g == NULL);

  *gp = g;
}

/********************************************************
 marpaUtil_setSymbols
 ********************************************************/
void marpaUtil_setSymbols(Marpa_Grammar g, int nSymbolId, marpaUtil_symbolId_t *aSymbolId)
{
  int i;
  Marpa_Symbol_ID symbolId;

  for (i = 0; i < nSymbolId; i++) {
    marpa_g_error_clear(g);
    aSymbolId[i].symbolId = marpa_g_symbol_new(g);
    _marpaUtil_croakIfError(marpa_g_error(g, NULL), "marpa_g_symbol_new()", aSymbolId[i].symbolId < 0);
  }
}

/********************************************************
 marpaUtil_setRule
 ********************************************************/
void marpaUtil_setRule(Marpa_Grammar g, Marpa_Symbol_ID lhsId, int numRhs, Marpa_Symbol_ID *rhsIds, int min, Marpa_Symbol_ID separatorId, short properFlag, short keepFlag)
{
  Marpa_Rule_ID ruleId;

  if (min < 0) {
    ruleId = marpa_g_rule_new(g, lhsId, rhsIds, numRhs);
  } else {
    int flags = 0;

    if (min != 0 && min != 1) {
      croak("Creation of a sequence with a minimum that is %d, should be 0 or 1", min);
    }
    if (numRhs != 1) {
      croak("Creation of a sequence with a number of RHS that is %d, should be 1", numRhs);
    }
    if (properFlag != 0) {
      flags |= MARPA_PROPER_SEPARATION;
    }
    if (keepFlag != 0) {
      flags |= MARPA_KEEP_SEPARATION;
    }
    ruleId = marpa_g_sequence_new (g, lhsId, rhsIds[0], separatorId, min, flags);
  }
  _marpaUtil_croakIfError(marpa_g_error(g, NULL), "marpa_g_rule_new()", ruleId < 0);

}

/********************************************************
 marpaUtil_setStartSymbol
 ********************************************************/
void marpaUtil_setStartSymbol(Marpa_Grammar g, Marpa_Symbol_ID symbolId)
{
  marpa_g_error_clear(g);
  int result = marpa_g_start_symbol_set(g, symbolId);
  _marpaUtil_croakIfError(marpa_g_error(g, NULL), "marpa_g_start_symbol_set()", result < 0);

}

/********************************************************
 marpaUtil_precomputeG
 ********************************************************/
void marpaUtil_precomputeG(Marpa_Grammar g)
{
  int result;

  marpa_g_error_clear(g);
  result = marpa_g_precompute(g);
  _marpaUtil_croakIfError(marpa_g_error(g, NULL), "marpa_g_precompute()", result < 0);
}

/********************************************************
 marpaUtil_createRegognizer
 ********************************************************/
void marpaUtil_createRegognizer(Marpa_Recognizer *rp, Marpa_Grammar g)
{
  Marpa_Recognizer r;

  marpa_g_error_clear(g);
  r = marpa_r_new(g);
  _marpaUtil_croakIfError(marpa_g_error(g, NULL), "marpa_r_new()", r == NULL);

  *rp = r;
}

/********************************************************
 marpaUtil_startInput
 ********************************************************/
void marpaUtil_startInput(Marpa_Grammar g, Marpa_Recognizer r)
{
  int rc;

  marpa_g_error_clear(g);
  rc = marpa_r_start_input(r);
  _marpaUtil_croakIfError(marpa_g_error(g, NULL), "marpa_r_new()", rc < 0);
}

/********************************************************
 marpaUtil_alternative
 ********************************************************/
void marpaUtil_alternative(Marpa_Grammar g, Marpa_Recognizer r, Marpa_Symbol_ID tokenId, int value, int length)
{
  int rc;

  marpa_g_error_clear(g);
  rc = marpa_r_alternative(r, tokenId, value, length);
  _check(marpa_g_error((g), NULL), "marpa_r_alternative()", rc != MARPA_ERR_NONE);
}

/********************************************************
 marpaUtil_earlemeComplete
 ********************************************************/
void marpaUtil_earlemeComplete(Marpa_Grammar g, Marpa_Recognizer r)
{
  int rc;

  marpa_g_error_clear(g);
  rc = marpa_r_earleme_complete(r);
  _check(marpa_g_error((g), NULL), "marpa_r_earleme_complete()", rc < 0);
}
