#ifndef STREAMIN_C
#define STREAMIN_C

/********************************************************************************/
/* Convention:                                                                  */
/* - if the last character of a variable is 'p', then it is a pointer           */
/* - if the last character of a variable is 'b', then it is a boolean           */
/********************************************************************************/

#define STREAMIN_DEFAULT_BUFMAXCHARS (1024*1024)

/*****************************************************************************/
/* Generic class handling read-only streaming on buffers that can ONLY go on */
/*****************************************************************************/
typedef struct s_streamIn s_streamIn_;
struct s_streamIn {
  SV            *svInputp;
  short          isTieHandleb;  /* When svInputp is a tied file handle */
  short          isBlessedb;    /* When svInputp is a blessed object */
  short          isPerlIOb;     /* When svInputp is a PerlIO */
  Size_t         nWcharBuf;     /* Number of wchar_t buffers (start at zero) */
  wchar_t      **wcharBufpp;    /* wchar_t buffers */
  STRLEN         bufMaxChars;   /* Max number of characters per buffer */
  STRLEN        *mapBegp;       /* Start position per buffer (inclusive) */
  STRLEN        *mapEndp;       /* End position per buffer (exclusive) */
  STRLEN         lastPos;       /* Last position ever read */
  STRLEN         maxPos;        /* Max position (setted only if eof) */
  void         (*readFuncPtr)(s_streamIn_ *self, SV *sv);
  short          eofb;
};

/********************************************/
/* _streamIn_listBuffers                    */
/********************************************/
static void  _streamIn_listBuffers(self, prefix)
     s_streamIn_ *self;
     const char *prefix;
{
  Size_t i;

  fprintf(stderr, "%s: %ld buffers\n", prefix, (unsigned long) self->nWcharBuf);
  if (self->nWcharBuf > 0) {
    for (i = 0; i < self->nWcharBuf; i++) {
      fprintf(stderr, "...Buffer No %ld: [%5ld,%5ld[\n", (unsigned long) i, (unsigned long) self->mapBegp[i], (unsigned long) self->mapEndp[i]);
    }
  }
}

/********************************************/
/* _streamIn_sv2IsBlessed                   */
/*                                          */
/* Input: SV *svInputp                      */
/* Output: 1 if is blessed, 0 if not        */
/*                                          */
/* Note: Copied from Scalar-List-Utils-1.38 */
/********************************************/
static short _streamIn_sv2IsBlessed(svInputp)
     SV *svInputp;
{
  SvGETMAGIC(svInputp);
  return (SvROK(svInputp) && SvOBJECT(SvRV(svInputp))) ? 1 : 0;
}

/********************************************/
/* _streamIn_sv2Reftype                     */
/*                                          */
/* Input: SV *svInputp                      */
/* Output: char *reftype, NULL if not a ref */
/*                                          */
/* Note: Copied from Scalar-List-Utils-1.38 */
/********************************************/
static char *_streamIn_sv2Reftype(svInputp)
     SV *svInputp;
{
  SvGETMAGIC(svInputp);
  return SvROK(svInputp) ? (char*)sv_reftype(SvRV(svInputp),FALSE) : (char*)NULL;
}

