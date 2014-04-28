#ifndef STREAMIN_H
#define STREAMIN_H

#include <stddef.h>              /* size_t definition */
#include <wchar.h>               /* wchar_t definition */

/*************************
   Opaque object pointer
 *************************/
typedef struct s_streamIn s_streamIn_;

/*************************
   Macros
 *************************/
#define STREAMIN_DEFAULT_BUFMAXCHARS (1024*1024)

/*************************
   Callback types
 *************************/
typedef void (*streamIn_failureCallback_t)(const char *file, int line, const char *function, const char *format, ...);

/*************************
   Options
 *************************/
typedef struct streamIn_option {
  size_t                     bufMaxChars;
  streamIn_failureCallback_t failureCallbackPtr;
} streamIn_option_t;

/*************************
   Methods
 *************************/
s_streamIn_ *streamIn_new(void *inputp, streamIn_option_t *optionp);

void         streamIn_doneCharacter (s_streamIn_ *selfp, size_t pos);
short        streamIn_fetchCharacter(s_streamIn_ *selfp, size_t pos, wchar_t *wcharp);

void         streamIn_destroy(s_streamIn_ **selfpp);

#endif /* STREAMIN_H */
