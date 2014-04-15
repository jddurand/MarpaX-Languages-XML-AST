/* ANSI-C code produced by gperf version 3.0.4 */
/* Command-line: gperf --struct-type -n lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf  */
/* Computed positions: -k'1,4,$' */

#if !((' ' == 32) && ('!' == 33) && ('"' == 34) && ('#' == 35) \
      && ('%' == 37) && ('&' == 38) && ('\'' == 39) && ('(' == 40) \
      && (')' == 41) && ('*' == 42) && ('+' == 43) && (',' == 44) \
      && ('-' == 45) && ('.' == 46) && ('/' == 47) && ('0' == 48) \
      && ('1' == 49) && ('2' == 50) && ('3' == 51) && ('4' == 52) \
      && ('5' == 53) && ('6' == 54) && ('7' == 55) && ('8' == 56) \
      && ('9' == 57) && (':' == 58) && (';' == 59) && ('<' == 60) \
      && ('=' == 61) && ('>' == 62) && ('?' == 63) && ('A' == 65) \
      && ('B' == 66) && ('C' == 67) && ('D' == 68) && ('E' == 69) \
      && ('F' == 70) && ('G' == 71) && ('H' == 72) && ('I' == 73) \
      && ('J' == 74) && ('K' == 75) && ('L' == 76) && ('M' == 77) \
      && ('N' == 78) && ('O' == 79) && ('P' == 80) && ('Q' == 81) \
      && ('R' == 82) && ('S' == 83) && ('T' == 84) && ('U' == 85) \
      && ('V' == 86) && ('W' == 87) && ('X' == 88) && ('Y' == 89) \
      && ('Z' == 90) && ('[' == 91) && ('\\' == 92) && (']' == 93) \
      && ('^' == 94) && ('_' == 95) && ('a' == 97) && ('b' == 98) \
      && ('c' == 99) && ('d' == 100) && ('e' == 101) && ('f' == 102) \
      && ('g' == 103) && ('h' == 104) && ('i' == 105) && ('j' == 106) \
      && ('k' == 107) && ('l' == 108) && ('m' == 109) && ('n' == 110) \
      && ('o' == 111) && ('p' == 112) && ('q' == 113) && ('r' == 114) \
      && ('s' == 115) && ('t' == 116) && ('u' == 117) && ('v' == 118) \
      && ('w' == 119) && ('x' == 120) && ('y' == 121) && ('z' == 122) \
      && ('{' == 123) && ('|' == 124) && ('}' == 125) && ('~' == 126))
/* The character set is not based on ISO-646.  */
#error "gperf generated tables don't work with this execution character set. Please report a bug to <bug-gnu-gperf@gnu.org>."
#endif

#line 12 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
  /* -*- C -*- */
/*
  # gperf --language=ANSI-C -l -C --struct-type -C -I -P -S 1 -n xml10.gperf > xml10.c
  gperf -C --struct-type -P -n xml10.gperf > xml10.c
  cc -o xml10 xml10.c
*/
/* maximum key range = 131, duplicates = 0 */

#ifdef __GNUC__
__inline
#else
#ifdef __cplusplus
inline
#endif
#endif
static unsigned int
hash_xml10 (register const char *str, register unsigned int len)
{
  static const unsigned char asso_values[] =
    {
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131,  41, 131,  36, 131, 131,  31, 131,  26,
       55,  21,  50,  16,  11,  61,   0,  26, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
       15,   6,   5,   0, 131,   1,   2,   1,   1,  55,
       25, 131, 131,   0,  25, 131, 131,   0,   0,   6,
       20, 131, 131,  45,   1,  35, 131, 131, 131,   5,
      131,  30, 131,  20, 131, 131, 131, 131, 131, 131,
      131,   0, 131,   1, 131, 131, 131, 131,   1, 131,
       45,  11,  10, 131, 131,  60,  45, 131,  40, 131,
      131,  55, 131, 131,  60, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131, 131, 131, 131,
      131, 131, 131, 131, 131, 131, 131
    };
  register int hval = 0;

  switch (len)
    {
      default:
        hval += asso_values[(unsigned char)str[3]+1];
      /*FALLTHROUGH*/
      case 3:
      case 2:
      case 1:
        hval += asso_values[(unsigned char)str[0]];
        break;
    }
  return hval + asso_values[(unsigned char)str[len - 1]];
}