/********************************************/
/* _streamIn_sv2IsperlIOb                   */
/*                                          */
/* Input: SV *svInputp                      */
/* Output: 1 if PerlIO compatible, or 0     */
/*                                          */
/* Adapted from Scalar-List-Utils-1.38      */
/********************************************/
static short _streamIn_sv2IsPerlIOb(svInputp)
     SV *svInputp;
{
  IO *io = NULL;

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
/* Input: SV *svInputp                      */
/* Output: 1 if tied handle, 0 if not       */
/********************************************/
static short _streamIn_sv2TieHandleb(svInputp)
     SV *svInputp;
{
  if (! isGV(svInputp) || SvTYPE(svInputp) != SVt_PVIO) {
    return 0;
  }
  return (SvTIED_mg((SV *) sv_2io(svInputp), 'q') ? 1 : 0);
}

/********************************************/
/* _streamIn_readFromBlessed                */
/*                                          */
/* read using an blessed SV                 */
/********************************************/
static void _streamIn_readFromBlessed(self, svTmp)
     s_streamIn_ *self;
     SV *svTmp;
{
  dSP;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(self->svInputp);
  XPUSHs(svTmp);
  XPUSHs(sv_2mortal(newSViv(self->bufMaxChars)));
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
static void _streamIn_readFromPerlIO(self, svTmp)
     s_streamIn_ *self;
     SV *svTmp;
{
  dSP;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(self->svInputp);
  
  XPUSHs(sv_2mortal(newRV_noinc(svTmp)));
  XPUSHs(sv_2mortal(newSViv(self->bufMaxChars)));
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
static void _streamIn_readFromTieHandle(self, svTmp)
     s_streamIn_ *self;
     SV *svTmp;
{
  IO *io = sv_2io(self->svInputp);
  const MAGIC *mg = SvTIED_mg( (SV *) io, 'q');
  SV* obj = SvTIED_obj(MUTABLE_SV(io), mg);   /* This creates a mortal reference */

  dSP;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(obj);
  XPUSHs(svTmp);
  XPUSHs(sv_2mortal(newSViv(self->bufMaxChars)));
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
static void _streamIn_readFromScalar(self, svTmp)
     s_streamIn_ *self;
     SV *svTmp;
{
  /* Force EOF flag */
  self->eofb = 1;
}

/********************************************/
/* _streamIn_doneBuffer                     */
/********************************************/
static void _streamIn_doneBuffer(self, iWcharBuf)
     s_streamIn_ *self;
     Size_t       iWcharBuf;
{
  Size_t i, j;

  /* We want to forget forever buffer at index iWcharBuf. */
  /* Any eventual previous buffer will me removed as well */

  if (self->nWcharBuf > 0 && iWcharBuf < self->nWcharBuf) {
    /* We destroy the (wchar_t *) buffers */
    for (i = 0; i <= iWcharBuf; ++i) {
      Safefree(self->wcharBufpp[i]);
    }

    if ((iWcharBuf + 1) == self->nWcharBuf) {
      /* And in fact we destroyed everything */
      Safefree(self->wcharBufpp);
      self->wcharBufpp = NULL;

      Safefree(self->mapBegp);
      self->mapBegp = NULL;

      Safefree(self->mapEndp);
      self->mapEndp = NULL;

      self->nWcharBuf = 0;
    }
    else {
      /* And we have to realloc, taking care of moving backward */
      /* the informations                                       */
      for (j = 0, i = (iWcharBuf + 1); i < self->nWcharBuf; ++i, ++j) {
	self->wcharBufpp[j] = self->wcharBufpp[i];
	self->mapBegp[j] = self->mapBegp[i];
	self->mapEndp[j] = self->mapEndp[i];
      }

      self->nWcharBuf -= (iWcharBuf+1);

      Renew(self->wcharBufpp, self->nWcharBuf, wchar_t *);
      Renew(self->mapBegp, self->nWcharBuf, STRLEN);
      Renew(self->mapEndp, self->nWcharBuf, STRLEN);
    }

  }
}

/********************************************/
/* _streamIn_doneCharacter                  */
/********************************************/
static void _streamIn_doneCharacter(self, position)
     s_streamIn_ *self;
     STRLEN       position;
{
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
  for (iWcharBuf = 0; iWcharBuf < self->nWcharBuf; iWcharBuf++) {
    if ((position == (self->mapEndp[iWcharBuf] - 1)) ||
	(position >= self->mapEndp[iWcharBuf])) {
      foundb = 1;
      iWcharBufToDelete = iWcharBuf;
    }
  }
  if (foundb == 1) {
    _streamIn_doneBuffer(self, iWcharBufToDelete);
    _streamIn_listBuffers(self, "After _streamIn_doneBuffer within _streamIn_doneCharacter");
  }
}

/********************************************/
/* _streamIn_svToWchar                      */
/*                                          */
/* Adapted from module Lucene version 0.18  */
/********************************************/
static void _streamIn_svToWchar(sv, wBufp, svLenp)
     SV *sv;
     wchar_t **wBufp;
     STRLEN *svLenp;
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
static void _streamIn_read(self, position, appendModeb)
     s_streamIn_ *self;
     STRLEN       position;
     short        appendModeb;
{
  SV *svTmp;
  Size_t iWcharBuf = self->nWcharBuf - 1;
  Size_t nWcharBuf;
  STRLEN n;

  if (self->nWcharBuf <= 0) {
    /* No buffer yet, fake append mode */
    appendModeb = 1;
  }
  if (appendModeb != 0) {
    iWcharBuf = self->nWcharBuf;
  } else {
    iWcharBuf = self->nWcharBuf - 1;
  }

  ENTER;
  SAVETMPS;

  if (self->readFuncPtr == _streamIn_readFromScalar) {
    /* This read is almost a no-op. It is just setting the EOF flag */
    svTmp = sv_2mortal(SvREFCNT_inc(newSVsv(self->svInputp)));
  } else {
    svTmp = sv_2mortal(SvREFCNT_inc(newSV(0)));
  }
  (*self->readFuncPtr)(self, svTmp);
  /* Allocate space */
  if (iWcharBuf == 0) {
    Newx(self->wcharBufpp, 1, wchar_t *);
    Newx(self->mapBegp, 1, STRLEN);
    Newx(self->mapEndp, 1, STRLEN);
  } else {
    nWcharBuf = iWcharBuf + 1;
    Renew(self->wcharBufpp, nWcharBuf, wchar_t *);
    Renew(self->mapBegp, nWcharBuf, STRLEN);
    Renew(self->mapEndp, nWcharBuf, STRLEN);
  }
  /* Do conversion to wchar_t */
  _streamIn_svToWchar(svTmp, &(self->wcharBufpp[iWcharBuf]), &n);

  FREETMPS;
  LEAVE;

  if (n <= 0) {
    /* Nothing read */
    self->eofb = 1;
    n = 0;
  } else if (n < self->bufMaxChars) {
    /* Something read but less than wanted */
    self->eofb = 1;
  }


  /* Append mode ? */
  if (appendModeb != 0 && iWcharBuf > 0) {
    /* Transfer mapend of previous buffer to mapbeg of new buffer */
    self->mapBegp[iWcharBuf] = self->mapEndp[iWcharBuf-1];
  } else {
    self->mapBegp[iWcharBuf] = position;
  }
  self->mapEndp[iWcharBuf] = self->mapBegp[iWcharBuf] + n;
  self->lastPos = self->mapEndp[iWcharBuf] - 1;
  self->nWcharBuf = iWcharBuf + 1;
  if (self->eofb) {
    self->maxPos = self->lastPos;
  }

  _streamIn_listBuffers(self, "After _streamIn_read");

  if (n <= 0) {
    /* Nothing was read - this could have been done before, but happens only once, at EOF */
    _streamIn_doneBuffer(self, iWcharBuf);
    _streamIn_listBuffers(self, "After _streamIn_doneBuffer within _streamIn_read");
  }
  
}

/********************************************/
/* _streamIn_fetchCharacter                 */
/********************************************/
static short _streamIn_fetchCharacter(self, position, wcharp)
     s_streamIn_ *self;
     STRLEN       position;
     wchar_t     *wcharp;
{
  size_t iLastWcharBuf;
  size_t iWcharBuf;
  size_t iPos;
  short  foundb = 0;

  if (self->nWcharBuf <= 0) {
    /* No data cached */
    if (self->eofb != 0) {
      /* But EOF marked: nothing else is available */
      return 0;
    } else {
      /* Buffer next data */
      _streamIn_read(self, self->lastPos + 1, 0);
      _streamIn_listBuffers(self, "After _streamIn_read within _streamIn_fetchCharacter");
      return _streamIn_fetchCharacter(self, position);
    }
  } else {
    if (position < self->mapBegp[0]) {
      croak("Attempt to fetch at position %ld < %ld (first cached position)", (unsigned long) position, (unsigned long) self->mapBegp[0]);
    } else {
      iLastWcharBuf = self->nWcharBuf - 1;
      if (position >= self->mapEndp[iLastWcharBuf]) {
	/*
	  Attempt to read beyond last cached data: need to append another buffer
	  Although this is not likely to happen, we prevent deep recursion
	  by doing the loop ourself
	*/
	while ((self->eofb == 0) && (position >= self->mapEndp[iLastWcharBuf])) {
	  _streamIn_read(self, self->lastPos + 1, 1);
	  iLastWcharBuf = self->nWcharBuf - 1;
	}
      }
      /*
	Search buffer index hosting our position
      */
      for (iWcharBuf = 0; iWcharBuf < self->nWcharBuf; iWcharBuf++) {
	if (position >= self->mapBegp[iWcharBuf] && position < self->mapEndp[iWcharBuf]) {
	  foundb = 1;
	  break;
	}
      }
      if (foundb == 0) {
	/*
	  Not found - a priori self->eofb should be marked
	*/
	if (self->eofb == 0) {
	  croak("Fetch at position %ld fail and eof is not reached", (unsigned long) position);
	} else {
	  return 0;
	}
      } else {
	iPos = position - self->mapBegp[iWcharBuf];
	*wcharp = self->wcharBufpp[iWcharBuf][iPos];
	return 1;
      }
    }
  }
}

/********************************************/
/* streamIn initialization                  */
/********************************************/
static void _streamIn_init(self)
     s_streamIn_ *self;
{

  self->nWcharBuf = 0;
  self->wcharBufpp = NULL;
  if (self->bufMaxChars <= 0) {
    self->bufMaxChars = STREAMIN_DEFAULT_BUFMAXCHARS;
  }
  self->mapBegp = NULL;
  self->mapEndp = NULL;
  self->lastPos = 0;
  self->maxPos = 0;
  self->eofb = 0;

  _streamIn_read(self, 0, 0);
}

/********************************************/
/* streamIn destructor a-la-C               */
/********************************************/
static void streamIn_destroy(selfp)
     s_streamIn_ **selfp;
{
  /* Destroy all internal buffers */
  _streamIn_doneBuffer(*selfp, (*selfp)->nWcharBuf - 1);
  Safefree(*selfp);
  *selfp = NULL;
}

/********************************************/
/* streamIn constructor a-la-C              */
/********************************************/
static s_streamIn_ *streamIn_new(svInputp, bufMaxChars)
     SV *svInputp;
     STRLEN bufMaxChars;
{
  s_streamIn_ *self = NULL;
  char *reftype = _streamIn_sv2Reftype(svInputp);

  Newx(self, 1, s_streamIn_);

  self->svInputp = svInputp;
  self->bufMaxChars = bufMaxChars;
  
  /*
    We support explicitely and only:
    - a tied scalar
    - a blessed scalar
    - a perlio scalar
    - a reference to a scalar
    - a scalar
    and we set the read callback accordingly
  */
  if ((self->isTieHandleb = _streamIn_sv2TieHandleb(svInputp)) != 0) {
    self->readFuncPtr = _streamIn_readFromTieHandle;
  }
  else if ((self->isBlessedb = _streamIn_sv2IsBlessed(svInputp)) != 0) {
    self->readFuncPtr = _streamIn_readFromBlessed;
  }
  else if ((self->isPerlIOb = _streamIn_sv2IsPerlIOb(svInputp)) != 0) {
    self->readFuncPtr = _streamIn_readFromPerlIO;
  }
  else if (reftype != NULL && strcmp(reftype, "SCALAR") == 0) {
    self->svInputp = SvRV(svInputp);  /* Dereference */
    self->readFuncPtr = _streamIn_readFromScalar;
  }
  else if (reftype == NULL) {
    self->readFuncPtr = _streamIn_readFromScalar;
  }
  else {
    streamIn_destroy(&self);
    croak("Invalid input type: must be blessed, an opened file handle, a reference to a scalar, or a scalar");
  }

  _streamIn_init(self);

  return self;
}


#endif /* STREAMIN_C */
