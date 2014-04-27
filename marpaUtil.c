#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "marpaUtil.h"
/* We include marpa_slif.h because it contains very handy definition e.g. marpa_error_description[], etc... */
#include "marpa_slif.h"

/********************************************************
 _marpaUtilCroakIfError
 ********************************************************/
static void _marpaUtilCroakIfError(Marpa_Error_Code errorCode, const char *call, int forcedCondition)
{
  if (forcedCondition != 0 || errorCode != MARPA_ERR_NONE) {
    const char *function = (call != NULL) ? call : "<unknown>";
    const char *msg = (errorCode >= 0 && errorCode < MARPA_ERROR_COUNT) ? marpa_error_description[errorCode].name : "Generic error";
    croak("%s: %s", function, msg);
  }
}

/********************************************************
 marpaUtilCheckVersion - unused
 ********************************************************/
void marpaUtilCheckVersion()
{
  unsigned int version[3];

  _marpaUtilCroakIfError(marpa_version(version), "marpa_version()", 0);
  _marpaUtilCroakIfError(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION), "marpa_check_version()", 0);
}

/********************************************************
 marpaUtilCreateGrammar
 ********************************************************/
void marpaUtilCreateGrammar(Marpa_Grammar *gp)
{
  Marpa_Config marpa_configuration;
  Marpa_Grammar g;

  /* Configuration initialisation */
  marpa_c_init(&marpa_configuration);     /* never fails as per the doc */

  /* Grammar creation */
  g = marpa_g_new(&marpa_configuration);
  _marpaUtilCroakIfError(marpa_c_error(&marpa_configuration, NULL), "marpa_g_new()", g == NULL);

  *gp = g;
}

/********************************************************
 marpaUtilSetSymbols
 ********************************************************/
void marpaUtilSetSymbols(Marpa_Grammar g, int nSymbolId, struct sSymbolId *aSymbolId)
{
  int i;
  Marpa_Symbol_ID symbolId;

  for (i = 0; i < nSymbolId; i++) {
    marpa_g_error_clear(g);
    aSymbolId[i].symbolId = marpa_g_symbol_new(g);
    _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_symbol_new()", aSymbolId[i].symbolId < 0);
  }
}

/********************************************************
 marpaUtilSetRule
 ********************************************************/
void marpaUtilSetRule(Marpa_Grammar g, Marpa_Symbol_ID lhsId, int numRhs, Marpa_Symbol_ID *rhsIds, int min, Marpa_Symbol_ID separatorId, short properFlag, short keepFlag)
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
  _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_rule_new()", ruleId < 0);

}

/********************************************************
 marpaUtilSetStartSymbol
 ********************************************************/
void marpaUtilSetStartSymbol(Marpa_Grammar g, Marpa_Symbol_ID symbolId)
{
  marpa_g_error_clear(g);
  int result = marpa_g_start_symbol_set(g, symbolId);
  _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_start_symbol_set()", result < 0);

}

/********************************************************
 marpaUtilPrecomputeG
 ********************************************************/
void marpaUtilPrecomputeG(Marpa_Grammar g)
{
  int result;

  marpa_g_error_clear(g);
  result = marpa_g_precompute(g);
  _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_precompute()", result < 0);
}
