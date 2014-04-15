#ifndef XMLTYPES_H
#define XMLTYPES_H

/* We include marpa_slif.h instead of marpa.h, because it contains  */
/* very handy definition e.g. marpa_error_description[], etc...     */
#include "marpa_slif.h"

struct sXmlSymbolId {
  Marpa_Symbol_ID symbolId;
  const char *name;
  const char *desc;
};

#endif /* XMLTYPES_H */
