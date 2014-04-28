/*
 * Variation on http://rosettacode.org/wiki/Stack
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include "genericStack.h"

#define STACK_INIT_SIZE 4

struct genericStack {
  void                         **buf;
  size_t                         allocSize;
  size_t                         stackSize;
  size_t                         elementSize;
  genericStack_failureCallback_t failureCallback;
  genericStack_freeCallback_t    freeCallback;
  genericStack_copyCallback_t    copyCallback;
  short                          optionGrowOnSet;
  short                          optionGrowOnGet;
};

/*************************
   genericStack_new
 *************************/
genericStack_t *genericStack_new(size_t elementSize, genericStack_option_t *optionp);
{
  const static char *function = "genericStackCreate";
  genericStack_t    *genericStackPtr;
  unsigned int       i;

  if (elementSize <= 0) {
    if (genericStack_failureCallbackPtr != NULL) {
      (*genericStack_failureCallbackPtr)(__FILE__, __LINE__, function, "%s", "Function parameter check failed");
    }
    return NULL;
  }

  genericStackPtr = malloc(sizeof(genericStack_t));
  if (genericStackPtr == NULL) {
    if (genericStack_failureCallbackPtr != NULL) {
      (*genericStack_failureCallbackPtr)(__FILE__, __LINE__, function, "%s: %s", "malloc() call failed", strerror(errno));
    }
    return NULL;
  }
  genericStackPtr->buf = malloc(elementSize * STACK_INIT_SIZE);
  if (genericStackPtr->buf == NULL) {
    if (genericStack_failureCallbackPtr != NULL) {
      (*genericStack_failureCallbackPtr)(__FILE__, __LINE__, errno, function, "malloc() call failed");
    }
    free(genericStackPtr);
    return NULL;
  }
  for (i = 0; i < STACK_INIT_SIZE; i++) {
    genericStackPtr->buf[i] = NULL;
  }

  genericStackPtr->allocSize       = STACK_INIT_SIZE;
  genericStackPtr->stackSize       = 0;
  genericStackPtr->elementSize     = elementSize;
  genericStackPtr->copyCallback    = optionp != NULL ? optionp->genericStack_copyCallbackPtr : NULL;
  genericStackPtr->freeCallback    = optionp != NULL ? optionp->genericStack_freeCallbackPtr : NULL;
  genericStackPtr->failureCallback = optionp != NULL ? optionp->genericStack_failureCallbackPtr : NULL;
  genericStackPtr->optionGrowOnGet = optionp != NULL ? (((optionp->growFlags & GENERICSTACK_OPTION_GROW_ON_GET) == GENERICSTACK_OPTION_GROW_ON_GET) ? 1 : 0) : 0;
  genericStackPtr->optionGrowOnSet = optionp != NULL ? (((optionp->growFlags & GENERICSTACK_OPTION_GROW_ON_SET) == GENERICSTACK_OPTION_GROW_ON_SET) ? 1 : 0) : 0;

  return genericStackPtr;
}

/*************************
   genericStack_destroy
 *************************/
void genericStack_destroy(genericStack_t **genericStackPtrPtr)
{
  const static char *function = "genericStackFree()";
  genericStack_t *genericStackPtr;
  unsigned int i;

  if (genericStackPtrPtr == NULL) {
    return;
  }
  genericStackPtr = *genericStackPtrPtr;
  if (genericStackPtr == NULL) {
    return;
  }

  /* genericStackPtr->allocSize is always > 0 per def */
  for (i = 0; i < genericStackPtr->allocSize; i++) {
    if (genericStackPtr->buf[i] != NULL) {
      if (genericStackPtr->freeCallback != NULL) {
	int errnum = (*(genericStackPtr->freeCallback))(genericStackPtr->buf[i]);
	if (errnum != 0) {
	  if (genericStackPtr->failureCallback != NULL) {
	    (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errnum, function, "freeCallback() call failed");
	  }
	}
      }
      free(genericStackPtr->buf[i]);
      genericStackPtr->buf[i] = NULL;
    }
  }

  free(genericStackPtr->buf);
  free(genericStackPtr);

  *genericStackPtrPtr = NULL;
  return;
}

/*************************
   genericStack_push
 *************************/
size_t genericStack_push(genericStack_t *genericStackPtr, void *elementPtr)
{
  const static char *function = "genericStackPush()";
  unsigned int i;

  if (genericStackPtr == NULL) {
    return 0;
  }

  if (genericStackPtr->stackSize >= genericStackPtr->allocSize) {
    size_t allocSize = genericStackPtr->allocSize * 2;
    void **buf;

    buf = realloc(genericStackPtr->buf, allocSize * sizeof(void *));
    if (buf == NULL) {
      if (genericStackPtr->failureCallback != NULL) {
	(*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errno, function, "realloc() call failed");
      }
      return 0;
    }
    genericStackPtr->buf = buf;
    for (i = genericStackPtr->allocSize; i < allocSize; i++) {
      genericStackPtr->buf[i] = NULL;
    }
    genericStackPtr->allocSize = allocSize;
  }
  if (elementPtr != NULL) {
    void *newElementPtr = malloc(genericStackPtr->elementSize);
    if (newElementPtr == NULL) {
      if (genericStackPtr->failureCallback != NULL) {
	(*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errno, function, "malloc() call failed");
      }
      return 0;
    }
    memcpy(newElementPtr, elementPtr, genericStackPtr->elementSize);
    if (genericStackPtr->copyCallback != NULL) {
      int errnum = (*(genericStackPtr->copyCallback))(newElementPtr, elementPtr);
      if (errnum != 0) {
	if (genericStackPtr->failureCallback != NULL) {
	  (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errnum, function, "copyCallback() call failed");
	}
      }
    }
    genericStackPtr->buf[genericStackPtr->stackSize] = newElementPtr;
  } else {
    genericStackPtr->buf[genericStackPtr->stackSize] = NULL;
  }
  genericStackPtr->stackSize++;

  return 1;
}