struct stringpool_xml10_t
  {
    char stringpool_xml10_str0[sizeof("?")];
    char stringpool_xml10_str1[sizeof("ID")];
    char stringpool_xml10_str2[sizeof("NOTATION")];
    char stringpool_xml10_str3[sizeof("?>")];
    char stringpool_xml10_str4[sizeof("ANY")];
    char stringpool_xml10_str5[sizeof(">")];
    char stringpool_xml10_str6[sizeof("encoding")];
    char stringpool_xml10_str7[sizeof("=")];
    char stringpool_xml10_str8[sizeof("<?")];
    char stringpool_xml10_str9[sizeof("<!ELEMENT")];
    char stringpool_xml10_str10[sizeof("NMTOKEN")];
    char stringpool_xml10_str11[sizeof("PUBLIC")];
    char stringpool_xml10_str12[sizeof(",")];
    char stringpool_xml10_str13[sizeof("]]>")];
    char stringpool_xml10_str14[sizeof("<!ENTITY")];
    char stringpool_xml10_str15[sizeof("<")];
    char stringpool_xml10_str16[sizeof("/>")];
    char stringpool_xml10_str17[sizeof("+")];
    char stringpool_xml10_str18[sizeof("<!NOTATION")];
    char stringpool_xml10_str19[sizeof("NDATA")];
    char stringpool_xml10_str20[sizeof("CDATA")];
    char stringpool_xml10_str21[sizeof("]")];
    char stringpool_xml10_str22[sizeof("</")];
    char stringpool_xml10_str23[sizeof(")")];
    char stringpool_xml10_str24[sizeof("<![")];
    char stringpool_xml10_str25[sizeof("<![CDATA[")];
    char stringpool_xml10_str26[sizeof("IDREF")];
    char stringpool_xml10_str27[sizeof("<!ATTLIST")];
    char stringpool_xml10_str28[sizeof("'")];
    char stringpool_xml10_str29[sizeof("INCLUDE")];
    char stringpool_xml10_str30[sizeof("no")];
    char stringpool_xml10_str31[sizeof("[")];
    char stringpool_xml10_str32[sizeof("<?xml")];
    char stringpool_xml10_str33[sizeof("%")];
    char stringpool_xml10_str34[sizeof("NMTOKENS")];
    char stringpool_xml10_str35[sizeof("-->")];
    char stringpool_xml10_str36[sizeof("IDREFS")];
    char stringpool_xml10_str37[sizeof("standalone")];
    char stringpool_xml10_str38[sizeof("\"")];
    char stringpool_xml10_str39[sizeof("IGNORE")];
    char stringpool_xml10_str40[sizeof("<!--")];
    char stringpool_xml10_str41[sizeof("SYSTEM")];
    char stringpool_xml10_str42[sizeof(" ")];
    char stringpool_xml10_str43[sizeof("ENTITY")];
    char stringpool_xml10_str44[sizeof("<!DOCTYPE")];
    char stringpool_xml10_str45[sizeof("EMPTY")];
    char stringpool_xml10_str46[sizeof("*")];
    char stringpool_xml10_str47[sizeof("(*")];
    char stringpool_xml10_str48[sizeof("(")];
    char stringpool_xml10_str49[sizeof("yes")];
    char stringpool_xml10_str50[sizeof("|")];
    char stringpool_xml10_str51[sizeof("ENTITIES")];
    char stringpool_xml10_str52[sizeof("version")];
  };
static const struct stringpool_xml10_t stringpool_xml10_contents =
  {
    "?",
    "ID",
    "NOTATION",
    "?>",
    "ANY",
    ">",
    "encoding",
    "=",
    "<?",
    "<!ELEMENT",
    "NMTOKEN",
    "PUBLIC",
    ",",
    "]]>",
    "<!ENTITY",
    "<",
    "/>",
    "+",
    "<!NOTATION",
    "NDATA",
    "CDATA",
    "]",
    "</",
    ")",
    "<![",
    "<![CDATA[",
    "IDREF",
    "<!ATTLIST",
    "'",
    "INCLUDE",
    "no",
    "[",
    "<?xml",
    "%",
    "NMTOKENS",
    "-->",
    "IDREFS",
    "standalone",
    "\"",
    "IGNORE",
    "<!--",
    "SYSTEM",
    " ",
    "ENTITY",
    "<!DOCTYPE",
    "EMPTY",
    "*",
    "(*",
    "(",
    "yes",
    "|",
    "ENTITIES",
    "version"
  };
