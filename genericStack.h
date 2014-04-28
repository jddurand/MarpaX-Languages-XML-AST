#ifndef GENERICSTACK_H
#define GENERICSTACK_H

#include <stddef.h>              /* size_t definition */

/*************************
   Opaque object pointer
 *************************/
typedef struct genericStack genericStack_t;

/*************************
   Macros
 *************************/
#define GENERICSTACK_OPTION_GROW_ON_GET 0x01
#define GENERICSTACK_OPTION_GROW_ON_SET 0x02
#define GENERICSTACK_OPTION_DEFAULT (GENERICSTACK_OPTION_GROW_ON_GET | GENERICSTACK_OPTION_GROW_ON_SET)

/*************************
   Callback types
 *************************/
typedef void (*genericStack_failureCallback_t)(const char *file, int line, const char *function, const char *format, ...);
typedef int  (*genericStack_freeCallback_t)(void *elementPtr);
typedef int  (*genericStack_copyCallback_t)(void *elementDstPtr, void *elementSrcPtr);

/*************************
   Options
 *************************/
typedef struct genericStack_option {
  unsigned int                   growFlags;
  genericStack_failureCallback_t genericStack_failureCallbackPtr;
  genericStack_freeCallback_t    genericStack_freeCallbackPtr;
  genericStack_copyCallback_t    genericStack_copyCallbackPtr;
} genericStack_option_t;

/*************************
   Methods
 *************************/
genericStack_t *genericStack_new(size_t elementSize, genericStack_option_t *optionp);

size_t          genericStack_push   (genericStack_t *genericStackPtr, void *elementPtr);
void           *genericStack_pop    (genericStack_t *genericStackPtr);
void           *genericStack_get    (genericStack_t *genericStackPtr, unsigned int index);
size_t          genericStack_set    (genericStack_t *genericStackPtr, unsigned int index, void *elementPtr);
size_t          genericStack_size   (genericStack_t *genericStackPtr);

void            genericStack_destroy(genericStack_t **genericStackPtrPtr);

#endif /* GENERICSTACK_H */
