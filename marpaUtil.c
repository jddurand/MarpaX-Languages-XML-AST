#ifndef MARPAUTIL_C
#define MARPAUTIL_C

#include "xmlTypes.h"

/********************************************************
 _marpaUtilCroakIfError
 ********************************************************/
static void _marpaUtilCroakIfError(errorCode, call, forcedCondition)
     Marpa_Error_Code errorCode;
     const char *call;
     int forcedCondition;
{
  if (forcedCondition != 0 || errorCode != MARPA_ERR_NONE) {
    const char *function = (call != NULL) ? call : "<unknown>";
    const char *msg = (errorCode >= 0 && errorCode < MARPA_ERROR_COUNT) ? marpa_error_description[errorCode].name : "Generic error";
    croak("%s: %s", function, msg);
  }
}

/********************************************************
 _marpaUtilCheckVersion - unused
 ********************************************************/
static void _marpaUtilCheckVersion()
{
  unsigned int version[3];

  _marpaUtilCroakIfError(marpa_version(version), "marpa_version()", 0);
  _marpaUtilCroakIfError(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION), "marpa_check_version()", 0);
}

/********************************************************
 _marpaUtilCreateGrammar
 ********************************************************/
static void _marpaUtilCreateGrammar(gp)
     Marpa_Grammar *gp;
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
 _marpaUtilSetSymbols
 ********************************************************/
static void _marpaUtilSetSymbols(g,
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
    _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_symbol_new()", aXmlSymbolId[i].symbolId < 0);
  }
}

/********************************************************
 _marpaUtilSetRule
 ********************************************************/
static void _marpaUtilSetRule(g,
                              lhsId,
                              numRhs,
                              rhsIds,
                              min,
                              separatorId,
                              properFlag,
                              keepFlag
                              )
     Marpa_Grammar g;
     Marpa_Symbol_ID lhsId;
     int numRhs;
     Marpa_Symbol_ID *rhsIds;
     int min;
     Marpa_Symbol_ID separatorId;
     short properFlag;
     short keepFlag;
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
 _marpaUtilSetStartSymbol
 ********************************************************/
static void _marpaUtilSetStartSymbol(g,
                                     symbolId
                                     )
     Marpa_Grammar g;
     Marpa_Symbol_ID symbolId;
{
  marpa_g_error_clear(g);
  int result = marpa_g_start_symbol_set(g, symbolId);
  _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_start_symbol_set()", result < 0);

}

/********************************************************
 _marpaUtilPrecomputeG
 ********************************************************/
static void _marpaUtilPrecomputeG(g)
     Marpa_Grammar g;
{
  int result;

  marpa_g_error_clear(g);
  result = marpa_g_precompute(g);
  _marpaUtilCroakIfError(marpa_g_error(g, NULL), "marpa_g_precompute()", result < 0);
}

#endif /* MARPAUTIL_C */
