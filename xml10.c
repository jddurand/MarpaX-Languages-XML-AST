/*
 * Tue Apr 15 12:59:47 2014
 *
 * Generated with:
 * perl GenerateLowLevel.pl --bnf bnf/xml10.bnf --prefix xml10 --output xml10.c
 *
 */

#ifndef XML10_C
#define XML10_C

#include "xmlTypes.h"

enum {
    /*   0 */ XML10___start_ = 0                      , /* [:start] (Internal G1 start symbol) */
    /*   1 */ XML10_document                          ,
    /*   2 */ XML10_prolog                            ,
    /*   3 */ XML10_element                           ,
    /*   4 */ XML10_MiscAny                           ,
    /*   5 */ XML10_Char                              ,
    /*   6 */ XML10_CHAR                              ,
    /*   7 */ XML10_Name                              ,
    /*   8 */ XML10_NAME                              ,
    /*   9 */ XML10_Names                             ,
    /*  10 */ XML10_x20                               ,
    /*  11 */ XML10_Nmtoken                           ,
    /*  12 */ XML10_NMTOKEN                           ,
    /*  13 */ XML10_Nmtokens                          ,
    /*  14 */ XML10_EntityValue                       ,
    /*  15 */ XML10_ENTITYVALUE                       ,
    /*  16 */ XML10_AttValue                          ,
    /*  17 */ XML10_ATTVALUE                          ,
    /*  18 */ XML10_SystemLiteral                     ,
    /*  19 */ XML10_SYSTEMLITERAL                     ,
    /*  20 */ XML10_PubidLiteral                      ,
    /*  21 */ XML10_PUBIDLITERAL                      ,
    /*  22 */ XML10_CharData                          ,
    /*  23 */ XML10_CHARDATA                          ,
    /*  24 */ XML10_Comment                           ,
    /*  25 */ XML10_CommentBeg                        ,
    /*  26 */ XML10_CommentInterior                   ,
    /*  27 */ XML10_CommentEnd                        ,
    /*  28 */ XML10_PITarget                          ,
    /*  29 */ XML10_PITARGET                          ,
    /*  30 */ XML10_PI                                ,
    /*  31 */ XML10_PiBeg                             ,
    /*  32 */ XML10_PiEnd                             ,
    /*  33 */ XML10_WhiteSpace                        ,
    /*  34 */ XML10_PiInterior                        ,
    /*  35 */ XML10_CDSect                            ,
    /*  36 */ XML10_CDStart                           ,
    /*  37 */ XML10_CData                             ,
    /*  38 */ XML10_CDEnd                             ,
    /*  39 */ XML10_CDSTART                           ,
    /*  40 */ XML10_CDATA                             ,
    /*  41 */ XML10_CDEND                             ,
    /*  42 */ XML10_XMLDeclMaybe                      ,
    /*  43 */ XML10_doctypedecl                       ,
    /*  44 */ XML10_XMLDecl                           ,
    /*  45 */ XML10_XmlBeg                            ,
    /*  46 */ XML10_VersionInfo                       ,
    /*  47 */ XML10_EncodingDeclMaybe                 ,
    /*  48 */ XML10_SDDeclMaybe                       ,
    /*  49 */ XML10_SMaybe                            ,
    /*  50 */ XML10_XmlEnd                            ,
    /*  51 */ XML10_Version                           ,
    /*  52 */ XML10_Eq                                ,
    /*  53 */ XML10_Squote                            ,
    /*  54 */ XML10_VersionNum                        ,
    /*  55 */ XML10_Dquote                            ,
    /*  56 */ XML10_Equal                             ,
    /*  57 */ XML10_VERSIONNUM                        ,
    /*  58 */ XML10_Misc                              ,
    /*  59 */ XML10_DoctypeBeg                        ,
    /*  60 */ XML10_DoctypeEnd                        ,
    /*  61 */ XML10_Lbracket                          ,
    /*  62 */ XML10_intSubset                         ,
    /*  63 */ XML10_Rbracket                          ,
    /*  64 */ XML10_ExternalID                        ,
    /*  65 */ XML10_DeclSep                           ,
    /*  66 */ XML10_PEReference                       ,
    /*  67 */ XML10_intSubsetUnitAny                  ,
    /*  68 */ XML10_markupdecl                        ,
    /*  69 */ XML10_elementdecl                       ,
    /*  70 */ XML10_AttlistDecl                       ,
    /*  71 */ XML10_EntityDecl                        ,
    /*  72 */ XML10_NotationDecl                      ,
    /*  73 */ XML10_extSubset                         ,
    /*  74 */ XML10_extSubsetDecl                     ,
    /*  75 */ XML10_TextDecl                          ,
    /*  76 */ XML10_extSubsetDeclUnitAny              ,
    /*  77 */ XML10_SDDecl                            ,
    /*  78 */ XML10_Standalone                        ,
    /*  79 */ XML10_Yes                               ,
    /*  80 */ XML10_No                                ,
    /*  81 */ XML10_EmptyElemTag                      ,
    /*  82 */ XML10_STag                              ,
    /*  83 */ XML10_content                           ,
    /*  84 */ XML10_ETag                              ,
    /*  85 */ XML10_STagBeg                           ,
    /*  86 */ XML10_STagInteriorAny                   ,
    /*  87 */ XML10_STagEnd                           ,
    /*  88 */ XML10_Attribute                         ,
    /*  89 */ XML10_ETagBeg                           ,
    /*  90 */ XML10_ETagEnd                           ,
    /*  91 */ XML10_CharDataMaybe                     ,
    /*  92 */ XML10_ContentInteriorAny                ,
    /*  93 */ XML10_EmptyElemTagBeg                   ,
    /*  94 */ XML10_EmptyElemTagInteriorAny           ,
    /*  95 */ XML10_EmptyElemTagEnd                   ,
    /*  96 */ XML10_ElementDeclBeg                    ,
    /*  97 */ XML10_contentspec                       ,
    /*  98 */ XML10_ElementDeclEnd                    ,
    /*  99 */ XML10_Empty                             ,
    /* 100 */ XML10_Any                               ,
    /* 101 */ XML10_Mixed                             ,
    /* 102 */ XML10_children                          ,
    /* 103 */ XML10_choice                            ,
    /* 104 */ XML10_QuantifierMaybe                   ,
    /* 105 */ XML10_seq                               ,
    /* 106 */ XML10_cp                                ,
    /* 107 */ XML10_Lparen                            ,
    /* 108 */ XML10_ChoiceInteriorMany                ,
    /* 109 */ XML10_Rparen                            ,
    /* 110 */ XML10_SeqInteriorAny                    ,
    /* 111 */ XML10_Pcdata                            ,
    /* 112 */ XML10_MixedInteriorAny                  ,
    /* 113 */ XML10_RparenStar                        ,
    /* 114 */ XML10_AttlistBeg                        ,
    /* 115 */ XML10_AttDefAny                         ,
    /* 116 */ XML10_AttlistEnd                        ,
    /* 117 */ XML10_AttDef                            ,
    /* 118 */ XML10_AttType                           ,
    /* 119 */ XML10_DefaultDecl                       ,
    /* 120 */ XML10_StringType                        ,
    /* 121 */ XML10_TokenizedType                     ,
    /* 122 */ XML10_EnumeratedType                    ,
    /* 123 */ XML10_STRINGTYPE                        ,
    /* 124 */ XML10_TypeId                            ,
    /* 125 */ XML10_TypeIdref                         ,
    /* 126 */ XML10_TypeIdrefs                        ,
    /* 127 */ XML10_TypeEntity                        ,
    /* 128 */ XML10_TypeEntities                      ,
    /* 129 */ XML10_TypeNmtoken                       ,
    /* 130 */ XML10_TypeNmtokens                      ,
    /* 131 */ XML10_NotationType                      ,
    /* 132 */ XML10_Enumeration                       ,
    /* 133 */ XML10_Notation                          ,
    /* 134 */ XML10_NotationTypeInteriorAny           ,
    /* 135 */ XML10_EnumerationInteriorAny            ,
    /* 136 */ XML10_Required                          ,
    /* 137 */ XML10_Implied                           ,
    /* 138 */ XML10_Fixed                             ,
    /* 139 */ XML10_conditionalSect                   ,
    /* 140 */ XML10_includeSect                       ,
    /* 141 */ XML10_ignoreSect                        ,
    /* 142 */ XML10_SectBeg                           ,
    /* 143 */ XML10_Include                           ,
    /* 144 */ XML10_SectEnd                           ,
    /* 145 */ XML10_TOKIgnore                         ,
    /* 146 */ XML10_ignoreSectContentsAny             ,
    /* 147 */ XML10_ignoreSectContents                ,
    /* 148 */ XML10_Ignore                            ,
    /* 149 */ XML10_ignoreSectContentsInteriorAny     ,
    /* 150 */ XML10_IGNORE_INTERIOR                   ,
    /* 151 */ XML10_CharRef                           ,
    /* 152 */ XML10_CHARREF                           ,
    /* 153 */ XML10_Reference                         ,
    /* 154 */ XML10_EntityRef                         ,
    /* 155 */ XML10_ENTITYREF                         ,
    /* 156 */ XML10_PEREFERENCE                       ,
    /* 157 */ XML10_GEDecl                            ,
    /* 158 */ XML10_PEDecl                            ,
    /* 159 */ XML10_EdeclBeg                          ,
    /* 160 */ XML10_EntityDef                         ,
    /* 161 */ XML10_EdeclEnd                          ,
    /* 162 */ XML10_Percent                           ,
    /* 163 */ XML10_PEDef                             ,
    /* 164 */ XML10_NDataDecl                         ,
    /* 165 */ XML10_System                            ,
    /* 166 */ XML10_Public                            ,
    /* 167 */ XML10_Ndata                             ,
    /* 168 */ XML10_VersionInfoMaybe                  ,
    /* 169 */ XML10_EncodingDecl                      ,
    /* 170 */ XML10_extParsedEnt                      ,
    /* 171 */ XML10_Encoding                          ,
    /* 172 */ XML10_EncName                           ,
    /* 173 */ XML10_ENCNAME                           ,
    /* 174 */ XML10_NotationBeg                       ,
    /* 175 */ XML10_NotationEnd                       ,
    /* 176 */ XML10_PublicID                          ,
    /* 177 */ XML10_X20                               ,
    /* 178 */ XML10_ContentInterior                   ,
    /* 179 */ XML10_intSubsetUnit                     ,
    /* 180 */ XML10_extSubsetDeclUnit                 ,
    /* 181 */ XML10_STagInterior                      ,
    /* 182 */ XML10_EmptyElemTagInterior              ,
    /* 183 */ XML10_Quantifier                        ,
    /* 184 */ XML10_QuestionMark                      ,
    /* 185 */ XML10_Star                              ,
    /* 186 */ XML10_Plus                              ,
    /* 187 */ XML10_ChoiceInterior                    ,
    /* 188 */ XML10_Pipe                              ,
    /* 189 */ XML10_SeqInterior                       ,
    /* 190 */ XML10_Comma                             ,
    /* 191 */ XML10_MixedInterior                     ,
    /* 192 */ XML10_NotationTypeInterior              ,
    /* 193 */ XML10_EnumerationInterior               ,
    /* 194 */ XML10_ignoreSectContentsInterior        ,
    /* 195 */ XML10_S                                 ,
    /* 196 */ XML10_COMMENT_BEG                       ,
    /* 197 */ XML10_COMMENT_END                       ,
    /* 198 */ XML10_COMMENT                           ,
    /* 199 */ XML10_PI_INTERIOR                       ,
    /* 200 */ XML10_XML_BEG                           ,
    /* 201 */ XML10_XML_END                           ,
    /* 202 */ XML10_VERSION                           ,
    /* 203 */ XML10_SQUOTE                            ,
    /* 204 */ XML10_DQUOTE                            ,
    /* 205 */ XML10_EQUAL                             ,
    /* 206 */ XML10_DOCTYPE_BEG                       ,
    /* 207 */ XML10_XTagEnd                           ,
    /* 208 */ XML10_LBRACKET                          ,
    /* 209 */ XML10_RBRACKET                          ,
    /* 210 */ XML10_STANDALONE                        ,
    /* 211 */ XML10_YES                               ,
    /* 212 */ XML10_NO                                ,
    /* 213 */ XML10_XTagBeg                           ,
    /* 214 */ XML10_XTAG_BEG                          ,
    /* 215 */ XML10_XTAG_END                          ,
    /* 216 */ XML10_STAG_END                          ,
    /* 217 */ XML10_ETAG_BEG                          ,
    /* 218 */ XML10_ETAG_END                          ,
    /* 219 */ XML10_EMPTYELEMTAG_END                  ,
    /* 220 */ XML10_ELEMENTDECL_BEG                   ,
    /* 221 */ XML10_EMPTY                             ,
    /* 222 */ XML10_ANY                               ,
    /* 223 */ XML10_QUESTION_MARK                     ,
    /* 224 */ XML10_STAR                              ,
    /* 225 */ XML10_PLUS                              ,
    /* 226 */ XML10_LPAREN                            ,
    /* 227 */ XML10_RPAREN                            ,
    /* 228 */ XML10_RPARENSTAR                        ,
    /* 229 */ XML10_PIPE                              ,
    /* 230 */ XML10_COMMA                             ,
    /* 231 */ XML10_ATTLIST_BEG                       ,
    /* 232 */ XML10_TYPE_ID                           ,
    /* 233 */ XML10_TYPE_IDREF                        ,
    /* 234 */ XML10_TYPE_IDREFS                       ,
    /* 235 */ XML10_TYPE_ENTITY                       ,
    /* 236 */ XML10_TYPE_ENTITIES                     ,
    /* 237 */ XML10_TYPE_NMTOKEN                      ,
    /* 238 */ XML10_TYPE_NMTOKENS                     ,
    /* 239 */ XML10_NOTATION                          ,
    /* 240 */ XML10_NOTATION_BEG                      ,
    /* 241 */ XML10_REQUIRED                          ,
    /* 242 */ XML10_IMPLIED                           ,
    /* 243 */ XML10_FIXED                             ,
    /* 244 */ XML10_SECT_BEG                          ,
    /* 245 */ XML10_SECT_END                          ,
    /* 246 */ XML10_INCLUDE                           ,
    /* 247 */ XML10_EDECL_BEG                         ,
    /* 248 */ XML10_PERCENT                           ,
    /* 249 */ XML10_SYSTEM                            ,
    /* 250 */ XML10_PUBLIC                            ,
    /* 251 */ XML10_NDATA                             ,
    /* 252 */ XML10_ENCODING                          ,
    /* 253 */ XML10_IGNORE                            ,
    /* 254 */ XML10_PCDATA                            ,
    /* 255 */ XML10_PI_BEG                            ,
    /* 256 */ XML10_PI_END                            ,
};
struct sXmlSymbolId aXml10SymbolId[] = {
   /*
    * Id, Name                                    , Description
    */
    { -1, "[:start]"                              , "Internal G1 start symbol" }, /* enum: XML10___start_ */
    { -1, "document"                              , "document" }, /* enum: XML10_document */
    { -1, "prolog"                                , "prolog" }, /* enum: XML10_prolog */
    { -1, "element"                               , "element" }, /* enum: XML10_element */
    { -1, "MiscAny"                               , "MiscAny" }, /* enum: XML10_MiscAny */
    { -1, "Char"                                  , "Char" }, /* enum: XML10_Char */
    { -1, "CHAR"                                  , "CHAR" }, /* enum: XML10_CHAR */
    { -1, "Name"                                  , "Name" }, /* enum: XML10_Name */
    { -1, "NAME"                                  , "NAME" }, /* enum: XML10_NAME */
    { -1, "Names"                                 , "Names" }, /* enum: XML10_Names */
    { -1, "x20"                                   , "x20" }, /* enum: XML10_x20 */
    { -1, "Nmtoken"                               , "Nmtoken" }, /* enum: XML10_Nmtoken */
    { -1, "NMTOKEN"                               , "NMTOKEN" }, /* enum: XML10_NMTOKEN */
    { -1, "Nmtokens"                              , "Nmtokens" }, /* enum: XML10_Nmtokens */
    { -1, "EntityValue"                           , "EntityValue" }, /* enum: XML10_EntityValue */
    { -1, "ENTITYVALUE"                           , "ENTITYVALUE" }, /* enum: XML10_ENTITYVALUE */
    { -1, "AttValue"                              , "AttValue" }, /* enum: XML10_AttValue */
    { -1, "ATTVALUE"                              , "ATTVALUE" }, /* enum: XML10_ATTVALUE */
    { -1, "SystemLiteral"                         , "SystemLiteral" }, /* enum: XML10_SystemLiteral */
    { -1, "SYSTEMLITERAL"                         , "SYSTEMLITERAL" }, /* enum: XML10_SYSTEMLITERAL */
    { -1, "PubidLiteral"                          , "PubidLiteral" }, /* enum: XML10_PubidLiteral */
    { -1, "PUBIDLITERAL"                          , "PUBIDLITERAL" }, /* enum: XML10_PUBIDLITERAL */
    { -1, "CharData"                              , "CharData" }, /* enum: XML10_CharData */
    { -1, "CHARDATA"                              , "CHARDATA" }, /* enum: XML10_CHARDATA */
    { -1, "Comment"                               , "Comment" }, /* enum: XML10_Comment */
    { -1, "CommentBeg"                            , "CommentBeg" }, /* enum: XML10_CommentBeg */
    { -1, "CommentInterior"                       , "CommentInterior" }, /* enum: XML10_CommentInterior */
    { -1, "CommentEnd"                            , "CommentEnd" }, /* enum: XML10_CommentEnd */
    { -1, "PITarget"                              , "PITarget" }, /* enum: XML10_PITarget */
    { -1, "PITARGET"                              , "PITARGET" }, /* enum: XML10_PITARGET */
    { -1, "PI"                                    , "PI" }, /* enum: XML10_PI */
    { -1, "PiBeg"                                 , "PiBeg" }, /* enum: XML10_PiBeg */
    { -1, "PiEnd"                                 , "PiEnd" }, /* enum: XML10_PiEnd */
    { -1, "WhiteSpace"                            , "WhiteSpace" }, /* enum: XML10_WhiteSpace */
    { -1, "PiInterior"                            , "PiInterior" }, /* enum: XML10_PiInterior */
    { -1, "CDSect"                                , "CDSect" }, /* enum: XML10_CDSect */
    { -1, "CDStart"                               , "CDStart" }, /* enum: XML10_CDStart */
    { -1, "CData"                                 , "CData" }, /* enum: XML10_CData */
    { -1, "CDEnd"                                 , "CDEnd" }, /* enum: XML10_CDEnd */
    { -1, "CDSTART"                               , "CDSTART" }, /* enum: XML10_CDSTART */
    { -1, "CDATA"                                 , "CDATA" }, /* enum: XML10_CDATA */
    { -1, "CDEND"                                 , "CDEND" }, /* enum: XML10_CDEND */
    { -1, "XMLDeclMaybe"                          , "XMLDeclMaybe" }, /* enum: XML10_XMLDeclMaybe */
    { -1, "doctypedecl"                           , "doctypedecl" }, /* enum: XML10_doctypedecl */
    { -1, "XMLDecl"                               , "XMLDecl" }, /* enum: XML10_XMLDecl */
    { -1, "XmlBeg"                                , "XmlBeg" }, /* enum: XML10_XmlBeg */
    { -1, "VersionInfo"                           , "VersionInfo" }, /* enum: XML10_VersionInfo */
    { -1, "EncodingDeclMaybe"                     , "EncodingDeclMaybe" }, /* enum: XML10_EncodingDeclMaybe */
    { -1, "SDDeclMaybe"                           , "SDDeclMaybe" }, /* enum: XML10_SDDeclMaybe */
    { -1, "SMaybe"                                , "SMaybe" }, /* enum: XML10_SMaybe */
    { -1, "XmlEnd"                                , "XmlEnd" }, /* enum: XML10_XmlEnd */
    { -1, "Version"                               , "Version" }, /* enum: XML10_Version */
    { -1, "Eq"                                    , "Eq" }, /* enum: XML10_Eq */
    { -1, "Squote"                                , "Squote" }, /* enum: XML10_Squote */
    { -1, "VersionNum"                            , "VersionNum" }, /* enum: XML10_VersionNum */
    { -1, "Dquote"                                , "Dquote" }, /* enum: XML10_Dquote */
    { -1, "Equal"                                 , "Equal" }, /* enum: XML10_Equal */
    { -1, "VERSIONNUM"                            , "VERSIONNUM" }, /* enum: XML10_VERSIONNUM */
    { -1, "Misc"                                  , "Misc" }, /* enum: XML10_Misc */
    { -1, "DoctypeBeg"                            , "DoctypeBeg" }, /* enum: XML10_DoctypeBeg */
    { -1, "DoctypeEnd"                            , "DoctypeEnd" }, /* enum: XML10_DoctypeEnd */
    { -1, "Lbracket"                              , "Lbracket" }, /* enum: XML10_Lbracket */
    { -1, "intSubset"                             , "intSubset" }, /* enum: XML10_intSubset */
    { -1, "Rbracket"                              , "Rbracket" }, /* enum: XML10_Rbracket */
    { -1, "ExternalID"                            , "ExternalID" }, /* enum: XML10_ExternalID */
    { -1, "DeclSep"                               , "DeclSep" }, /* enum: XML10_DeclSep */
    { -1, "PEReference"                           , "PEReference" }, /* enum: XML10_PEReference */
    { -1, "intSubsetUnitAny"                      , "intSubsetUnitAny" }, /* enum: XML10_intSubsetUnitAny */
    { -1, "markupdecl"                            , "markupdecl" }, /* enum: XML10_markupdecl */
    { -1, "elementdecl"                           , "elementdecl" }, /* enum: XML10_elementdecl */
    { -1, "AttlistDecl"                           , "AttlistDecl" }, /* enum: XML10_AttlistDecl */
    { -1, "EntityDecl"                            , "EntityDecl" }, /* enum: XML10_EntityDecl */
    { -1, "NotationDecl"                          , "NotationDecl" }, /* enum: XML10_NotationDecl */
    { -1, "extSubset"                             , "extSubset" }, /* enum: XML10_extSubset */
    { -1, "extSubsetDecl"                         , "extSubsetDecl" }, /* enum: XML10_extSubsetDecl */
    { -1, "TextDecl"                              , "TextDecl" }, /* enum: XML10_TextDecl */
    { -1, "extSubsetDeclUnitAny"                  , "extSubsetDeclUnitAny" }, /* enum: XML10_extSubsetDeclUnitAny */
    { -1, "SDDecl"                                , "SDDecl" }, /* enum: XML10_SDDecl */
    { -1, "Standalone"                            , "Standalone" }, /* enum: XML10_Standalone */
    { -1, "Yes"                                   , "Yes" }, /* enum: XML10_Yes */
    { -1, "No"                                    , "No" }, /* enum: XML10_No */
    { -1, "EmptyElemTag"                          , "EmptyElemTag" }, /* enum: XML10_EmptyElemTag */
    { -1, "STag"                                  , "STag" }, /* enum: XML10_STag */
    { -1, "content"                               , "content" }, /* enum: XML10_content */
    { -1, "ETag"                                  , "ETag" }, /* enum: XML10_ETag */
    { -1, "STagBeg"                               , "STagBeg" }, /* enum: XML10_STagBeg */
    { -1, "STagInteriorAny"                       , "STagInteriorAny" }, /* enum: XML10_STagInteriorAny */
    { -1, "STagEnd"                               , "STagEnd" }, /* enum: XML10_STagEnd */
    { -1, "Attribute"                             , "Attribute" }, /* enum: XML10_Attribute */
    { -1, "ETagBeg"                               , "ETagBeg" }, /* enum: XML10_ETagBeg */
    { -1, "ETagEnd"                               , "ETagEnd" }, /* enum: XML10_ETagEnd */
    { -1, "CharDataMaybe"                         , "CharDataMaybe" }, /* enum: XML10_CharDataMaybe */
    { -1, "ContentInteriorAny"                    , "ContentInteriorAny" }, /* enum: XML10_ContentInteriorAny */
    { -1, "EmptyElemTagBeg"                       , "EmptyElemTagBeg" }, /* enum: XML10_EmptyElemTagBeg */
    { -1, "EmptyElemTagInteriorAny"               , "EmptyElemTagInteriorAny" }, /* enum: XML10_EmptyElemTagInteriorAny */
    { -1, "EmptyElemTagEnd"                       , "EmptyElemTagEnd" }, /* enum: XML10_EmptyElemTagEnd */
    { -1, "ElementDeclBeg"                        , "ElementDeclBeg" }, /* enum: XML10_ElementDeclBeg */
    { -1, "contentspec"                           , "contentspec" }, /* enum: XML10_contentspec */
    { -1, "ElementDeclEnd"                        , "ElementDeclEnd" }, /* enum: XML10_ElementDeclEnd */
    { -1, "Empty"                                 , "Empty" }, /* enum: XML10_Empty */
    { -1, "Any"                                   , "Any" }, /* enum: XML10_Any */
    { -1, "Mixed"                                 , "Mixed" }, /* enum: XML10_Mixed */
    { -1, "children"                              , "children" }, /* enum: XML10_children */
    { -1, "choice"                                , "choice" }, /* enum: XML10_choice */
    { -1, "QuantifierMaybe"                       , "QuantifierMaybe" }, /* enum: XML10_QuantifierMaybe */
    { -1, "seq"                                   , "seq" }, /* enum: XML10_seq */
    { -1, "cp"                                    , "cp" }, /* enum: XML10_cp */
    { -1, "Lparen"                                , "Lparen" }, /* enum: XML10_Lparen */
    { -1, "ChoiceInteriorMany"                    , "ChoiceInteriorMany" }, /* enum: XML10_ChoiceInteriorMany */
    { -1, "Rparen"                                , "Rparen" }, /* enum: XML10_Rparen */
    { -1, "SeqInteriorAny"                        , "SeqInteriorAny" }, /* enum: XML10_SeqInteriorAny */
    { -1, "Pcdata"                                , "Pcdata" }, /* enum: XML10_Pcdata */
    { -1, "MixedInteriorAny"                      , "MixedInteriorAny" }, /* enum: XML10_MixedInteriorAny */
    { -1, "RparenStar"                            , "RparenStar" }, /* enum: XML10_RparenStar */
    { -1, "AttlistBeg"                            , "AttlistBeg" }, /* enum: XML10_AttlistBeg */
    { -1, "AttDefAny"                             , "AttDefAny" }, /* enum: XML10_AttDefAny */
    { -1, "AttlistEnd"                            , "AttlistEnd" }, /* enum: XML10_AttlistEnd */
    { -1, "AttDef"                                , "AttDef" }, /* enum: XML10_AttDef */
    { -1, "AttType"                               , "AttType" }, /* enum: XML10_AttType */
    { -1, "DefaultDecl"                           , "DefaultDecl" }, /* enum: XML10_DefaultDecl */
    { -1, "StringType"                            , "StringType" }, /* enum: XML10_StringType */
    { -1, "TokenizedType"                         , "TokenizedType" }, /* enum: XML10_TokenizedType */
    { -1, "EnumeratedType"                        , "EnumeratedType" }, /* enum: XML10_EnumeratedType */
    { -1, "STRINGTYPE"                            , "STRINGTYPE" }, /* enum: XML10_STRINGTYPE */
    { -1, "TypeId"                                , "TypeId" }, /* enum: XML10_TypeId */
    { -1, "TypeIdref"                             , "TypeIdref" }, /* enum: XML10_TypeIdref */
    { -1, "TypeIdrefs"                            , "TypeIdrefs" }, /* enum: XML10_TypeIdrefs */
    { -1, "TypeEntity"                            , "TypeEntity" }, /* enum: XML10_TypeEntity */
    { -1, "TypeEntities"                          , "TypeEntities" }, /* enum: XML10_TypeEntities */
    { -1, "TypeNmtoken"                           , "TypeNmtoken" }, /* enum: XML10_TypeNmtoken */
    { -1, "TypeNmtokens"                          , "TypeNmtokens" }, /* enum: XML10_TypeNmtokens */
    { -1, "NotationType"                          , "NotationType" }, /* enum: XML10_NotationType */
    { -1, "Enumeration"                           , "Enumeration" }, /* enum: XML10_Enumeration */
    { -1, "Notation"                              , "Notation" }, /* enum: XML10_Notation */
    { -1, "NotationTypeInteriorAny"               , "NotationTypeInteriorAny" }, /* enum: XML10_NotationTypeInteriorAny */
    { -1, "EnumerationInteriorAny"                , "EnumerationInteriorAny" }, /* enum: XML10_EnumerationInteriorAny */
    { -1, "Required"                              , "Required" }, /* enum: XML10_Required */
    { -1, "Implied"                               , "Implied" }, /* enum: XML10_Implied */
    { -1, "Fixed"                                 , "Fixed" }, /* enum: XML10_Fixed */
    { -1, "conditionalSect"                       , "conditionalSect" }, /* enum: XML10_conditionalSect */
    { -1, "includeSect"                           , "includeSect" }, /* enum: XML10_includeSect */
    { -1, "ignoreSect"                            , "ignoreSect" }, /* enum: XML10_ignoreSect */
    { -1, "SectBeg"                               , "SectBeg" }, /* enum: XML10_SectBeg */
    { -1, "Include"                               , "Include" }, /* enum: XML10_Include */
    { -1, "SectEnd"                               , "SectEnd" }, /* enum: XML10_SectEnd */
    { -1, "TOKIgnore"                             , "TOKIgnore" }, /* enum: XML10_TOKIgnore */
    { -1, "ignoreSectContentsAny"                 , "ignoreSectContentsAny" }, /* enum: XML10_ignoreSectContentsAny */
    { -1, "ignoreSectContents"                    , "ignoreSectContents" }, /* enum: XML10_ignoreSectContents */
    { -1, "Ignore"                                , "Ignore" }, /* enum: XML10_Ignore */
    { -1, "ignoreSectContentsInteriorAny"         , "ignoreSectContentsInteriorAny" }, /* enum: XML10_ignoreSectContentsInteriorAny */
    { -1, "IGNORE_INTERIOR"                       , "IGNORE_INTERIOR" }, /* enum: XML10_IGNORE_INTERIOR */
    { -1, "CharRef"                               , "CharRef" }, /* enum: XML10_CharRef */
    { -1, "CHARREF"                               , "CHARREF" }, /* enum: XML10_CHARREF */
    { -1, "Reference"                             , "Reference" }, /* enum: XML10_Reference */
    { -1, "EntityRef"                             , "EntityRef" }, /* enum: XML10_EntityRef */
    { -1, "ENTITYREF"                             , "ENTITYREF" }, /* enum: XML10_ENTITYREF */
    { -1, "PEREFERENCE"                           , "PEREFERENCE" }, /* enum: XML10_PEREFERENCE */
    { -1, "GEDecl"                                , "GEDecl" }, /* enum: XML10_GEDecl */
    { -1, "PEDecl"                                , "PEDecl" }, /* enum: XML10_PEDecl */
    { -1, "EdeclBeg"                              , "EdeclBeg" }, /* enum: XML10_EdeclBeg */
    { -1, "EntityDef"                             , "EntityDef" }, /* enum: XML10_EntityDef */
    { -1, "EdeclEnd"                              , "EdeclEnd" }, /* enum: XML10_EdeclEnd */
    { -1, "Percent"                               , "Percent" }, /* enum: XML10_Percent */
    { -1, "PEDef"                                 , "PEDef" }, /* enum: XML10_PEDef */
    { -1, "NDataDecl"                             , "NDataDecl" }, /* enum: XML10_NDataDecl */
    { -1, "System"                                , "System" }, /* enum: XML10_System */
    { -1, "Public"                                , "Public" }, /* enum: XML10_Public */
    { -1, "Ndata"                                 , "Ndata" }, /* enum: XML10_Ndata */
    { -1, "VersionInfoMaybe"                      , "VersionInfoMaybe" }, /* enum: XML10_VersionInfoMaybe */
    { -1, "EncodingDecl"                          , "EncodingDecl" }, /* enum: XML10_EncodingDecl */
    { -1, "extParsedEnt"                          , "extParsedEnt" }, /* enum: XML10_extParsedEnt */
    { -1, "Encoding"                              , "Encoding" }, /* enum: XML10_Encoding */
    { -1, "EncName"                               , "EncName" }, /* enum: XML10_EncName */
    { -1, "ENCNAME"                               , "ENCNAME" }, /* enum: XML10_ENCNAME */
    { -1, "NotationBeg"                           , "NotationBeg" }, /* enum: XML10_NotationBeg */
    { -1, "NotationEnd"                           , "NotationEnd" }, /* enum: XML10_NotationEnd */
    { -1, "PublicID"                              , "PublicID" }, /* enum: XML10_PublicID */
    { -1, "X20"                                   , "X20" }, /* enum: XML10_X20 */
    { -1, "ContentInterior"                       , "ContentInterior" }, /* enum: XML10_ContentInterior */
    { -1, "intSubsetUnit"                         , "intSubsetUnit" }, /* enum: XML10_intSubsetUnit */
    { -1, "extSubsetDeclUnit"                     , "extSubsetDeclUnit" }, /* enum: XML10_extSubsetDeclUnit */
    { -1, "STagInterior"                          , "STagInterior" }, /* enum: XML10_STagInterior */
    { -1, "EmptyElemTagInterior"                  , "EmptyElemTagInterior" }, /* enum: XML10_EmptyElemTagInterior */
    { -1, "Quantifier"                            , "Quantifier" }, /* enum: XML10_Quantifier */
    { -1, "QuestionMark"                          , "QuestionMark" }, /* enum: XML10_QuestionMark */
    { -1, "Star"                                  , "Star" }, /* enum: XML10_Star */
    { -1, "Plus"                                  , "Plus" }, /* enum: XML10_Plus */
    { -1, "ChoiceInterior"                        , "ChoiceInterior" }, /* enum: XML10_ChoiceInterior */
    { -1, "Pipe"                                  , "Pipe" }, /* enum: XML10_Pipe */
    { -1, "SeqInterior"                           , "SeqInterior" }, /* enum: XML10_SeqInterior */
    { -1, "Comma"                                 , "Comma" }, /* enum: XML10_Comma */
    { -1, "MixedInterior"                         , "MixedInterior" }, /* enum: XML10_MixedInterior */
    { -1, "NotationTypeInterior"                  , "NotationTypeInterior" }, /* enum: XML10_NotationTypeInterior */
    { -1, "EnumerationInterior"                   , "EnumerationInterior" }, /* enum: XML10_EnumerationInterior */
    { -1, "ignoreSectContentsInterior"            , "ignoreSectContentsInterior" }, /* enum: XML10_ignoreSectContentsInterior */
    { -1, "S"                                     , "S" }, /* enum: XML10_S */
    { -1, "COMMENT_BEG"                           , "COMMENT_BEG" }, /* enum: XML10_COMMENT_BEG */
    { -1, "COMMENT_END"                           , "COMMENT_END" }, /* enum: XML10_COMMENT_END */
    { -1, "COMMENT"                               , "COMMENT" }, /* enum: XML10_COMMENT */
    { -1, "PI_INTERIOR"                           , "PI_INTERIOR" }, /* enum: XML10_PI_INTERIOR */
    { -1, "XML_BEG"                               , "XML_BEG" }, /* enum: XML10_XML_BEG */
    { -1, "XML_END"                               , "XML_END" }, /* enum: XML10_XML_END */
    { -1, "VERSION"                               , "VERSION" }, /* enum: XML10_VERSION */
    { -1, "SQUOTE"                                , "SQUOTE" }, /* enum: XML10_SQUOTE */
    { -1, "DQUOTE"                                , "DQUOTE" }, /* enum: XML10_DQUOTE */
    { -1, "EQUAL"                                 , "EQUAL" }, /* enum: XML10_EQUAL */
    { -1, "DOCTYPE_BEG"                           , "DOCTYPE_BEG" }, /* enum: XML10_DOCTYPE_BEG */
    { -1, "XTagEnd"                               , "XTagEnd" }, /* enum: XML10_XTagEnd */
    { -1, "LBRACKET"                              , "LBRACKET" }, /* enum: XML10_LBRACKET */
    { -1, "RBRACKET"                              , "RBRACKET" }, /* enum: XML10_RBRACKET */
    { -1, "STANDALONE"                            , "STANDALONE" }, /* enum: XML10_STANDALONE */
    { -1, "YES"                                   , "YES" }, /* enum: XML10_YES */
    { -1, "NO"                                    , "NO" }, /* enum: XML10_NO */
    { -1, "XTagBeg"                               , "XTagBeg" }, /* enum: XML10_XTagBeg */
    { -1, "XTAG_BEG"                              , "XTAG_BEG" }, /* enum: XML10_XTAG_BEG */
    { -1, "XTAG_END"                              , "XTAG_END" }, /* enum: XML10_XTAG_END */
    { -1, "STAG_END"                              , "STAG_END" }, /* enum: XML10_STAG_END */
    { -1, "ETAG_BEG"                              , "ETAG_BEG" }, /* enum: XML10_ETAG_BEG */
    { -1, "ETAG_END"                              , "ETAG_END" }, /* enum: XML10_ETAG_END */
    { -1, "EMPTYELEMTAG_END"                      , "EMPTYELEMTAG_END" }, /* enum: XML10_EMPTYELEMTAG_END */
    { -1, "ELEMENTDECL_BEG"                       , "ELEMENTDECL_BEG" }, /* enum: XML10_ELEMENTDECL_BEG */
    { -1, "EMPTY"                                 , "EMPTY" }, /* enum: XML10_EMPTY */
    { -1, "ANY"                                   , "ANY" }, /* enum: XML10_ANY */
    { -1, "QUESTION_MARK"                         , "QUESTION_MARK" }, /* enum: XML10_QUESTION_MARK */
    { -1, "STAR"                                  , "STAR" }, /* enum: XML10_STAR */
    { -1, "PLUS"                                  , "PLUS" }, /* enum: XML10_PLUS */
    { -1, "LPAREN"                                , "LPAREN" }, /* enum: XML10_LPAREN */
    { -1, "RPAREN"                                , "RPAREN" }, /* enum: XML10_RPAREN */
    { -1, "RPARENSTAR"                            , "RPARENSTAR" }, /* enum: XML10_RPARENSTAR */
    { -1, "PIPE"                                  , "PIPE" }, /* enum: XML10_PIPE */
    { -1, "COMMA"                                 , "COMMA" }, /* enum: XML10_COMMA */
    { -1, "ATTLIST_BEG"                           , "ATTLIST_BEG" }, /* enum: XML10_ATTLIST_BEG */
    { -1, "TYPE_ID"                               , "TYPE_ID" }, /* enum: XML10_TYPE_ID */
    { -1, "TYPE_IDREF"                            , "TYPE_IDREF" }, /* enum: XML10_TYPE_IDREF */
    { -1, "TYPE_IDREFS"                           , "TYPE_IDREFS" }, /* enum: XML10_TYPE_IDREFS */
    { -1, "TYPE_ENTITY"                           , "TYPE_ENTITY" }, /* enum: XML10_TYPE_ENTITY */
    { -1, "TYPE_ENTITIES"                         , "TYPE_ENTITIES" }, /* enum: XML10_TYPE_ENTITIES */
    { -1, "TYPE_NMTOKEN"                          , "TYPE_NMTOKEN" }, /* enum: XML10_TYPE_NMTOKEN */
    { -1, "TYPE_NMTOKENS"                         , "TYPE_NMTOKENS" }, /* enum: XML10_TYPE_NMTOKENS */
    { -1, "NOTATION"                              , "NOTATION" }, /* enum: XML10_NOTATION */
    { -1, "NOTATION_BEG"                          , "NOTATION_BEG" }, /* enum: XML10_NOTATION_BEG */
    { -1, "REQUIRED"                              , "REQUIRED" }, /* enum: XML10_REQUIRED */
    { -1, "IMPLIED"                               , "IMPLIED" }, /* enum: XML10_IMPLIED */
    { -1, "FIXED"                                 , "FIXED" }, /* enum: XML10_FIXED */
    { -1, "SECT_BEG"                              , "SECT_BEG" }, /* enum: XML10_SECT_BEG */
    { -1, "SECT_END"                              , "SECT_END" }, /* enum: XML10_SECT_END */
    { -1, "INCLUDE"                               , "INCLUDE" }, /* enum: XML10_INCLUDE */
    { -1, "EDECL_BEG"                             , "EDECL_BEG" }, /* enum: XML10_EDECL_BEG */
    { -1, "PERCENT"                               , "PERCENT" }, /* enum: XML10_PERCENT */
    { -1, "SYSTEM"                                , "SYSTEM" }, /* enum: XML10_SYSTEM */
    { -1, "PUBLIC"                                , "PUBLIC" }, /* enum: XML10_PUBLIC */
    { -1, "NDATA"                                 , "NDATA" }, /* enum: XML10_NDATA */
    { -1, "ENCODING"                              , "ENCODING" }, /* enum: XML10_ENCODING */
    { -1, "IGNORE"                                , "IGNORE" }, /* enum: XML10_IGNORE */
    { -1, "PCDATA"                                , "PCDATA" }, /* enum: XML10_PCDATA */
    { -1, "PI_BEG"                                , "PI_BEG" }, /* enum: XML10_PI_BEG */
    { -1, "PI_END"                                , "PI_END" }, /* enum: XML10_PI_END */
};

