#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/*
 * Note:
 * Despite this is an XSUB implementation, this module will NEVER explicitely croak
 */

#include "streamIn.h"

/*****************************************************************************/
/* Generic class handling read-only streaming on buffers that can ONLY go on */
/*****************************************************************************/
struct s_streamIn {
  SV                        *svInputp;           /* Input from Perl */
  short                      isTieHandleb;       /* When svInputp is a tied file handle */
  short                      isBlessedb;         /* When svInputp is a blessed object */
  short                      isPerlIOb;          /* When svInputp is a PerlIO */
  Size_t                     nWcharBuf;          /* Number of wchar_t buffers (start at zero) */
  wchar_t                  **wcharBufpp;         /* wchar_t buffers */
  STRLEN                     bufMaxChars;        /* Max number of characters per buffer */
  streamIn_failureCallback_t failureCallbackPtr; /* Failure callback */
  STRLEN                    *mapBegp;            /* Start position per buffer (inclusive) */
  STRLEN                    *mapEndp;            /* End position per buffer (exclusive) */
  STRLEN                     lastPos;            /* Last position ever read */
  STRLEN                     maxPos;             /* Max position (setted only if eof) */
  short                      eofb;

  /* Internal callback depending on type of input */
  void                     (*readFuncPtr)(s_streamIn_ *selfp, SV *sv);
};

static void  _streamIn_listBuffers(s_streamIn_ *selfp, const char *prefix);
static short _streamIn_sv2IsBlessed(s_streamIn_ *selfp);
static char *_streamIn_sv2Reftype(s_streamIn_ *selfp);
static short _streamIn_sv2IsPerlIOb(s_streamIn_ *selfp);
static short _streamIn_sv2TieHandleb(s_streamIn_ *selfp);
static void _streamIn_readFromBlessed(s_streamIn_ *selfp, SV *svTmp);
static void _streamIn_readFromPerlIO(s_streamIn_ *selfp, SV *svTmp);
static void _streamIn_readFromTieHandle(s_streamIn_ *selfp, SV *svTmp);
static void _streamIn_readFromScalar(s_streamIn_ *selfp, SV *svTmp);
static void _streamIn_doneBuffer(s_streamIn_ *selfp, Size_t iWcharBuf);
static void _streamIn_svToWchar(SV *sv, wchar_t **wBufp, STRLEN *svLenp);
static STRLEN _streamIn_read(s_streamIn_ *selfp, STRLEN position, short appendModeb);
static short _streamIn_init(s_streamIn_ *selfp, SV *inputp, streamIn_option_t *optionp);

/********************************************/
/* _streamIn_listBuffers                    */
/********************************************/
static void  _streamIn_listBuffers(s_streamIn_ *selfp, const char *prefix)
{
  Size_t i;

  fprintf(stderr, "%s: %ld buffers\n", prefix, (unsigned long) selfp->nWcharBuf);
  if (selfp->nWcharBuf > 0) {
    for (i = 0; i < selfp->nWcharBuf; i++) {
      fprintf(stderr, "...Buffer No %ld: [%5ld,%5ld[\n", (unsigned long) i, (unsigned long) selfp->mapBegp[i], (unsigned long) selfp->mapEndp[i]);
    }
  }
}

/********************************************/
/* _streamIn_sv2IsBlessed                   */
/*                                          */
/* Input: s_streamIn_ *selfp                */
/* Output: 1 if is blessed, 0 if not        */
/*                                          */
/* Note: Copied from Scalar-List-Utils-1.38 */
/********************************************/
static short _streamIn_sv2IsBlessed(s_streamIn_ *selfp)
{
  SvGETMAGIC(selfp->svInputp);
  return (SvROK(selfp->svInputp) && SvOBJECT(SvRV(selfp->svInputp))) ? 1 : 0;
}

/********************************************/
/* _streamIn_sv2Reftype                     */
/*                                          */
/* Input: s_streamIn_ *selfp                */
/* Output: char *reftype, NULL if not a ref */
/*                                          */
/* Note: Copied from Scalar-List-Utils-1.38 */
/********************************************/
static char *_streamIn_sv2Reftype(s_streamIn_ *selfp)
{
  SvGETMAGIC(selfp->svInputp);
  return SvROK(selfp->svInputp) ? (char*)sv_reftype(SvRV(selfp->svInputp),FALSE) : (char*)NULL;
}

