#include <stdlib.h>
#include <errno.h>
#include "marpaAbstract.h"
#include "marpa.h"

struct marpaAbstract {
  marpaAbstractFailureCallback_t failureCallbackPtr;
  marpaAbstractTraceCallback_t   traceCallbackPtr;
};

s_marpaAbstract_t *marpaAbstract_new(marpaAbstract_option_t *optionp)
{
  const char *function = "marpaAbstract_new";

  s_marpaAbstract_t self = malloc(sizeof(s_marpaAbstract_t));

  if (self == NULL) {
    if (optionp != NULL && optionp->failureCallbackPtr != NULL) {
      (*(optionp->failureCallbackPtr))(__FILE__, __LINE__, function, "%s, %s", "malloc() call failed", strerror(errno));
      return NULL;
    }
  }

  self->failureCallbackPtr = (optionp != NULL) ? optionp->failureCallbackPtr : NULL;
  self->traceCallbackPtr   = (optionp != NULL) ? optionp->traceCallbackPtr : NULL;

  return self;
}

