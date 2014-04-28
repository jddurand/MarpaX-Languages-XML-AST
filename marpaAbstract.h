#ifndef MARPAABSTRACT_H
#define MARPAABSTRACT_H

typedef struct marpaAbstract marpaAbstract_t;

typedef void (*marpaAbstractFailureCallback_t)(const char *file, int line, int errnum, const char *function);
typedef void (*marpaAbstractTraceCallback_t)(const char *file, int line, const char *function, const char *format, ...);
typedef void (*marpaAbstractEventCallback_t)(int eventCode, int eventValue, const char *symbol, void *userDatap);

typedef struct marpaAbstract_symbol {
  const char *name;
  marpaAbstractEventCallback_t *eventCallback;
} marpaAbstract_symbol_t;

typedef struct marpaAbstract_rule {
  const char *name;
  int nSymbol;
  const char **symbolsp;
  const char *separatorSymbol;
  short properb;
  short keepb;
  marpaAbstractEventCallback_t *eventCallback;
} marpaAbstract_rule_t;

s_marpaAbstract_ *marpaAbstract_new();
void marpaAbstract_destroy(s_marpaAbstract_ **selfpp);
void marpaAbstract_grammar(s_marpaAbstract_ *selfp, unsigned int nRule, marpaAbstract_rule_t *rulep);
#endif /* MARPAABSTRACT_H */
