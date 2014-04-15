/********************************************************
 _croakIfError
 ********************************************************/
static void _croakIfError(errorCode, call, forcedCondition)
     Marpa_Error_Code errorCode;
     const char *call;
     int forcedCondition;
{
  if (forcedCondition != 0 || errorCode != MARPA_ERR_NONE) {
    const char *function = (call != NULL) ? call : "<unknown>";
    const char *msg = (errorCode >= 0 && errorCode < MARPA_ERROR_COUNT) ? marpa_error_description[errorCode].name : "Generic error";
    croak ("%s: %s", function, msg);
  }
}

/********************************************************
 _checkMarpaVersion - unused
 ********************************************************/
static void _checkMarpaVersion()
{
  unsigned int version[3];

  _croakIfError(marpa_version(version), "marpa_version()", 0);
  _croakIfError(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION), "marpa_check_version()", 0);
}

/********************************************************
 _createG
 ********************************************************/
static void _createG(gp)
     Marpa_Grammar *gp;
{
  Marpa_Config marpa_configuration;
  Marpa_Grammar g;

  /* Configuration initialisation */
  marpa_c_init(&marpa_configuration);     /* never fails as per the doc */

  /* Grammar creation */
  g = marpa_g_new(&marpa_configuration);
  _croakIfError(marpa_c_error(&marpa_configuration, NULL), "marpa_g_new()", g == NULL);

  *gp = g;
}

/********************************************************
 _fillG
 ********************************************************/
static void _fillG(g,
                   nXmlSymbolId, aXmlSymbolId           /* Symbols */
                   )
     Marpa_Grammar g;
     int nXmlSymbolId;
     struct sXmlSymbolId *aXmlSymbolId;
{
  int i;
  Marpa_Symbol_ID symbolId;

  for (i = 0; i < nXmlSymbolId; i++) {
    marpa_g_error_clear(g);
    aXmlSymbolId[i].symbolId = marpa_g_symbol_new(g);
    _croakIfError(marpa_g_error(g, NULL), "marpa_g_symbol_new()", aXmlSymbolId[i].symbolId < 0);
  }
}
