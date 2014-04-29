#ifndef MARPAABSTRACT_H
#define MARPAABSTRACT_H

/*
  Abstract is divided in the three main steps from an application point of view:
  - Grammar
  - Parse
  - Value
*/

/*************************
   Opaque object types
 *************************/
typedef struct marpaAbstract        marpaAbstract_t;
typedef struct marpaAbstractGrammar marpaAbstractGrammar_t;
typedef struct marpaAbstractParse   marpaAbstractParse_t;
typedef struct marpaAbstractValue   marpaAbstractValue_t;

/*************************
   Callback types
 *************************/
typedef void (*marpaAbstractFailureCallback_t)(const char *file, int line, const char *function, const char *format, ...);
typedef void (*marpaAbstractTraceCallback_t)  (const char *file, int line, const char *function, const char *format, ...);
typedef void (*marpaAbstractEventCallback_t)  (int eventCode, int eventValue, const char *symbol, void *userDatap);

/*************************
   Options
 *************************/
typedef struct marpaAbstract_option {
  marpaAbstractFailureCallback_t failureCallbackPtr;
  marpaAbstractTraceCallback_t   traceCallbackPtr;
} marpaAbstract_option_t;

/*************************
   Grammar abstraction
 *************************/
typedef struct marpaAbstract_symbol {
  const char                   *name;
  marpaAbstractEventCallback_t *eventCallback;
} marpaAbstract_symbol_t;

typedef struct marpaAbstract_rule {
  const char                   *name;
  int                           nRhs;
  const char                  **rhsNamesp;
  const char                   *separatorName;
  short                         properb;
  short                         keepb;
  marpaAbstractEventCallback_t *eventCallback;
} marpaAbstract_rule_t;

/*************************
   Main object Methods
 *************************/
s_marpaAbstract_t        *marpaAbstract_new(marpaAbstract_option_t *optionp);
void                      marpaAbstract_destroy(s_marpaAbstract_ **selfpp);

/*************************
   Grammar Methods
 *************************/
s_marpaAbstractGrammar_t *marpaAbstractGrammar_new(s_marpaAbstract_t *selfp);
short                    *marpaAbstractGrammar_set(s_marpaAbstractGrammar_t *selfGrammarp, unsigned int nRule, marpaAbstract_rule_t *rulep);
void                      marpaAbstractGrammar_destroy(s_marpaAbstractGrammar_ **selfGrammarpp);

/*************************
   Parse Methods
 *************************/
s_marpaAbstractParse_t   *marpaAbstractParse_new(s_marpaAbstractGrammar_t *selfGrammarp);
short                    *marpaAbstractParse_parse(s_marpaAbstractParse_t *selfParsep, const char *input);
void                      marpaAbstractParse_destroy(s_marpaAbstractParse_ **selfParsepp);

/*************************
   Value Methods
 *************************/
s_marpaAbstractValue_t   *marpaAbstractValue_new(s_marpaAbstractParse_t *selfParsep);
short                     marpaAbstractValue_get(s_marpaAbstractValue_ *selfValuep);
void                      marpaAbstractValue_destroy(s_marpaAbstractValue_ **selfValuepp);

/*************************
   Expert methods
 *************************/
/* In case the caller would like to play itself with Marpa. He will HAVE to recast outputs to Marpa_Grammar, etc... */
void *marpaAbstract_getMarpa_Grammar   (s_marpaAbstractGrammar_ *selfGrammarp);
void *marpaAbstract_getMarpa_Recognizer(s_marpaAbstractParse_ *selfParsep);
void *marpaAbstract_getMarpa_Bocage    (s_marpaAbstractValue_ *selfValuep);
void *marpaAbstract_getMarpa_Order     (s_marpaAbstractValue_ *selfValuep);
void *marpaAbstract_getMarpa_Tree      (s_marpaAbstractValue_ *selfValuep);
void *marpaAbstract_getMarpa_Value     (s_marpaAbstractValue_ *selfValuep);

#endif /* MARPAABSTRACT_H */