#define XML10_NUMBER_OF_SYMBOLS 257

static void _fillXml10G(g)
    Marpa_Grammar g;
{
    /* Create all the symbols */
    _fillSymbols(g, XML10_NUMBER_OF_SYMBOLS, aXml10SymbolId);

    /* Populate the rules */
    { /* document ::= prolog element MiscAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_prolog], aXml10SymbolId[XML10_element], aXml10SymbolId[XML10_MiscAny]};
        _fillRule(g, aXml10SymbolId[XML10_document] , 3, &(RhsId[0]));
    }
    { /* Char ::= CHAR */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CHAR]};
        _fillRule(g, aXml10SymbolId[XML10_Char] , 1, &(RhsId[0]));
    }
    { /* SystemLiteral ::= SYSTEMLITERAL */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SYSTEMLITERAL]};
        _fillRule(g, aXml10SymbolId[XML10_SystemLiteral] , 1, &(RhsId[0]));
    }
    { /* Reference ::= EntityRef */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EntityRef]};
        _fillRule(g, aXml10SymbolId[XML10_Reference] , 1, &(RhsId[0]));
    }
    { /* Reference ::= CharRef */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CharRef]};
        _fillRule(g, aXml10SymbolId[XML10_Reference] , 1, &(RhsId[0]));
    }
    { /* EntityRef ::= ENTITYREF */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ENTITYREF]};
        _fillRule(g, aXml10SymbolId[XML10_EntityRef] , 1, &(RhsId[0]));
    }
    { /* PEReference ::= PEREFERENCE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PEREFERENCE]};
        _fillRule(g, aXml10SymbolId[XML10_PEReference] , 1, &(RhsId[0]));
    }
    { /* EntityDecl ::= GEDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_GEDecl]};
        _fillRule(g, aXml10SymbolId[XML10_EntityDecl] , 1, &(RhsId[0]));
    }
    { /* EntityDecl ::= PEDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PEDecl]};
        _fillRule(g, aXml10SymbolId[XML10_EntityDecl] , 1, &(RhsId[0]));
    }
    { /* GEDecl ::= EdeclBeg WhiteSpace Name WhiteSpace EntityDef SMaybe EdeclEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EdeclBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_EntityDef], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_EdeclEnd]};
        _fillRule(g, aXml10SymbolId[XML10_GEDecl] , 7, &(RhsId[0]));
    }
    { /* PEDecl ::= EdeclBeg WhiteSpace Percent WhiteSpace Name WhiteSpace PEDef SMaybe EdeclEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EdeclBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Percent], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_PEDef], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_EdeclEnd]};
        _fillRule(g, aXml10SymbolId[XML10_PEDecl] , 9, &(RhsId[0]));
    }
    { /* EntityDef ::= EntityValue */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EntityValue]};
        _fillRule(g, aXml10SymbolId[XML10_EntityDef] , 1, &(RhsId[0]));
    }
    { /* EntityDef ::= ExternalID */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ExternalID]};
        _fillRule(g, aXml10SymbolId[XML10_EntityDef] , 1, &(RhsId[0]));
    }
    { /* PubidLiteral ::= PUBIDLITERAL */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PUBIDLITERAL]};
        _fillRule(g, aXml10SymbolId[XML10_PubidLiteral] , 1, &(RhsId[0]));
    }
    { /* EntityDef ::= ExternalID NDataDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ExternalID], aXml10SymbolId[XML10_NDataDecl]};
        _fillRule(g, aXml10SymbolId[XML10_EntityDef] , 2, &(RhsId[0]));
    }
    { /* PEDef ::= EntityValue */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EntityValue]};
        _fillRule(g, aXml10SymbolId[XML10_PEDef] , 1, &(RhsId[0]));
    }
    { /* PEDef ::= ExternalID */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ExternalID]};
        _fillRule(g, aXml10SymbolId[XML10_PEDef] , 1, &(RhsId[0]));
    }
    { /* ExternalID ::= System WhiteSpace SystemLiteral */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_System], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_SystemLiteral]};
        _fillRule(g, aXml10SymbolId[XML10_ExternalID] , 3, &(RhsId[0]));
    }
    { /* ExternalID ::= Public WhiteSpace PubidLiteral WhiteSpace SystemLiteral */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Public], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_PubidLiteral], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_SystemLiteral]};
        _fillRule(g, aXml10SymbolId[XML10_ExternalID] , 5, &(RhsId[0]));
    }
    { /* NDataDecl ::= WhiteSpace Ndata WhiteSpace Name */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Ndata], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name]};
        _fillRule(g, aXml10SymbolId[XML10_NDataDecl] , 4, &(RhsId[0]));
    }
    { /* TextDecl ::= XmlBeg VersionInfoMaybe EncodingDecl SMaybe XmlEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XmlBeg], aXml10SymbolId[XML10_VersionInfoMaybe], aXml10SymbolId[XML10_EncodingDecl], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_XmlEnd]};
        _fillRule(g, aXml10SymbolId[XML10_TextDecl] , 5, &(RhsId[0]));
    }
    { /* extParsedEnt ::= content */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_content]};
        _fillRule(g, aXml10SymbolId[XML10_extParsedEnt] , 1, &(RhsId[0]));
    }
    { /* extParsedEnt ::= TextDecl content */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TextDecl], aXml10SymbolId[XML10_content]};
        _fillRule(g, aXml10SymbolId[XML10_extParsedEnt] , 2, &(RhsId[0]));
    }
    { /* EncodingDecl ::= WhiteSpace Encoding Eq Dquote EncName Dquote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Encoding], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Dquote], aXml10SymbolId[XML10_EncName], aXml10SymbolId[XML10_Dquote]};
        _fillRule(g, aXml10SymbolId[XML10_EncodingDecl] , 6, &(RhsId[0]));
    }
    { /* CharData ::= CHARDATA */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CHARDATA]};
        _fillRule(g, aXml10SymbolId[XML10_CharData] , 1, &(RhsId[0]));
    }
    { /* EncodingDecl ::= WhiteSpace Encoding Eq Squote EncName Squote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Encoding], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Squote], aXml10SymbolId[XML10_EncName], aXml10SymbolId[XML10_Squote]};
        _fillRule(g, aXml10SymbolId[XML10_EncodingDecl] , 6, &(RhsId[0]));
    }
    { /* EncName ::= ENCNAME */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ENCNAME]};
        _fillRule(g, aXml10SymbolId[XML10_EncName] , 1, &(RhsId[0]));
    }
    { /* NotationDecl ::= NotationBeg WhiteSpace Name WhiteSpace ExternalID SMaybe NotationEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NotationBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_ExternalID], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_NotationEnd]};
        _fillRule(g, aXml10SymbolId[XML10_NotationDecl] , 7, &(RhsId[0]));
    }
    { /* NotationDecl ::= NotationBeg WhiteSpace Name WhiteSpace PublicID SMaybe NotationEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NotationBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_PublicID], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_NotationEnd]};
        _fillRule(g, aXml10SymbolId[XML10_NotationDecl] , 7, &(RhsId[0]));
    }
    { /* PublicID ::= Public WhiteSpace PubidLiteral */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Public], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_PubidLiteral]};
        _fillRule(g, aXml10SymbolId[XML10_PublicID] , 3, &(RhsId[0]));
    }
    { /* x20 ::= X20 */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_X20]};
        _fillRule(g, aXml10SymbolId[XML10_x20] , 1, &(RhsId[0]));
    }
    { /* XMLDeclMaybe ::= XMLDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XMLDecl]};
        _fillRule(g, aXml10SymbolId[XML10_XMLDeclMaybe] , 1, &(RhsId[0]));
    }
    { /* XMLDeclMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_XMLDeclMaybe] , 0, NULL);
    }
    { /* MiscAny ::= Misc * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Misc]};
        _fillRule(g, aXml10SymbolId[XML10_MiscAny] , 1, &(RhsId[0]));
    }
    { /* EncodingDeclMaybe ::= EncodingDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EncodingDecl]};
        _fillRule(g, aXml10SymbolId[XML10_EncodingDeclMaybe] , 1, &(RhsId[0]));
    }
    { /* Comment ::= CommentBeg CommentInterior CommentEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CommentBeg], aXml10SymbolId[XML10_CommentInterior], aXml10SymbolId[XML10_CommentEnd]};
        _fillRule(g, aXml10SymbolId[XML10_Comment] , 3, &(RhsId[0]));
    }
    { /* EncodingDeclMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_EncodingDeclMaybe] , 0, NULL);
    }
    { /* SDDeclMaybe ::= SDDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SDDecl]};
        _fillRule(g, aXml10SymbolId[XML10_SDDeclMaybe] , 1, &(RhsId[0]));
    }
    { /* SDDeclMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_SDDeclMaybe] , 0, NULL);
    }
    { /* SMaybe ::= WhiteSpace */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace]};
        _fillRule(g, aXml10SymbolId[XML10_SMaybe] , 1, &(RhsId[0]));
    }
    { /* SMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_SMaybe] , 0, NULL);
    }
    { /* ContentInterior ::= element CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_element], aXml10SymbolId[XML10_CharDataMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_ContentInterior] , 2, &(RhsId[0]));
    }
    { /* ContentInterior ::= Reference CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Reference], aXml10SymbolId[XML10_CharDataMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_ContentInterior] , 2, &(RhsId[0]));
    }
    { /* ContentInterior ::= CDSect CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CDSect], aXml10SymbolId[XML10_CharDataMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_ContentInterior] , 2, &(RhsId[0]));
    }
    { /* ContentInterior ::= PI CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PI], aXml10SymbolId[XML10_CharDataMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_ContentInterior] , 2, &(RhsId[0]));
    }
    { /* ContentInterior ::= Comment CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Comment], aXml10SymbolId[XML10_CharDataMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_ContentInterior] , 2, &(RhsId[0]));
    }
    { /* PITarget ::= PITARGET */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PITARGET]};
        _fillRule(g, aXml10SymbolId[XML10_PITarget] , 1, &(RhsId[0]));
    }
    { /* ContentInteriorAny ::= ContentInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ContentInterior]};
        _fillRule(g, aXml10SymbolId[XML10_ContentInteriorAny] , 1, &(RhsId[0]));
    }
    { /* intSubsetUnit ::= markupdecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_markupdecl]};
        _fillRule(g, aXml10SymbolId[XML10_intSubsetUnit] , 1, &(RhsId[0]));
    }
    { /* intSubsetUnit ::= DeclSep */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DeclSep]};
        _fillRule(g, aXml10SymbolId[XML10_intSubsetUnit] , 1, &(RhsId[0]));
    }
    { /* intSubsetUnitAny ::= intSubsetUnit * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_intSubsetUnit]};
        _fillRule(g, aXml10SymbolId[XML10_intSubsetUnitAny] , 1, &(RhsId[0]));
    }
    { /* extSubsetDeclUnit ::= markupdecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_markupdecl]};
        _fillRule(g, aXml10SymbolId[XML10_extSubsetDeclUnit] , 1, &(RhsId[0]));
    }
    { /* extSubsetDeclUnit ::= conditionalSect */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_conditionalSect]};
        _fillRule(g, aXml10SymbolId[XML10_extSubsetDeclUnit] , 1, &(RhsId[0]));
    }
    { /* extSubsetDeclUnit ::= DeclSep */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DeclSep]};
        _fillRule(g, aXml10SymbolId[XML10_extSubsetDeclUnit] , 1, &(RhsId[0]));
    }
    { /* extSubsetDeclUnitAny ::= extSubsetDeclUnit * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_extSubsetDeclUnit]};
        _fillRule(g, aXml10SymbolId[XML10_extSubsetDeclUnitAny] , 1, &(RhsId[0]));
    }
    { /* STagInterior ::= WhiteSpace Attribute */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Attribute]};
        _fillRule(g, aXml10SymbolId[XML10_STagInterior] , 2, &(RhsId[0]));
    }
    { /* STagInteriorAny ::= STagInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STagInterior]};
        _fillRule(g, aXml10SymbolId[XML10_STagInteriorAny] , 1, &(RhsId[0]));
    }
    { /* PI ::= PiBeg PITarget PiEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PiBeg], aXml10SymbolId[XML10_PITarget], aXml10SymbolId[XML10_PiEnd]};
        _fillRule(g, aXml10SymbolId[XML10_PI] , 3, &(RhsId[0]));
    }
    { /* CharDataMaybe ::= CharData */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CharData]};
        _fillRule(g, aXml10SymbolId[XML10_CharDataMaybe] , 1, &(RhsId[0]));
    }
    { /* CharDataMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_CharDataMaybe] , 0, NULL);
    }
    { /* EmptyElemTagInterior ::= WhiteSpace Attribute */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Attribute]};
        _fillRule(g, aXml10SymbolId[XML10_EmptyElemTagInterior] , 2, &(RhsId[0]));
    }
    { /* EmptyElemTagInteriorAny ::= EmptyElemTagInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EmptyElemTagInterior]};
        _fillRule(g, aXml10SymbolId[XML10_EmptyElemTagInteriorAny] , 1, &(RhsId[0]));
    }
    { /* Quantifier ::= QuestionMark */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_QuestionMark]};
        _fillRule(g, aXml10SymbolId[XML10_Quantifier] , 1, &(RhsId[0]));
    }
    { /* Quantifier ::= Star */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Star]};
        _fillRule(g, aXml10SymbolId[XML10_Quantifier] , 1, &(RhsId[0]));
    }
    { /* Quantifier ::= Plus */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Plus]};
        _fillRule(g, aXml10SymbolId[XML10_Quantifier] , 1, &(RhsId[0]));
    }
    { /* QuantifierMaybe ::= Quantifier */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Quantifier]};
        _fillRule(g, aXml10SymbolId[XML10_QuantifierMaybe] , 1, &(RhsId[0]));
    }
    { /* QuantifierMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_QuantifierMaybe] , 0, NULL);
    }
    { /* ChoiceInterior ::= SMaybe Pipe SMaybe cp */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Pipe], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_cp]};
        _fillRule(g, aXml10SymbolId[XML10_ChoiceInterior] , 4, &(RhsId[0]));
    }
    { /* PI ::= PiBeg PITarget WhiteSpace PiInterior PiEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PiBeg], aXml10SymbolId[XML10_PITarget], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_PiInterior], aXml10SymbolId[XML10_PiEnd]};
        _fillRule(g, aXml10SymbolId[XML10_PI] , 5, &(RhsId[0]));
    }
    { /* ChoiceInteriorMany ::= ChoiceInterior + */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ChoiceInterior]};
        _fillRule(g, aXml10SymbolId[XML10_ChoiceInteriorMany] , 1, &(RhsId[0]));
    }
    { /* SeqInterior ::= SMaybe Comma SMaybe cp */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Comma], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_cp]};
        _fillRule(g, aXml10SymbolId[XML10_SeqInterior] , 4, &(RhsId[0]));
    }
    { /* SeqInteriorAny ::= SeqInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SeqInterior]};
        _fillRule(g, aXml10SymbolId[XML10_SeqInteriorAny] , 1, &(RhsId[0]));
    }
    { /* MixedInterior ::= SMaybe Pipe SMaybe Name */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Pipe], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Name]};
        _fillRule(g, aXml10SymbolId[XML10_MixedInterior] , 4, &(RhsId[0]));
    }
    { /* MixedInteriorAny ::= MixedInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_MixedInterior]};
        _fillRule(g, aXml10SymbolId[XML10_MixedInteriorAny] , 1, &(RhsId[0]));
    }
    { /* AttDefAny ::= AttDef * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_AttDef]};
        _fillRule(g, aXml10SymbolId[XML10_AttDefAny] , 1, &(RhsId[0]));
    }
    { /* NotationTypeInterior ::= SMaybe Pipe SMaybe Name */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Pipe], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Name]};
        _fillRule(g, aXml10SymbolId[XML10_NotationTypeInterior] , 4, &(RhsId[0]));
    }
    { /* NotationTypeInteriorAny ::= NotationTypeInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NotationTypeInterior]};
        _fillRule(g, aXml10SymbolId[XML10_NotationTypeInteriorAny] , 1, &(RhsId[0]));
    }
    { /* EnumerationInterior ::= SMaybe Pipe SMaybe Nmtoken */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Pipe], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Nmtoken]};
        _fillRule(g, aXml10SymbolId[XML10_EnumerationInterior] , 4, &(RhsId[0]));
    }
    { /* EnumerationInteriorAny ::= EnumerationInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EnumerationInterior]};
        _fillRule(g, aXml10SymbolId[XML10_EnumerationInteriorAny] , 1, &(RhsId[0]));
    }
    { /* CDSect ::= CDStart CData CDEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CDStart], aXml10SymbolId[XML10_CData], aXml10SymbolId[XML10_CDEnd]};
        _fillRule(g, aXml10SymbolId[XML10_CDSect] , 3, &(RhsId[0]));
    }
    { /* ignoreSectContentsAny ::= ignoreSectContents * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ignoreSectContents]};
        _fillRule(g, aXml10SymbolId[XML10_ignoreSectContentsAny] , 1, &(RhsId[0]));
    }
    { /* ignoreSectContentsInterior ::= SectBeg ignoreSectContents SectEnd Ignore */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SectBeg], aXml10SymbolId[XML10_ignoreSectContents], aXml10SymbolId[XML10_SectEnd], aXml10SymbolId[XML10_Ignore]};
        _fillRule(g, aXml10SymbolId[XML10_ignoreSectContentsInterior] , 4, &(RhsId[0]));
    }
    { /* ignoreSectContentsInteriorAny ::= ignoreSectContentsInterior * */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ignoreSectContentsInterior]};
        _fillRule(g, aXml10SymbolId[XML10_ignoreSectContentsInteriorAny] , 1, &(RhsId[0]));
    }
    { /* VersionInfoMaybe ::= VersionInfo */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_VersionInfo]};
        _fillRule(g, aXml10SymbolId[XML10_VersionInfoMaybe] , 1, &(RhsId[0]));
    }
    { /* VersionInfoMaybe ::= */
        _fillRule(g, aXml10SymbolId[XML10_VersionInfoMaybe] , 0, NULL);
    }
    { /* WhiteSpace ::= S */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_S]};
        _fillRule(g, aXml10SymbolId[XML10_WhiteSpace] , 1, &(RhsId[0]));
    }
    { /* CommentBeg ::= COMMENT_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_COMMENT_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_CommentBeg] , 1, &(RhsId[0]));
    }
    { /* CommentEnd ::= COMMENT_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_COMMENT_END]};
        _fillRule(g, aXml10SymbolId[XML10_CommentEnd] , 1, &(RhsId[0]));
    }
    { /* CommentInterior ::= COMMENT */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_COMMENT]};
        _fillRule(g, aXml10SymbolId[XML10_CommentInterior] , 1, &(RhsId[0]));
    }
    { /* PiInterior ::= PI_INTERIOR */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PI_INTERIOR]};
        _fillRule(g, aXml10SymbolId[XML10_PiInterior] , 1, &(RhsId[0]));
    }
    { /* CDStart ::= CDSTART */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CDSTART]};
        _fillRule(g, aXml10SymbolId[XML10_CDStart] , 1, &(RhsId[0]));
    }
    { /* XmlBeg ::= XML_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XML_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_XmlBeg] , 1, &(RhsId[0]));
    }
    { /* XmlEnd ::= XML_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XML_END]};
        _fillRule(g, aXml10SymbolId[XML10_XmlEnd] , 1, &(RhsId[0]));
    }
    { /* Version ::= VERSION */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_VERSION]};
        _fillRule(g, aXml10SymbolId[XML10_Version] , 1, &(RhsId[0]));
    }
    { /* Squote ::= SQUOTE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SQUOTE]};
        _fillRule(g, aXml10SymbolId[XML10_Squote] , 1, &(RhsId[0]));
    }
    { /* Dquote ::= DQUOTE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DQUOTE]};
        _fillRule(g, aXml10SymbolId[XML10_Dquote] , 1, &(RhsId[0]));
    }
    { /* Equal ::= EQUAL */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EQUAL]};
        _fillRule(g, aXml10SymbolId[XML10_Equal] , 1, &(RhsId[0]));
    }
    { /* DoctypeBeg ::= DOCTYPE_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DOCTYPE_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_DoctypeBeg] , 1, &(RhsId[0]));
    }
    { /* DoctypeEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_DoctypeEnd] , 1, &(RhsId[0]));
    }
    { /* Lbracket ::= LBRACKET */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_LBRACKET]};
        _fillRule(g, aXml10SymbolId[XML10_Lbracket] , 1, &(RhsId[0]));
    }
    { /* Rbracket ::= RBRACKET */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_RBRACKET]};
        _fillRule(g, aXml10SymbolId[XML10_Rbracket] , 1, &(RhsId[0]));
    }
    { /* CData ::= CDATA */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CDATA]};
        _fillRule(g, aXml10SymbolId[XML10_CData] , 1, &(RhsId[0]));
    }
    { /* Standalone ::= STANDALONE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STANDALONE]};
        _fillRule(g, aXml10SymbolId[XML10_Standalone] , 1, &(RhsId[0]));
    }
    { /* Yes ::= YES */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_YES]};
        _fillRule(g, aXml10SymbolId[XML10_Yes] , 1, &(RhsId[0]));
    }
    { /* No ::= NO */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NO]};
        _fillRule(g, aXml10SymbolId[XML10_No] , 1, &(RhsId[0]));
    }
    { /* XTagBeg ::= XTAG_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTAG_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_XTagBeg] , 1, &(RhsId[0]));
    }
    { /* STagBeg ::= XTagBeg */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagBeg]};
        _fillRule(g, aXml10SymbolId[XML10_STagBeg] , 1, &(RhsId[0]));
    }
    { /* XTagEnd ::= XTAG_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTAG_END]};
        _fillRule(g, aXml10SymbolId[XML10_XTagEnd] , 1, &(RhsId[0]));
    }
    { /* STagEnd ::= STAG_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STAG_END]};
        _fillRule(g, aXml10SymbolId[XML10_STagEnd] , 1, &(RhsId[0]));
    }
    { /* ETagBeg ::= ETAG_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ETAG_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_ETagBeg] , 1, &(RhsId[0]));
    }
    { /* ETagEnd ::= ETAG_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ETAG_END]};
        _fillRule(g, aXml10SymbolId[XML10_ETagEnd] , 1, &(RhsId[0]));
    }
    { /* EmptyElemTagBeg ::= XTagBeg */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagBeg]};
        _fillRule(g, aXml10SymbolId[XML10_EmptyElemTagBeg] , 1, &(RhsId[0]));
    }
    { /* Name ::= NAME */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NAME]};
        _fillRule(g, aXml10SymbolId[XML10_Name] , 1, &(RhsId[0]));
    }
    { /* CDEnd ::= CDEND */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CDEND]};
        _fillRule(g, aXml10SymbolId[XML10_CDEnd] , 1, &(RhsId[0]));
    }
    { /* EmptyElemTagEnd ::= EMPTYELEMTAG_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EMPTYELEMTAG_END]};
        _fillRule(g, aXml10SymbolId[XML10_EmptyElemTagEnd] , 1, &(RhsId[0]));
    }
    { /* ElementDeclBeg ::= ELEMENTDECL_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ELEMENTDECL_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_ElementDeclBeg] , 1, &(RhsId[0]));
    }
    { /* ElementDeclEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_ElementDeclEnd] , 1, &(RhsId[0]));
    }
    { /* Empty ::= EMPTY */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EMPTY]};
        _fillRule(g, aXml10SymbolId[XML10_Empty] , 1, &(RhsId[0]));
    }
    { /* Any ::= ANY */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ANY]};
        _fillRule(g, aXml10SymbolId[XML10_Any] , 1, &(RhsId[0]));
    }
    { /* QuestionMark ::= QUESTION_MARK */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_QUESTION_MARK]};
        _fillRule(g, aXml10SymbolId[XML10_QuestionMark] , 1, &(RhsId[0]));
    }
    { /* Star ::= STAR */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STAR]};
        _fillRule(g, aXml10SymbolId[XML10_Star] , 1, &(RhsId[0]));
    }
    { /* Plus ::= PLUS */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PLUS]};
        _fillRule(g, aXml10SymbolId[XML10_Plus] , 1, &(RhsId[0]));
    }
    { /* Lparen ::= LPAREN */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_LPAREN]};
        _fillRule(g, aXml10SymbolId[XML10_Lparen] , 1, &(RhsId[0]));
    }
    { /* Rparen ::= RPAREN */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_RPAREN]};
        _fillRule(g, aXml10SymbolId[XML10_Rparen] , 1, &(RhsId[0]));
    }
    { /* prolog ::= XMLDeclMaybe MiscAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XMLDeclMaybe], aXml10SymbolId[XML10_MiscAny]};
        _fillRule(g, aXml10SymbolId[XML10_prolog] , 2, &(RhsId[0]));
    }
    { /* RparenStar ::= RPARENSTAR */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_RPARENSTAR]};
        _fillRule(g, aXml10SymbolId[XML10_RparenStar] , 1, &(RhsId[0]));
    }
    { /* Pipe ::= PIPE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PIPE]};
        _fillRule(g, aXml10SymbolId[XML10_Pipe] , 1, &(RhsId[0]));
    }
    { /* Comma ::= COMMA */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_COMMA]};
        _fillRule(g, aXml10SymbolId[XML10_Comma] , 1, &(RhsId[0]));
    }
    { /* AttlistBeg ::= ATTLIST_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ATTLIST_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_AttlistBeg] , 1, &(RhsId[0]));
    }
    { /* AttlistEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_AttlistEnd] , 1, &(RhsId[0]));
    }
    { /* TypeId ::= TYPE_ID */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_ID]};
        _fillRule(g, aXml10SymbolId[XML10_TypeId] , 1, &(RhsId[0]));
    }
    { /* TypeIdref ::= TYPE_IDREF */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_IDREF]};
        _fillRule(g, aXml10SymbolId[XML10_TypeIdref] , 1, &(RhsId[0]));
    }
    { /* TypeIdrefs ::= TYPE_IDREFS */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_IDREFS]};
        _fillRule(g, aXml10SymbolId[XML10_TypeIdrefs] , 1, &(RhsId[0]));
    }
    { /* TypeEntity ::= TYPE_ENTITY */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_ENTITY]};
        _fillRule(g, aXml10SymbolId[XML10_TypeEntity] , 1, &(RhsId[0]));
    }
    { /* TypeEntities ::= TYPE_ENTITIES */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_ENTITIES]};
        _fillRule(g, aXml10SymbolId[XML10_TypeEntities] , 1, &(RhsId[0]));
    }
    { /* prolog ::= XMLDeclMaybe MiscAny doctypedecl MiscAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XMLDeclMaybe], aXml10SymbolId[XML10_MiscAny], aXml10SymbolId[XML10_doctypedecl], aXml10SymbolId[XML10_MiscAny]};
        _fillRule(g, aXml10SymbolId[XML10_prolog] , 4, &(RhsId[0]));
    }
    { /* TypeNmtoken ::= TYPE_NMTOKEN */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_NMTOKEN]};
        _fillRule(g, aXml10SymbolId[XML10_TypeNmtoken] , 1, &(RhsId[0]));
    }
    { /* TypeNmtokens ::= TYPE_NMTOKENS */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TYPE_NMTOKENS]};
        _fillRule(g, aXml10SymbolId[XML10_TypeNmtokens] , 1, &(RhsId[0]));
    }
    { /* Notation ::= NOTATION */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NOTATION]};
        _fillRule(g, aXml10SymbolId[XML10_Notation] , 1, &(RhsId[0]));
    }
    { /* NotationBeg ::= NOTATION_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NOTATION_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_NotationBeg] , 1, &(RhsId[0]));
    }
    { /* NotationEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_NotationEnd] , 1, &(RhsId[0]));
    }
    { /* Required ::= REQUIRED */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_REQUIRED]};
        _fillRule(g, aXml10SymbolId[XML10_Required] , 1, &(RhsId[0]));
    }
    { /* Implied ::= IMPLIED */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_IMPLIED]};
        _fillRule(g, aXml10SymbolId[XML10_Implied] , 1, &(RhsId[0]));
    }
    { /* Fixed ::= FIXED */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_FIXED]};
        _fillRule(g, aXml10SymbolId[XML10_Fixed] , 1, &(RhsId[0]));
    }
    { /* SectBeg ::= SECT_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SECT_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_SectBeg] , 1, &(RhsId[0]));
    }
    { /* SectEnd ::= SECT_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SECT_END]};
        _fillRule(g, aXml10SymbolId[XML10_SectEnd] , 1, &(RhsId[0]));
    }
    { /* XMLDecl ::= XmlBeg VersionInfo EncodingDeclMaybe SDDeclMaybe SMaybe XmlEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XmlBeg], aXml10SymbolId[XML10_VersionInfo], aXml10SymbolId[XML10_EncodingDeclMaybe], aXml10SymbolId[XML10_SDDeclMaybe], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_XmlEnd]};
        _fillRule(g, aXml10SymbolId[XML10_XMLDecl] , 6, &(RhsId[0]));
    }
    { /* Include ::= INCLUDE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_INCLUDE]};
        _fillRule(g, aXml10SymbolId[XML10_Include] , 1, &(RhsId[0]));
    }
    { /* EdeclBeg ::= EDECL_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EDECL_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_EdeclBeg] , 1, &(RhsId[0]));
    }
    { /* EdeclEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_XTagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_EdeclEnd] , 1, &(RhsId[0]));
    }
    { /* Percent ::= PERCENT */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PERCENT]};
        _fillRule(g, aXml10SymbolId[XML10_Percent] , 1, &(RhsId[0]));
    }
    { /* System ::= SYSTEM */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SYSTEM]};
        _fillRule(g, aXml10SymbolId[XML10_System] , 1, &(RhsId[0]));
    }
    { /* Public ::= PUBLIC */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PUBLIC]};
        _fillRule(g, aXml10SymbolId[XML10_Public] , 1, &(RhsId[0]));
    }
    { /* Ndata ::= NDATA */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NDATA]};
        _fillRule(g, aXml10SymbolId[XML10_Ndata] , 1, &(RhsId[0]));
    }
    { /* Encoding ::= ENCODING */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ENCODING]};
        _fillRule(g, aXml10SymbolId[XML10_Encoding] , 1, &(RhsId[0]));
    }
    { /* TOKIgnore ::= IGNORE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_IGNORE]};
        _fillRule(g, aXml10SymbolId[XML10_TOKIgnore] , 1, &(RhsId[0]));
    }
    { /* Pcdata ::= PCDATA */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PCDATA]};
        _fillRule(g, aXml10SymbolId[XML10_Pcdata] , 1, &(RhsId[0]));
    }
    { /* VersionInfo ::= WhiteSpace Version Eq Squote VersionNum Squote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Version], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Squote], aXml10SymbolId[XML10_VersionNum], aXml10SymbolId[XML10_Squote]};
        _fillRule(g, aXml10SymbolId[XML10_VersionInfo] , 6, &(RhsId[0]));
    }
    { /* PiBeg ::= PI_BEG */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PI_BEG]};
        _fillRule(g, aXml10SymbolId[XML10_PiBeg] , 1, &(RhsId[0]));
    }
    { /* PiEnd ::= PI_END */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PI_END]};
        _fillRule(g, aXml10SymbolId[XML10_PiEnd] , 1, &(RhsId[0]));
    }
    { /* :start ::= document */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_document]};
        _fillRule(g, aXml10SymbolId[XML10___start_] , 1, &(RhsId[0]));
    }
    { /* VersionInfo ::= WhiteSpace Version Eq Dquote VersionNum Dquote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Version], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Dquote], aXml10SymbolId[XML10_VersionNum], aXml10SymbolId[XML10_Dquote]};
        _fillRule(g, aXml10SymbolId[XML10_VersionInfo] , 6, &(RhsId[0]));
    }
    { /* Eq ::= SMaybe Equal SMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Equal], aXml10SymbolId[XML10_SMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_Eq] , 3, &(RhsId[0]));
    }
    { /* VersionNum ::= VERSIONNUM */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_VERSIONNUM]};
        _fillRule(g, aXml10SymbolId[XML10_VersionNum] , 1, &(RhsId[0]));
    }
    { /* Misc ::= Comment */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Comment]};
        _fillRule(g, aXml10SymbolId[XML10_Misc] , 1, &(RhsId[0]));
    }
    { /* Misc ::= PI */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PI]};
        _fillRule(g, aXml10SymbolId[XML10_Misc] , 1, &(RhsId[0]));
    }
    { /* Names ::= Name */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Name]};
        _fillRule(g, aXml10SymbolId[XML10_Names] , 1, &(RhsId[0]));
    }
    { /* Misc ::= WhiteSpace */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace]};
        _fillRule(g, aXml10SymbolId[XML10_Misc] , 1, &(RhsId[0]));
    }
    { /* doctypedecl ::= DoctypeBeg WhiteSpace Name SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DoctypeBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_DoctypeEnd]};
        _fillRule(g, aXml10SymbolId[XML10_doctypedecl] , 5, &(RhsId[0]));
    }
    { /* doctypedecl ::= DoctypeBeg WhiteSpace Name SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DoctypeBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Lbracket], aXml10SymbolId[XML10_intSubset], aXml10SymbolId[XML10_Rbracket], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_DoctypeEnd]};
        _fillRule(g, aXml10SymbolId[XML10_doctypedecl] , 9, &(RhsId[0]));
    }
    { /* doctypedecl ::= DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DoctypeBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_ExternalID], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_DoctypeEnd]};
        _fillRule(g, aXml10SymbolId[XML10_doctypedecl] , 7, &(RhsId[0]));
    }
    { /* doctypedecl ::= DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_DoctypeBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_ExternalID], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Lbracket], aXml10SymbolId[XML10_intSubset], aXml10SymbolId[XML10_Rbracket], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_DoctypeEnd]};
        _fillRule(g, aXml10SymbolId[XML10_doctypedecl] , 11, &(RhsId[0]));
    }
    { /* DeclSep ::= PEReference */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PEReference]};
        _fillRule(g, aXml10SymbolId[XML10_DeclSep] , 1, &(RhsId[0]));
    }
    { /* DeclSep ::= WhiteSpace */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace]};
        _fillRule(g, aXml10SymbolId[XML10_DeclSep] , 1, &(RhsId[0]));
    }
    { /* intSubset ::= intSubsetUnitAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_intSubsetUnitAny]};
        _fillRule(g, aXml10SymbolId[XML10_intSubset] , 1, &(RhsId[0]));
    }
    { /* markupdecl ::= elementdecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_elementdecl]};
        _fillRule(g, aXml10SymbolId[XML10_markupdecl] , 1, &(RhsId[0]));
    }
    { /* markupdecl ::= AttlistDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_AttlistDecl]};
        _fillRule(g, aXml10SymbolId[XML10_markupdecl] , 1, &(RhsId[0]));
    }
    { /* Names ::= x20 Names */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_x20], aXml10SymbolId[XML10_Names]};
        _fillRule(g, aXml10SymbolId[XML10_Names] , 2, &(RhsId[0]));
    }
    { /* markupdecl ::= EntityDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EntityDecl]};
        _fillRule(g, aXml10SymbolId[XML10_markupdecl] , 1, &(RhsId[0]));
    }
    { /* markupdecl ::= NotationDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NotationDecl]};
        _fillRule(g, aXml10SymbolId[XML10_markupdecl] , 1, &(RhsId[0]));
    }
    { /* markupdecl ::= PI */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_PI]};
        _fillRule(g, aXml10SymbolId[XML10_markupdecl] , 1, &(RhsId[0]));
    }
    { /* markupdecl ::= Comment */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Comment]};
        _fillRule(g, aXml10SymbolId[XML10_markupdecl] , 1, &(RhsId[0]));
    }
    { /* extSubset ::= extSubsetDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_extSubsetDecl]};
        _fillRule(g, aXml10SymbolId[XML10_extSubset] , 1, &(RhsId[0]));
    }
    { /* extSubset ::= TextDecl extSubsetDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TextDecl], aXml10SymbolId[XML10_extSubsetDecl]};
        _fillRule(g, aXml10SymbolId[XML10_extSubset] , 2, &(RhsId[0]));
    }
    { /* extSubsetDecl ::= extSubsetDeclUnitAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_extSubsetDeclUnitAny]};
        _fillRule(g, aXml10SymbolId[XML10_extSubsetDecl] , 1, &(RhsId[0]));
    }
    { /* SDDecl ::= WhiteSpace Standalone Eq Squote Yes Squote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Standalone], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Squote], aXml10SymbolId[XML10_Yes], aXml10SymbolId[XML10_Squote]};
        _fillRule(g, aXml10SymbolId[XML10_SDDecl] , 6, &(RhsId[0]));
    }
    { /* SDDecl ::= WhiteSpace Standalone Eq Squote No Squote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Standalone], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Squote], aXml10SymbolId[XML10_No], aXml10SymbolId[XML10_Squote]};
        _fillRule(g, aXml10SymbolId[XML10_SDDecl] , 6, &(RhsId[0]));
    }
    { /* SDDecl ::= WhiteSpace Standalone Eq Dquote Yes Dquote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Standalone], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Dquote], aXml10SymbolId[XML10_Yes], aXml10SymbolId[XML10_Dquote]};
        _fillRule(g, aXml10SymbolId[XML10_SDDecl] , 6, &(RhsId[0]));
    }
    { /* Nmtoken ::= NMTOKEN */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NMTOKEN]};
        _fillRule(g, aXml10SymbolId[XML10_Nmtoken] , 1, &(RhsId[0]));
    }
    { /* SDDecl ::= WhiteSpace Standalone Eq Dquote No Dquote */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Standalone], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_Dquote], aXml10SymbolId[XML10_No], aXml10SymbolId[XML10_Dquote]};
        _fillRule(g, aXml10SymbolId[XML10_SDDecl] , 6, &(RhsId[0]));
    }
    { /* element ::= EmptyElemTag */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EmptyElemTag]};
        _fillRule(g, aXml10SymbolId[XML10_element] , 1, &(RhsId[0]));
    }
    { /* element ::= STag content ETag */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STag], aXml10SymbolId[XML10_content], aXml10SymbolId[XML10_ETag]};
        _fillRule(g, aXml10SymbolId[XML10_element] , 3, &(RhsId[0]));
    }
    { /* STag ::= STagBeg Name STagInteriorAny SMaybe STagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STagBeg], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_STagInteriorAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_STagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_STag] , 5, &(RhsId[0]));
    }
    { /* Attribute ::= Name Eq AttValue */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_Eq], aXml10SymbolId[XML10_AttValue]};
        _fillRule(g, aXml10SymbolId[XML10_Attribute] , 3, &(RhsId[0]));
    }
    { /* ETag ::= ETagBeg Name SMaybe ETagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ETagBeg], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_ETagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_ETag] , 4, &(RhsId[0]));
    }
    { /* content ::= CharDataMaybe ContentInteriorAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CharDataMaybe], aXml10SymbolId[XML10_ContentInteriorAny]};
        _fillRule(g, aXml10SymbolId[XML10_content] , 2, &(RhsId[0]));
    }
    { /* EmptyElemTag ::= EmptyElemTagBeg Name EmptyElemTagInteriorAny SMaybe EmptyElemTagEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EmptyElemTagBeg], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_EmptyElemTagInteriorAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_EmptyElemTagEnd]};
        _fillRule(g, aXml10SymbolId[XML10_EmptyElemTag] , 5, &(RhsId[0]));
    }
    { /* elementdecl ::= ElementDeclBeg WhiteSpace Name WhiteSpace contentspec SMaybe ElementDeclEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ElementDeclBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_contentspec], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_ElementDeclEnd]};
        _fillRule(g, aXml10SymbolId[XML10_elementdecl] , 7, &(RhsId[0]));
    }
    { /* contentspec ::= Empty */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Empty]};
        _fillRule(g, aXml10SymbolId[XML10_contentspec] , 1, &(RhsId[0]));
    }
    { /* Nmtokens ::= Nmtoken */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Nmtoken]};
        _fillRule(g, aXml10SymbolId[XML10_Nmtokens] , 1, &(RhsId[0]));
    }
    { /* contentspec ::= Any */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Any]};
        _fillRule(g, aXml10SymbolId[XML10_contentspec] , 1, &(RhsId[0]));
    }
    { /* contentspec ::= Mixed */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Mixed]};
        _fillRule(g, aXml10SymbolId[XML10_contentspec] , 1, &(RhsId[0]));
    }
    { /* contentspec ::= children */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_children]};
        _fillRule(g, aXml10SymbolId[XML10_contentspec] , 1, &(RhsId[0]));
    }
    { /* children ::= choice QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_choice], aXml10SymbolId[XML10_QuantifierMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_children] , 2, &(RhsId[0]));
    }
    { /* children ::= seq QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_seq], aXml10SymbolId[XML10_QuantifierMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_children] , 2, &(RhsId[0]));
    }
    { /* cp ::= Name QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_QuantifierMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_cp] , 2, &(RhsId[0]));
    }
    { /* cp ::= choice QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_choice], aXml10SymbolId[XML10_QuantifierMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_cp] , 2, &(RhsId[0]));
    }
    { /* cp ::= seq QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_seq], aXml10SymbolId[XML10_QuantifierMaybe]};
        _fillRule(g, aXml10SymbolId[XML10_cp] , 2, &(RhsId[0]));
    }
    { /* choice ::= Lparen SMaybe cp ChoiceInteriorMany SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Lparen], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_cp], aXml10SymbolId[XML10_ChoiceInteriorMany], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Rparen]};
        _fillRule(g, aXml10SymbolId[XML10_choice] , 6, &(RhsId[0]));
    }
    { /* seq ::= Lparen SMaybe cp SeqInteriorAny SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Lparen], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_cp], aXml10SymbolId[XML10_SeqInteriorAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Rparen]};
        _fillRule(g, aXml10SymbolId[XML10_seq] , 6, &(RhsId[0]));
    }
    { /* Nmtokens ::= x20 Nmtokens */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_x20], aXml10SymbolId[XML10_Nmtokens]};
        _fillRule(g, aXml10SymbolId[XML10_Nmtokens] , 2, &(RhsId[0]));
    }
    { /* Mixed ::= Lparen SMaybe Pcdata MixedInteriorAny SMaybe RparenStar */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Lparen], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Pcdata], aXml10SymbolId[XML10_MixedInteriorAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_RparenStar]};
        _fillRule(g, aXml10SymbolId[XML10_Mixed] , 6, &(RhsId[0]));
    }
    { /* Mixed ::= Lparen SMaybe Pcdata SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Lparen], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Pcdata], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Rparen]};
        _fillRule(g, aXml10SymbolId[XML10_Mixed] , 5, &(RhsId[0]));
    }
    { /* AttlistDecl ::= AttlistBeg WhiteSpace Name AttDefAny SMaybe AttlistEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_AttlistBeg], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_AttDefAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_AttlistEnd]};
        _fillRule(g, aXml10SymbolId[XML10_AttlistDecl] , 6, &(RhsId[0]));
    }
    { /* AttDef ::= WhiteSpace Name WhiteSpace AttType WhiteSpace DefaultDecl */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_AttType], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_DefaultDecl]};
        _fillRule(g, aXml10SymbolId[XML10_AttDef] , 6, &(RhsId[0]));
    }
    { /* AttType ::= StringType */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_StringType]};
        _fillRule(g, aXml10SymbolId[XML10_AttType] , 1, &(RhsId[0]));
    }
    { /* AttType ::= TokenizedType */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TokenizedType]};
        _fillRule(g, aXml10SymbolId[XML10_AttType] , 1, &(RhsId[0]));
    }
    { /* AttType ::= EnumeratedType */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_EnumeratedType]};
        _fillRule(g, aXml10SymbolId[XML10_AttType] , 1, &(RhsId[0]));
    }
    { /* StringType ::= STRINGTYPE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_STRINGTYPE]};
        _fillRule(g, aXml10SymbolId[XML10_StringType] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeId */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeId]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeIdref */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeIdref]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* EntityValue ::= ENTITYVALUE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ENTITYVALUE]};
        _fillRule(g, aXml10SymbolId[XML10_EntityValue] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeIdrefs */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeIdrefs]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeEntity */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeEntity]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeEntities */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeEntities]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeNmtoken */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeNmtoken]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* TokenizedType ::= TypeNmtokens */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_TypeNmtokens]};
        _fillRule(g, aXml10SymbolId[XML10_TokenizedType] , 1, &(RhsId[0]));
    }
    { /* EnumeratedType ::= NotationType */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_NotationType]};
        _fillRule(g, aXml10SymbolId[XML10_EnumeratedType] , 1, &(RhsId[0]));
    }
    { /* EnumeratedType ::= Enumeration */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Enumeration]};
        _fillRule(g, aXml10SymbolId[XML10_EnumeratedType] , 1, &(RhsId[0]));
    }
    { /* NotationType ::= Notation WhiteSpace Lparen SMaybe Name NotationTypeInteriorAny SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Notation], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_Lparen], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Name], aXml10SymbolId[XML10_NotationTypeInteriorAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Rparen]};
        _fillRule(g, aXml10SymbolId[XML10_NotationType] , 8, &(RhsId[0]));
    }
    { /* Enumeration ::= Lparen SMaybe Nmtoken EnumerationInteriorAny SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Lparen], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Nmtoken], aXml10SymbolId[XML10_EnumerationInteriorAny], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Rparen]};
        _fillRule(g, aXml10SymbolId[XML10_Enumeration] , 6, &(RhsId[0]));
    }
    { /* DefaultDecl ::= Required */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Required]};
        _fillRule(g, aXml10SymbolId[XML10_DefaultDecl] , 1, &(RhsId[0]));
    }
    { /* AttValue ::= ATTVALUE */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ATTVALUE]};
        _fillRule(g, aXml10SymbolId[XML10_AttValue] , 1, &(RhsId[0]));
    }
    { /* DefaultDecl ::= Implied */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Implied]};
        _fillRule(g, aXml10SymbolId[XML10_DefaultDecl] , 1, &(RhsId[0]));
    }
    { /* DefaultDecl ::= AttValue */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_AttValue]};
        _fillRule(g, aXml10SymbolId[XML10_DefaultDecl] , 1, &(RhsId[0]));
    }
    { /* DefaultDecl ::= Fixed WhiteSpace AttValue */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Fixed], aXml10SymbolId[XML10_WhiteSpace], aXml10SymbolId[XML10_AttValue]};
        _fillRule(g, aXml10SymbolId[XML10_DefaultDecl] , 3, &(RhsId[0]));
    }
    { /* conditionalSect ::= includeSect */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_includeSect]};
        _fillRule(g, aXml10SymbolId[XML10_conditionalSect] , 1, &(RhsId[0]));
    }
    { /* conditionalSect ::= ignoreSect */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_ignoreSect]};
        _fillRule(g, aXml10SymbolId[XML10_conditionalSect] , 1, &(RhsId[0]));
    }
    { /* includeSect ::= SectBeg SMaybe Include SMaybe Lbracket extSubsetDecl SectEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SectBeg], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Include], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Lbracket], aXml10SymbolId[XML10_extSubsetDecl], aXml10SymbolId[XML10_SectEnd]};
        _fillRule(g, aXml10SymbolId[XML10_includeSect] , 7, &(RhsId[0]));
    }
    { /* ignoreSect ::= SectBeg SMaybe TOKIgnore SMaybe Lbracket ignoreSectContentsAny SectEnd */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_SectBeg], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_TOKIgnore], aXml10SymbolId[XML10_SMaybe], aXml10SymbolId[XML10_Lbracket], aXml10SymbolId[XML10_ignoreSectContentsAny], aXml10SymbolId[XML10_SectEnd]};
        _fillRule(g, aXml10SymbolId[XML10_ignoreSect] , 7, &(RhsId[0]));
    }
    { /* ignoreSectContents ::= Ignore ignoreSectContentsInteriorAny */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_Ignore], aXml10SymbolId[XML10_ignoreSectContentsInteriorAny]};
        _fillRule(g, aXml10SymbolId[XML10_ignoreSectContents] , 2, &(RhsId[0]));
    }
    { /* Ignore ::= IGNORE_INTERIOR */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_IGNORE_INTERIOR]};
        _fillRule(g, aXml10SymbolId[XML10_Ignore] , 1, &(RhsId[0]));
    }
    { /* CharRef ::= CHARREF */
        Marpa_Symbol_ID rhsIds[] = {aXml10SymbolId[XML10_CHARREF]};
        _fillRule(g, aXml10SymbolId[XML10_CharRef] , 1, &(RhsId[0]));
    }
}


#endif /* XML10_C */