/********************************************/
/* _streamIn_sv2IsperlIOb                   */
/*                                          */
/* Input: s_streamIn_ *selfp                */
/* Output: 1 if PerlIO compatible, or 0     */
/*                                          */
/* Adapted from Scalar-List-Utils-1.38      */
/********************************************/
static short _streamIn_sv2IsPerlIOb(s_streamIn_ *selfp)
{
  IO *io = NULL;
  SV *svInputp = selfp->svInputp;

  SvGETMAGIC(svInputp);
  if (SvROK(svInputp)) {
    /* deref first */
    svInputp = SvRV(svInputp);
  }

  /* must be GLOB or IO */
  if (isGV(svInputp)) {
    io = GvIO((GV*)svInputp);
  }
  else if(SvTYPE(svInputp) == SVt_PVIO) {
    io = (IO*)svInputp;
  }

  return ((io != NULL) && IoIFP(io)) ? 1 : 0;
}

/********************************************/
/* _streamIn_sv2TieHandleb                  */
/*                                          */
/* Input: s_streamIn_ *selfp                */
/* Output: 1 if tied handle, 0 if not       */
/********************************************/
static short _streamIn_sv2TieHandleb(s_streamIn_ *selfp)
{
  if (! isGV(selfp->svInputp) || SvTYPE(selfp->svInputp) != SVt_PVIO) {
    return 0;
  }
  return (SvTIED_mg((SV *) sv_2io(selfp->svInputp), 'q') ? 1 : 0);
}

/********************************************/
/* _streamIn_readFromBlessed                */
/*                                          */
/* read using an blessed SV                 */
/********************************************/
static void _streamIn_readFromBlessed(s_streamIn_ *selfp, SV *svTmp)
{
  dSP;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(selfp->svInputp);
  XPUSHs(svTmp);
  XPUSHs(sv_2mortal(newSViv(selfp->bufMaxChars)));
  PUTBACK;

  call_method("read", G_SCALAR | G_DISCARD);

  FREETMPS;
  LEAVE;
}

/********************************************/
/* _streamIn_readFromPerlIO                 */
/*                                          */
/* read using an blessed SV                 */
/********************************************/
static void _streamIn_readFromPerlIO(s_streamIn_ *selfp, SV *svTmp)
{
  dSP;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(selfp->svInputp);
  
  XPUSHs(sv_2mortal(newRV_noinc(svTmp)));
  XPUSHs(sv_2mortal(newSViv(selfp->bufMaxChars)));
  PUTBACK;

  call_pv("CORE::read", G_SCALAR | G_DISCARD);

  FREETMPS;
  LEAVE;

}

/*************************************************/
/* _streamIn_readFromTieHandle                   */
/*                                               */
/* read using an blessed SV                      */
/*                                               */
/* C.f. http://www.perlmonks.org/?node_id=715050 */
/*************************************************/
static void _streamIn_readFromTieHandle(s_streamIn_ *selfp, SV *svTmp)
{
  IO *io = sv_2io(selfp->svInputp);
  const MAGIC *mg = SvTIED_mg( (SV *) io, 'q');
  SV* obj = SvTIED_obj(MUTABLE_SV(io), mg);   /* This creates a mortal reference */

  dSP;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(obj);
  XPUSHs(svTmp);
  XPUSHs(sv_2mortal(newSViv(selfp->bufMaxChars)));
  PUTBACK;

  call_method("READ", G_SCALAR | G_DISCARD);

  FREETMPS;
  LEAVE;
}

/********************************************/
/* _streamIn_readFromScalar                  */
/*                                          */
/* Navigate through a scalar                */
/********************************************/
static void _streamIn_readFromScalar(s_streamIn_ *selfp, SV *svTmp)
{
  /* Force EOF flag */
  selfp->eofb = 1;
}

