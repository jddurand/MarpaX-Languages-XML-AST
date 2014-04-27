#ifndef STREAMIN_H
#define STREAMIN_H

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

typedef struct s_streamIn s_streamIn_;

s_streamIn_ *streamIn_new(SV *svInputp, STRLEN bufMaxChars);
void streamIn_destroy(s_streamIn_ **selfp);
void streamIn_doneCharacter(s_streamIn_ *self, STRLEN position);
short streamIn_fetchCharacter(s_streamIn_ *self, STRLEN position, wchar_t *wcharp);

#endif /* STREAMIN_H */
