#ifndef MARPAUTIL_H
#define MARPAUTIL_H

#include "marpa.h"

typedef struct marpaUtil_symbolId {
  Marpa_Symbol_ID symbolId;
  const char *name;
  const char *desc;
} marpaUtil_symbolId_t;

void marpaUtil_checkVersion();
void marpaUtil_createGrammar(Marpa_Grammar *gp);
void marpaUtil_setSymbols(Marpa_Grammar g, int nSymbolId, marpaUtil_symbolId_t *aSymbolId);
void marpaUtil_setRule(Marpa_Grammar g, Marpa_Symbol_ID lhsId, int numRhs, Marpa_Symbol_ID *rhsIds, int min, Marpa_Symbol_ID separatorId, short properFlag, short keepFlag);
void marpaUtil_setStartSymbol(Marpa_Grammar g, Marpa_Symbol_ID symbolId);
void marpaUtil_precomputeG(Marpa_Grammar g);
void marpaUtil_createRegognizer(Marpa_Recognizer *rp, Marpa_Grammar g);

#endif /* MARPAUTIL_H */