/********************************************/
/* _streamIn_doneBuffer                     */
/********************************************/
static void _streamIn_doneBuffer(s_streamIn_ *selfp, Size_t iWcharBuf)
{
  Size_t i, j;

  /* We want to forget forever buffer at index iWcharBuf. */
  /* Any eventual previous buffer will me removed as well */

  if (selfp->nWcharBuf > 0 && iWcharBuf < selfp->nWcharBuf) {
    /* We destroy the (wchar_t *) buffers */
    for (i = 0; i <= iWcharBuf; ++i) {
      Safefree(selfp->wcharBufpp[i]);
    }

    if ((iWcharBuf + 1) == selfp->nWcharBuf) {
      /* And in fact we destroyed everything */
      Safefree(selfp->wcharBufpp);
      selfp->wcharBufpp = NULL;

      Safefree(selfp->mapBegp);
      selfp->mapBegp = NULL;

      Safefree(selfp->mapEndp);
      selfp->mapEndp = NULL;

      selfp->nWcharBuf = 0;
    }
    else {
      /* And we have to realloc, taking care of moving backward */
      /* the informations                                       */
      for (j = 0, i = (iWcharBuf + 1); i < selfp->nWcharBuf; ++i, ++j) {
	selfp->wcharBufpp[j] = selfp->wcharBufpp[i];
	selfp->mapBegp[j] = selfp->mapBegp[i];
	selfp->mapEndp[j] = selfp->mapEndp[i];
      }

      selfp->nWcharBuf -= (iWcharBuf+1);

      Renew(selfp->wcharBufpp, selfp->nWcharBuf, wchar_t *);
      Renew(selfp->mapBegp, selfp->nWcharBuf, STRLEN);
      Renew(selfp->mapEndp, selfp->nWcharBuf, STRLEN);
    }

  }
}

/********************************************/
/* streamIn_doneCharacter                   */
/********************************************/
void streamIn_doneCharacter(s_streamIn_ *selfp, size_t pos)
{
  STRLEN position = (STRLEN) pos;
  Size_t iWcharBuf;
  Size_t iWcharBufToDelete;
  short  foundb = 0;

  /*
    We want to forget (FOREVER) character at position $pos
    If position is the last one hosted by a buffer, this buffer and
    eventually previous buffers will be destroyed.
    If position is in a buffer that is not the first one, all
    previous buffers are destroyed.
  */
  for (iWcharBuf = 0; iWcharBuf < selfp->nWcharBuf; iWcharBuf++) {
    if ((position == (selfp->mapEndp[iWcharBuf] - 1)) ||
	(position >= selfp->mapEndp[iWcharBuf])) {
      foundb = 1;
      iWcharBufToDelete = iWcharBuf;
    }
  }
  if (foundb == 1) {
    _streamIn_doneBuffer(selfp, iWcharBufToDelete);
  }
}

/********************************************/
/* _streamIn_svToWchar                      */
/*                                          */
/* Adapted from module Lucene version 0.18  */
/********************************************/
static void _streamIn_svToWchar(SV *sv, wchar_t **wBufp, STRLEN *svLenp)
{
  wchar_t* ret;
  // Get string length of argument. This works for PV, NV and IV.
  // The STRLEN typdef is needed to ensure that this will work correctly
  // in a 64-bit environment.
  STRLEN svLen;
  wchar_t* dst;
  U8 *src;
#if PERL_VERSION >= 16 || (PERL_VERSION == 15 && PERL_SUBVERSION >= 9)
  U8 *src_orig;
  U8 *src_end;
#endif

  src = (U8*) SvPV(sv, svLen);
#if PERL_VERSION >= 16 || (PERL_VERSION == 15 && PERL_SUBVERSION >= 9)
  src_orig = src;
  src_end = src_orig + svLen;
#endif

  // Alloc memory for wide char string.  This could be a bit more
  // then necessary.
  Newx(ret, svLen, wchar_t);
  dst = ret;
  if (SvUTF8(sv)) {
    // UTF8 to wide char mapping
    STRLEN len;
    svLen = 0;
    while (*src != 0) {
#if PERL_VERSION >= 16 || (PERL_VERSION == 15 && PERL_SUBVERSION >= 9)
      *dst++ = utf8_to_uvuni_buf(src, src_end, &len);
#else
      *dst++ = utf8_to_uvuni(src, &len);
#endif
      svLen++;
      src += len;
    }
  } else {
    // char to wide char mapping
    while (*src) {
      *dst++ = (wchar_t) *src++;
    }
  }
  /* No null byte intentionnally at the end of the buffer */

  *svLenp = svLen;
  *wBufp = ret;
}

