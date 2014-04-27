#ifndef MARPAUTIL_H
#define MARPAUTIL_H

#include "marpa.h"

void marpaUtilCheckVersion();
void marpaUtilCreateGrammar(Marpa_Grammar *gp);
void marpaUtilSetSymbols(Marpa_Grammar g, int nXmlSymbolId, struct sXmlSymbolId *aXmlSymbolId);
void marpaUtilSetRule(Marpa_Grammar g, Marpa_Symbol_ID lhsId, int numRhs, Marpa_Symbol_ID *rhsIds, int min, Marpa_Symbol_ID separatorId, short properFlag, short keepFlag);
void marpaUtilSetStartSymbol(Marpa_Grammar g, Marpa_Symbol_ID symbolId);
void marpaUtilPrecomputeG(Marpa_Grammar g);

static void marpaUtilCreateGrammar(gp);

#endif /* MARPAUTIL_H */