#define stringpool_xml10 ((const char *) &stringpool_xml10_contents)
#ifdef __GNUC__
__inline
#if defined __GNUC_STDC_INLINE__ || defined __GNUC_GNU_INLINE__
__attribute__ ((__gnu_inline__))
#endif
#endif
const struct s_xml_token *
in_word_set_xml10 (register const char *str, register unsigned int len)
{
  enum
    {
      TOTAL_KEYWORDS = 53,
      MIN_WORD_LENGTH = 1,
      MAX_WORD_LENGTH = 10,
      MIN_HASH_VALUE = 0,
      MAX_HASH_VALUE = 130
    };

  static const struct s_xml_token wordlist_xml10[] =
    {
#line 33 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str0, "QUESTION_MARK"},
#line 62 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str1, "TYPE_ID"},
#line 69 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str2, "NOTATION"},
#line 44 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str3, "END"},
#line 57 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str4, "ANY"},
#line 32 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str5, "TAG_END"},
#line 80 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str6, "ENCODING"},
#line 28 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str7, "EQUAL"},
#line 43 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str8, "PI_BEG"},
#line 55 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str9, "ELEMENTDECL_BEG"},
#line 67 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str10, "TYPE_NMTOKEN"},
#line 78 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str11, "PUBLIC"},
#line 39 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str12, "COMMA"},
#line 46 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str13, "END2"},
#line 76 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str14, "EDECL_BEG"},
#line 31 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str15, "TAG_BEG"},
#line 54 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str16, "EMPTYELEMTAG_END"},
#line 35 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str17, "PLUS"},
#line 81 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str18, "NOTATION_BEG"},
#line 79 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str19, "NDATA"},
#line 61 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str20, "STRINGTYPE"},
#line 30 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str21, "RBRACKET"},
#line 53 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str22, "ETAG_BEG"},
#line 37 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str23, "RPAREN"},
#line 73 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str24, "SECT_BEG"},
#line 45 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str25, "CDSTART"},
#line 63 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str26, "TYPE_IDREF"},
#line 60 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str27, "ATTLIST_BEG"},
#line 27 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str28, "SQUOTE"},
#line 74 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str29, "INCLUDE"},
#line 52 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str30, "NO"},
#line 29 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str31, "LBRACKET"},
#line 47 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str32, "XML_BEG"},
#line 40 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str33, "PERCENT"},
#line 68 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str34, "TYPE_NMTOKENS"},
#line 42 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str35, "COMMENT_END"},
#line 64 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str36, "TYPE_IDREFS"},
#line 50 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str37, "STANDALONE"},
#line 26 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str38, "DQUOTE"},
#line 75 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str39, "IGNORE"},
#line 41 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str40, "COMMENT_BEG"},
#line 77 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str41, "SYSTEM"},
#line 25 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str42, "X20"},
#line 65 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str43, "TYPE_ENTITY"},
#line 49 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str44, "DOCTYPE_BEG"},
#line 56 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str45, "EMPTY"},
#line 34 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str46, "STAR"},
#line 58 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str47, "RPARENSTAR"},
#line 36 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str48, "LPAREN"},
#line 51 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str49, "YES"},
#line 38 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str50, "PIPE"},
#line 66 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str51, "TYPE_ENTITIES"},
#line 48 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"
      {(int)(long)&((struct stringpool_xml10_t *)0)->stringpool_xml10_str52, "VERSION"}
    };

  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
    {
      register int key = hash_xml10 (str, len);

      if (key <= MAX_HASH_VALUE && key >= MIN_HASH_VALUE)
        {
          register const struct s_xml_token *resword;

          switch (key)
            {
              case 0:
                resword = &wordlist_xml10[0];
                goto compare;
              case 1:
                resword = &wordlist_xml10[1];
                goto compare;
              case 2:
                resword = &wordlist_xml10[2];
                goto compare;
              case 5:
                resword = &wordlist_xml10[3];
                goto compare;
              case 6:
                resword = &wordlist_xml10[4];
                goto compare;
              case 10:
                resword = &wordlist_xml10[5];
                goto compare;
              case 11:
                resword = &wordlist_xml10[6];
                goto compare;
              case 12:
                resword = &wordlist_xml10[7];
                goto compare;
              case 15:
                resword = &wordlist_xml10[8];
                goto compare;
              case 16:
                resword = &wordlist_xml10[9];
                goto compare;
              case 20:
                resword = &wordlist_xml10[10];
                goto compare;
              case 21:
                resword = &wordlist_xml10[11];
                goto compare;
              case 22:
                resword = &wordlist_xml10[12];
                goto compare;
              case 25:
                resword = &wordlist_xml10[13];
                goto compare;
              case 26:
                resword = &wordlist_xml10[14];
                goto compare;
              case 30:
                resword = &wordlist_xml10[15];
                goto compare;
              case 31:
                resword = &wordlist_xml10[16];
                goto compare;
              case 32:
                resword = &wordlist_xml10[17];
                goto compare;
              case 35:
                resword = &wordlist_xml10[18];
                goto compare;
              case 36:
                resword = &wordlist_xml10[19];
                goto compare;
              case 37:
                resword = &wordlist_xml10[20];
                goto compare;
              case 40:
                resword = &wordlist_xml10[21];
                goto compare;
              case 41:
                resword = &wordlist_xml10[22];
                goto compare;
              case 42:
                resword = &wordlist_xml10[23];
                goto compare;
              case 45:
                resword = &wordlist_xml10[24];
                goto compare;
              case 46:
                resword = &wordlist_xml10[25];
                goto compare;
              case 50:
                resword = &wordlist_xml10[26];
                goto compare;
              case 51:
                resword = &wordlist_xml10[27];
                goto compare;
              case 52:
                resword = &wordlist_xml10[28];
                goto compare;
              case 55:
                resword = &wordlist_xml10[29];
                goto compare;
              case 56:
                resword = &wordlist_xml10[30];
                goto compare;
              case 60:
                resword = &wordlist_xml10[31];
                goto compare;
              case 61:
                resword = &wordlist_xml10[32];
                goto compare;
              case 62:
                resword = &wordlist_xml10[33];
                goto compare;
              case 65:
                resword = &wordlist_xml10[34];
                goto compare;
              case 66:
                resword = &wordlist_xml10[35];
                goto compare;
              case 70:
                resword = &wordlist_xml10[36];
                goto compare;
              case 71:
                resword = &wordlist_xml10[37];
                goto compare;
              case 72:
                resword = &wordlist_xml10[38];
                goto compare;
              case 75:
                resword = &wordlist_xml10[39];
                goto compare;
              case 76:
                resword = &wordlist_xml10[40];
                goto compare;
              case 80:
                resword = &wordlist_xml10[41];
                goto compare;
              case 82:
                resword = &wordlist_xml10[42];
                goto compare;
              case 85:
                resword = &wordlist_xml10[43];
                goto compare;
              case 90:
                resword = &wordlist_xml10[44];
                goto compare;
              case 95:
                resword = &wordlist_xml10[45];
                goto compare;
              case 100:
                resword = &wordlist_xml10[46];
                goto compare;
              case 105:
                resword = &wordlist_xml10[47];
                goto compare;
              case 110:
                resword = &wordlist_xml10[48];
                goto compare;
              case 115:
                resword = &wordlist_xml10[49];
                goto compare;
              case 120:
                resword = &wordlist_xml10[50];
                goto compare;
              case 125:
                resword = &wordlist_xml10[51];
                goto compare;
              case 130:
                resword = &wordlist_xml10[52];
                goto compare;
            }
          return 0;
        compare:
          {
            register const char *s = resword->name + stringpool_xml10;

            if (*str == *s && !strncmp (str + 1, s + 1, len - 1) && s[len] == '\0')
              return resword;
          }
        }
    }
  return 0;
}
#line 82 "lib/MarpaX/Languages/XML/AST/Grammar/XML_1_0/xml_1_0.gperf"

int
main (int argc, const char** argv)
{
  for (--argc, ++argv; argc; --argc, ++argv) {
    const struct s_xml_token *xml_token = in_word_set_xml10 (*argv, strlen (*argv));
    if (xml_token != NULL) {
      printf ("Ok: %s", xml_token->value);
    } else {
      printf ("Huh? What the f* `%s'?\n", *argv);
    }
  }
  return 0;
}