/********************************************/
/* _streamIn_read                           */
/********************************************/
static STRLEN _streamIn_read(s_streamIn_ *selfp, STRLEN position, short appendModeb)
{
  SV *svTmp;
  Size_t iWcharBuf = selfp->nWcharBuf - 1;
  Size_t nWcharBuf;
  STRLEN n;

  if (selfp->nWcharBuf <= 0) {
    /* No buffer yet, fake append mode */
    appendModeb = 1;
  }
  if (appendModeb != 0) {
    iWcharBuf = selfp->nWcharBuf;
  } else {
    iWcharBuf = selfp->nWcharBuf - 1;
  }

  ENTER;
  SAVETMPS;

  if (selfp->readFuncPtr == _streamIn_readFromScalar) {
    /* This read is almost a no-op. It is just setting the EOF flag */
    svTmp = sv_2mortal(SvREFCNT_inc(newSVsv(selfp->svInputp)));
  } else {
    svTmp = sv_2mortal(SvREFCNT_inc(newSV(0)));
  }
  (*selfp->readFuncPtr)(selfp, svTmp);
  /* Allocate space */
  if (iWcharBuf == 0) {
    Newx(selfp->wcharBufpp, 1, wchar_t *);
    Newx(selfp->mapBegp, 1, STRLEN);
    Newx(selfp->mapEndp, 1, STRLEN);
  } else {
    nWcharBuf = iWcharBuf + 1;
    Renew(selfp->wcharBufpp, nWcharBuf, wchar_t *);
    Renew(selfp->mapBegp, nWcharBuf, STRLEN);
    Renew(selfp->mapEndp, nWcharBuf, STRLEN);
  }
  /* Do conversion to wchar_t */
  _streamIn_svToWchar(svTmp, &(selfp->wcharBufpp[iWcharBuf]), &n);

  FREETMPS;
  LEAVE;

  if (n <= 0) {
    /* Nothing read */
    selfp->eofb = 1;
    n = 0;
  } else if (n < selfp->bufMaxChars) {
    /* Something read but less than wanted */
    selfp->eofb = 1;
  }


  /* Append mode ? */
  if (appendModeb != 0 && iWcharBuf > 0) {
    /* Transfer mapend of previous buffer to mapbeg of new buffer */
    selfp->mapBegp[iWcharBuf] = selfp->mapEndp[iWcharBuf-1];
  } else {
    selfp->mapBegp[iWcharBuf] = position;
  }
  selfp->mapEndp[iWcharBuf] = selfp->mapBegp[iWcharBuf] + n;
  selfp->lastPos = selfp->mapEndp[iWcharBuf] - 1;
  selfp->nWcharBuf = iWcharBuf + 1;
  if (selfp->eofb) {
    selfp->maxPos = selfp->lastPos;
  }

  if (n <= 0) {
    /* Nothing was read - this could have been done before, but happens only once, at EOF */
    _streamIn_doneBuffer(selfp, iWcharBuf);
    n = 0;
  }

  return n;
}

/********************************************/
/* streamIn_fetchCharacter                  */
/********************************************/
short streamIn_fetchCharacter(s_streamIn_ *selfp, size_t pos, wchar_t *wcharp)
{
  const char *function = "streamIn_fetchCharacter";
  STRLEN position = (STRLEN) pos;
  size_t iLastWcharBuf;
  size_t iWcharBuf;
  size_t iPos;
  short  foundb = 0;

  if (selfp->nWcharBuf <= 0) {
    /* No data cached */
    if (selfp->eofb != 0) {
      /* But EOF marked: nothing else is available */
      return 0;
    } else {
      /* Buffer next data */
      if (_streamIn_read(selfp, selfp->lastPos + 1, 0) > 0) {;
	return streamIn_fetchCharacter(selfp, position, wcharp);
      } else {
	return 0;
      }
    }
  } else {
    if (position < selfp->mapBegp[0]) {
      if (selfp->failureCallbackPtr != NULL) {
        (*selfp->failureCallbackPtr)(__FILE__, __LINE__, function, "Attempt to fetch at position %ld < %ld (first cached position)", (unsigned long) position, (unsigned long) selfp->mapBegp[0]);
      }
      return 0;
    } else {
      iLastWcharBuf = selfp->nWcharBuf - 1;
      if (position >= selfp->mapEndp[iLastWcharBuf]) {
	/*
	  Attempt to read beyond last cached data: need to append another buffer
	  Although this is not likely to happen, we prevent deep recursion
	  by doing the loop ourselfp
	*/
	while ((selfp->eofb == 0) && (position >= selfp->mapEndp[iLastWcharBuf])) {
	  _streamIn_read(selfp, selfp->lastPos + 1, 1);
	  iLastWcharBuf = selfp->nWcharBuf - 1;
	}
      }
      /*
	Search buffer index hosting our position
      */
      for (iWcharBuf = 0; iWcharBuf < selfp->nWcharBuf; iWcharBuf++) {
	if (position >= selfp->mapBegp[iWcharBuf] && position < selfp->mapEndp[iWcharBuf]) {
	  foundb = 1;
	  break;
	}
      }
      if (foundb == 0) {
	/*
	  Not found - a priori selfp->eofb should be marked
	*/
	if (selfp->eofb == 0) {
          if (selfp->failureCallbackPtr != NULL) {
            (*selfp->failureCallbackPtr)(__FILE__, __LINE__, function, "Fetch at position %ld fail and eof is not reached", (unsigned long) position);
          }
        }
        return 0;
      } else {
	iPos = position - selfp->mapBegp[iWcharBuf];
	*wcharp = selfp->wcharBufpp[iWcharBuf][iPos];
	return 1;
      }
    }
  }
}

