#ifndef STREAMIN_C
#define STREAMIN_C

/********************************************************************************/
/* Convention: if the last character of a variable is 'p', then it is a pointer */
/* 'pp': pointer to pointer and so on.                                          */
/* Any other last character is free. Only 'p' is reserved.                      */
/********************************************************************************/

/*****************************************************************************/
/* Generic class handling read-only streaming on buffers that can ONLY go on */
/*****************************************************************************/
typedef struct s_streamin {
  SV            *svInputp;
  U8           **u8Bufpp;
  U8           **u8BufOffsetpp; /* Current offset inside every u8Bufpp */
  STRLEN         bufMaxChars;
  STRLEN        *mapBegp;
  STRLEN        *mapEndp;
  unsigned int   nBuf;
  STRLEN         lastPos;
  STRLEN         maxPos;
  int          (*streaminRead)(struct streamin *self, STDCHAR **bufp, STRLEN count);
  short          eof;
} s_streamin_;

/********************************************/
/* _isBlessed                               */
/*                                          */
/* Input: SV *sv                            */
/* Output: 1 if is blessed, 0 if not        */
/*                                          */
/* Note: Copied from Scalar-List-Utils-1.38 */
/********************************************/
static short _isBlessed(sv)
     SV *sv;
{
  SvGETMAGIC(sv);
  return (SvROK(sv) && SvOBJECT(SvRV(sv))) ? 1 : 0;
}

/********************************************/
/* _reftype                                 */
/*                                          */
/* Input: SV *sv                            */
/* Output: char *reftype, NULL if not a ref */
/*                                          */
/* Note: Copied from Scalar-List-Utils-1.38 */
/********************************************/
static char *_reftype(sv)
     SV *sv;
{
  SvGETMAGIC(sv);
  return SvROK(sv) ? (char*)sv_reftype(SvRV(sv),FALSE) : (char*)NULL;
}

/********************************************/
/* _isOpenhandle                            */
/*                                          */
/* Input: SV *sv                            */
/* Output: 1 if if opened handle, 0 if not  */
/*                                          */
/* Copied from Scalar-List-Utils-1.38       */
/********************************************/
static short _isOpenhandle(sv)
     SV *sv;
{
  IO *io = NULL;
  SvGETMAGIC(sv);
  if(SvROK(sv)){
    /* deref first */
    sv = SvRV(sv);
  }

  /* must be GLOB or IO */
  if(isGV(sv)){
    io = GvIO((GV*)sv);
  }
  else if(SvTYPE(sv) == SVt_PVIO){
    io = (IO*)sv;
  }

  if (io != NULL) {
    /* real or tied filehandle? */
    if(IoIFP(io) || SvTIED_mg((SV*)io, PERL_MAGIC_tiedscalar)){
      return 1;
    }
  }

  return 0;
}

/********************************************/
/* _streaminReadFromPerl                    */
/*                                          */
/* read using an blessed SV                 */
/********************************************/
static int _streaminReadFromPerl(svInputp, svBufp, nbWantedChar)
     SV *svInputp;
     SV **svBufp;
     int nbWantedChar;
{
  dSP;
  int nbGotChar;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(svInputp);
  XPUSHs(sv_2mortal(*svBufp = newSV(0)));
  XPUSHs(sv_2mortal(newSViv(nbWantedChar)));
  PUTBACK;

  call_method("read", G_SCALAR);

  SPAGAIN;
  nbGotChar = POPi;

  FREETMPS;
  LEAVE;

  return nbGotChar;
}

/********************************************/
/* _streaminReadFromScalarRef               */
/*                                          */
/* Navigate through a scalar  reference     */
/********************************************/
static int _streaminReadFromScalarRef(svInputp, svBufp, nbWantedChar)
     SV *svInputp;
     SV **svBufp;
     int nbWantedChar;
{
}

/********************************************/
/* _streaminReadFromScalar                  */
/*                                          */
/* Navigate through a scalar                */
/********************************************/
static int _streaminReadFromScalar(svInputp, svBufp, nbWantedChar)
     SV *svInputp;
     SV **svBufp;
     int nbWantedChar;
{
  dSP;
  int nbGotChar;

  ENTER;
  SAVETMPS;

  PUSHMARK(SP);
  XPUSHs(svInputp);
  XPUSHs(sv_2mortal(*svBufp = newSV(0)));
  XPUSHs(sv_2mortal(newSViv(nbWantedChar)));
  PUTBACK;

  /* For speed we get rid of stack with G_DISCARD: checking length of *svBufp is equivalent */
  call_method("read", G_SCALAR | G_DISCARD);

  SPAGAIN;
  nbGotChar = POPi;

  FREETMPS;
  LEAVE;

  return nbGotChar;
}

/********************************************/
/* streamin constructor a-la-C              */
/********************************************/
s_streamin_ *streaminNew(input)
     SV *input;
{
  s_streamin_ *self = NULL;
  char *reftype = _reftype(input);

  Newx(self, 1, s_streamin_);
  /*
    We support explicitely and only:
    - an object
    - a scalar
    - a fileno
    and we set the read callback accordingly
  */
  if (_isBlessed(input)) {
    /* We ASSUME the input can "read" if a perl-compatible way, i.e. $input->read(scalar, length) */
    self->streaminRead = _streaminReadFromPerl;
  } else if (_isOpenhandle(input)) {
    self->streaminRead = _streaminReadFromPerl;
  } else if (reftype != NULL && strcmp(reftype, 'SCALAR') == 0) {
    self->streaminRead = _streaminReadFromScalarRef;
  } else if (reftype == NULL) {
    self->streaminRead = _streaminReadFromScalar;
  } else {
    Safefree(self);
    self = NULL;
    croak("Invalid input type: must be blessed, an opened file handle, a reference to a scalar, or a scalar");
  }

  return self;
}

/*
 * Below is from the PERL module Lucene version 0.18
 */

static
wchar_t*
SvToWChar(SV* arg)
{
    wchar_t* ret;
    // Get string length of argument. This works for PV, NV and IV.
    // The STRLEN typdef is needed to ensure that this will work correctly
    // in a 64-bit environment.
    STRLEN arg_len;
    SvPV(arg, arg_len);

    // Alloc memory for wide char string.  This could be a bit more
    // then necessary.
    Newz(0, ret, arg_len + 1, wchar_t);

    U8* src = (U8*) SvPV_nolen(arg);
    wchar_t* dst = ret;

    if (SvUTF8(arg)) {
        // UTF8 to wide char mapping
        STRLEN len;
        while (*src) {
            *dst++ = utf8_to_uvuni(src, &len);
            src += len;
        }
    } else {
        // char to wide char mapping
        while (*src) {
            *dst++ = (wchar_t) *src++;
        }
    }
    *dst = 0;
    return ret;
}

static
SV*
WCharToSv(wchar_t* src, SV* dest)
{
    U8* dst;
    U8* d;

    // Alloc memory for wide char string.  This is clearly wider
    // then necessary in most cases but no choice.
    Newz(0, dst, 3 * wcslen(src) + 1, U8);

    d = dst;
    while (*src) {
        d = uvuni_to_utf8(d, *src++);
    }
    *d = 0;

    sv_setpv(dest, (char*) dst);
    sv_utf8_decode(dest);

    Safefree(dst);
    return dest;
}

#endif /* STREAMIN_C */
