#include "marpa.h"

void _check_error_code(error_code, what)
     Marpa_Error_Code error_code;
     const char *function;
{
  if (error_code != MARPA_ERR_NONE) {
    if (error_code >= 0 && error_code < MARPA_ERROR_COUNT) {
      croak ("%s: %s", function, marpa_error_description[error_code].name);
    } else {
      croak ("%s: Error code %d", function, error_code);
    }
}

void _check_marpa()
{
  _check_error_code(marpa_version(version), "marpa_version");

  if (version[0] != MARPA_MAJOR_VERSION ||
      version[1] != MARPA_MINOR_VERSION ||
      version[2] != MARPA_MICRO_VERSION) {
    croak("marpa_version: want Libmarpa %d.%d.%d, using Libmarpa %d.%d.%d",
          MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION,
          version[0], version[1], version[2]);
  }

  _check_error_code(marpa_check_version(MARPA_MAJOR_VERSION, MARPA_MINOR_VERSION, MARPA_MICRO_VERSION)), "marpa_check_version");

}

void create_g(gp)
     Marpa_Grammar *gp;
{
  Marpa_Config marpa_configuration;

  _check_marpa();
  marpa_c_init(&marpa_configuration);
  g = marpa_g_new(&marpa_configuration);
  if (g == NULL) {
    croak ("marpa_g_new failure: %s", marpa_error_description[error_code].name);
  }
}