/********************************************/
/* streamIn initialization                  */
/* Return 0 on failure, 1 on success        */
/********************************************/
static short _streamIn_init(s_streamIn_ *selfp, SV *svInputp, streamIn_option_t *optionp)
{
  const static char *function = "_streamIn_init";
  char *reftype;

  selfp->svInputp = svInputp;
  selfp->nWcharBuf = 0;
  selfp->wcharBufpp = NULL;
  selfp->mapBegp = NULL;
  selfp->mapEndp = NULL;
  selfp->lastPos = 0;
  selfp->maxPos = 0;
  selfp->eofb = 0;

  reftype = _streamIn_sv2Reftype(selfp);

  if (optionp != NULL) {
    selfp->bufMaxChars = optionp->bufMaxChars <= 0 ? STREAMIN_DEFAULT_BUFMAXCHARS : optionp->bufMaxChars;
    selfp->failureCallbackPtr = optionp->failureCallbackPtr;
  } else {
    selfp->bufMaxChars = STREAMIN_DEFAULT_BUFMAXCHARS;
    selfp->failureCallbackPtr = NULL;
  }

  /*
    We support explicitely and only:
    - a tied scalar
    - a blessed scalar
    - a perlio scalar
    - a reference to a scalar
    - a scalar
    and we set the read callback accordingly
  */
  if ((selfp->isTieHandleb = _streamIn_sv2TieHandleb(selfp)) != 0) {
    selfp->readFuncPtr = _streamIn_readFromTieHandle;
  }
  else if ((selfp->isBlessedb = _streamIn_sv2IsBlessed(selfp)) != 0) {
    selfp->readFuncPtr = _streamIn_readFromBlessed;
  }
  else if ((selfp->isPerlIOb = _streamIn_sv2IsPerlIOb(selfp)) != 0) {
    selfp->readFuncPtr = _streamIn_readFromPerlIO;
  }
  else if (reftype != NULL && strcmp(reftype, "SCALAR") == 0) {
    selfp->svInputp = SvRV(selfp->svInputp);  /* Dereference */
    selfp->readFuncPtr = _streamIn_readFromScalar;
  }
  else if (reftype == NULL) {
    selfp->readFuncPtr = _streamIn_readFromScalar;
  }
  else {
    streamIn_destroy(&selfp);
    if (selfp->failureCallbackPtr != NULL) {
      (*selfp->failureCallbackPtr)(__FILE__, __LINE__, function, "%s", "Invalid input type: must be a tie handle, a blessed scalar, a perl IO, a reference to scalar, or a scalar");
    }
    return 0;
  }

  if (_streamIn_read(selfp, 0, 0) <= 0) {
    return 0;
  }

  return 1;
}

/********************************************/
/* streamIn destructor a-la-C               */
/********************************************/
void streamIn_destroy(s_streamIn_ **selfpp)
{
  /* Destroy all internal buffers */
  _streamIn_doneBuffer(*selfpp, (*selfpp)->nWcharBuf - 1);
  Safefree(*selfpp);
  *selfpp = NULL;
}

/********************************************/
/* streamIn constructor a-la-C              */
/********************************************/
s_streamIn_ *streamIn_new(void *inputp, streamIn_option_t *optionp)
{
  s_streamIn_ *selfp = NULL;

  Newx(selfp, 1, s_streamIn_);

  if (_streamIn_init(selfp, (SV *) inputp, optionp) == 0) {
    streamIn_destroy(&selfp);
    selfp = NULL;
  }

  return selfp;
}