/*************************
   genericStack_pop
 *************************/
void  *genericStack_pop(genericStack_t *genericStackPtr)
{
  const static char *function = "genericStackPop()";
  void *value;

  if (genericStackPtr == NULL) {
    return NULL;
  }

  if (genericStackPtr->stackSize <= 0) {
    if (genericStackPtr->failureCallback != NULL) {
      (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, ERANGE, function, "stack is empty");
    }
    return NULL;
  }
  value = genericStackPtr->buf[genericStackPtr->stackSize-- - 1];
  if ((genericStackPtr->stackSize * 2) <= genericStackPtr->allocSize && genericStackPtr->allocSize >= 8) {
    size_t allocSize = genericStackPtr->allocSize / 2;
    void **buf = realloc(genericStackPtr->buf, allocSize * sizeof(void *));
    /* If failure, memory is still here. We tried to shrink */
    /* and not to expand, so no need to call the failure callback */
    if (buf != NULL) {
      genericStackPtr->allocSize = allocSize;
      genericStackPtr->buf = buf;
    }
  }
  return value;
}

/*************************
   genericStack_get
 *************************/
void  *genericStack_get(genericStack_t *genericStackPtr, unsigned int index)
{
  const static char *function = "genericStackGet()";

  if (genericStackPtr == NULL) {
    return NULL;
  }
  if (index >= genericStackPtr->allocSize && genericStackPtr->optionGrowOnGet == 1) {
    while (index >= genericStackPtr->allocSize) {
      genericStackPush(genericStackPtr, NULL);
    }
  }
  if (index >= genericStackPtr->stackSize && genericStackPtr->optionGrowOnGet != 1) {
    if (genericStackPtr->failureCallback != NULL) {
      (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, EINVAL, function, "Attempt to get beyond stack size that do not have optionGrowOnGet");
    }
    return NULL;
  }
  return genericStackPtr->buf[index];
}

/*************************
   genericStack_set
 *************************/
size_t genericStack_set(genericStack_t *genericStackPtr, unsigned int index, void *elementPtr)
{
  const static char *function = "genericStackSet()";
  size_t minStackSize = index+1;

  if (genericStackPtr == NULL) {
    return 0;
  }
  if (index >= genericStackPtr->allocSize && genericStackPtr->optionGrowOnSet == 1) {
    while (index >= genericStackPtr->allocSize) {
      genericStackPush(genericStackPtr, NULL);
    }
  }
  if (index >= genericStackPtr->stackSize && genericStackPtr->optionGrowOnSet != 1) {
    if (genericStackPtr->failureCallback != NULL) {
      (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, EINVAL, function, "Attempt to get beyond stack size that do not have optionGrowOnSet");
    }
    return 0;
  }
  if (genericStackPtr->buf[index] != NULL) {
    if (genericStackPtr->freeCallback != NULL) {
      int errnum = (*(genericStackPtr->freeCallback))(genericStackPtr->buf[index]);
      if (errnum != 0) {
	if (genericStackPtr->failureCallback != NULL) {
	  (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errnum, function, "freeCallback() call failed");
	}
      }
    }
    free(genericStackPtr->buf[index]);
    genericStackPtr->buf[index] = NULL;
  }
  if (elementPtr != NULL) {
    void *newElementPtr = malloc(genericStackPtr->elementSize);
    if (newElementPtr == NULL) {
      if (genericStackPtr->failureCallback != NULL) {
	(*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errno, function, "malloc() call failed");
      }
      return 0;
    }
    memcpy(newElementPtr, elementPtr, genericStackPtr->elementSize);
    if (genericStackPtr->copyCallback != NULL) {
      int errnum = (*(genericStackPtr->copyCallback))(newElementPtr, elementPtr);
      if (errnum != 0) {
	if (genericStackPtr->failureCallback != NULL) {
	  (*(genericStackPtr->failureCallback))(__FILE__, __LINE__, errnum, function, "copyCallback() call failed");
	}
      }
    }
    genericStackPtr->buf[index] = newElementPtr;
  }
  if (genericStackPtr->stackSize < minStackSize) {
    genericStackPtr->stackSize = minStackSize;
  }
  return 1;
}

/*************************
   genericStack_size
 *************************/
size_t genericStack_size(genericStack_t *genericStackPtr)
{
  if (genericStackPtr == NULL) {
    return 0;
  }
  return (genericStackPtr->stackSize);
}
