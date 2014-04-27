/*
 * Sun Apr 27 21:11:01 2014
 *
 * Generated with:
 * perl GenerateLowLevel.pl --bnf bnf/xml10.bnf --prefix xml10 --output xml10.c
 *
 */

#ifndef XML10_C
#define XML10_C

#include "marpaUtil.h"

/* We do not need all these, just the lexemes, but this is convenient to have the whole list */
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

static Marpa_Grammar _xml10CreateGrammar()
{
    Marpa_Grammar g;

    /* Room to map our enums to real Ids */
    int nbSymbols =  257;
    struct sSymbolId aXml10SymbolId[257] = {
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

    /* Create the grammar */
    marpaUtilCreateGrammar(&g);

    /* Create all the symbols */
    marpaUtilSetSymbols(g, nbSymbols, aXml10SymbolId);

    /* Populate the rules */
    {
        /* document ::= prolog element MiscAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_prolog].symbolId,
                                     aXml10SymbolId[XML10_element].symbolId,
                                     aXml10SymbolId[XML10_MiscAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_document].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Char ::= CHAR */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CHAR].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Char].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SystemLiteral ::= SYSTEMLITERAL */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SYSTEMLITERAL].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SystemLiteral].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Reference ::= EntityRef */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EntityRef].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Reference].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Reference ::= CharRef */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CharRef].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Reference].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityRef ::= ENTITYREF */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ENTITYREF].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityRef].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PEReference ::= PEREFERENCE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PEREFERENCE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PEReference].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityDecl ::= GEDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_GEDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityDecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityDecl ::= PEDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PEDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityDecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* GEDecl ::= EdeclBeg WhiteSpace Name WhiteSpace EntityDef SMaybe EdeclEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EdeclBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_EntityDef].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_EdeclEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_GEDecl].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PEDecl ::= EdeclBeg WhiteSpace Percent WhiteSpace Name WhiteSpace PEDef SMaybe EdeclEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EdeclBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Percent].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_PEDef].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_EdeclEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PEDecl].symbolId , 9, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityDef ::= EntityValue */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EntityValue].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityDef].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityDef ::= ExternalID */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ExternalID].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityDef].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PubidLiteral ::= PUBIDLITERAL */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PUBIDLITERAL].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PubidLiteral].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityDef ::= ExternalID NDataDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ExternalID].symbolId,
                                     aXml10SymbolId[XML10_NDataDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityDef].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PEDef ::= EntityValue */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EntityValue].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PEDef].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PEDef ::= ExternalID */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ExternalID].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PEDef].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ExternalID ::= System WhiteSpace SystemLiteral */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_System].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_SystemLiteral].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ExternalID].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ExternalID ::= Public WhiteSpace PubidLiteral WhiteSpace SystemLiteral */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Public].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_PubidLiteral].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_SystemLiteral].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ExternalID].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NDataDecl ::= WhiteSpace Ndata WhiteSpace Name */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Ndata].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NDataDecl].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TextDecl ::= XmlBeg VersionInfoMaybe EncodingDecl SMaybe XmlEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XmlBeg].symbolId,
                                     aXml10SymbolId[XML10_VersionInfoMaybe].symbolId,
                                     aXml10SymbolId[XML10_EncodingDecl].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_XmlEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TextDecl].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extParsedEnt ::= content */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_content].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extParsedEnt].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extParsedEnt ::= TextDecl content */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TextDecl].symbolId,
                                     aXml10SymbolId[XML10_content].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extParsedEnt].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EncodingDecl ::= WhiteSpace Encoding Eq Dquote EncName Dquote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Encoding].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId,
                                     aXml10SymbolId[XML10_EncName].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EncodingDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CharData ::= CHARDATA */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CHARDATA].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CharData].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EncodingDecl ::= WhiteSpace Encoding Eq Squote EncName Squote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Encoding].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId,
                                     aXml10SymbolId[XML10_EncName].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EncodingDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EncName ::= ENCNAME */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ENCNAME].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EncName].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NotationDecl ::= NotationBeg WhiteSpace Name WhiteSpace ExternalID SMaybe NotationEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NotationBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_ExternalID].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_NotationEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationDecl].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NotationDecl ::= NotationBeg WhiteSpace Name WhiteSpace PublicID SMaybe NotationEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NotationBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_PublicID].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_NotationEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationDecl].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PublicID ::= Public WhiteSpace PubidLiteral */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Public].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_PubidLiteral].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PublicID].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* x20 ::= X20 */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_X20].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_x20].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* XMLDeclMaybe ::= XMLDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XMLDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XMLDeclMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* XMLDeclMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XMLDeclMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* MiscAny ::= Misc * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Misc].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_MiscAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* EncodingDeclMaybe ::= EncodingDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EncodingDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EncodingDeclMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Comment ::= CommentBeg CommentInterior CommentEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CommentBeg].symbolId,
                                     aXml10SymbolId[XML10_CommentInterior].symbolId,
                                     aXml10SymbolId[XML10_CommentEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Comment].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* EncodingDeclMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EncodingDeclMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* SDDeclMaybe ::= SDDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SDDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SDDeclMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* SDDeclMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SDDeclMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* SMaybe ::= WhiteSpace */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* SMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* ContentInterior ::= element CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_element].symbolId,
                                     aXml10SymbolId[XML10_CharDataMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ContentInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ContentInterior ::= Reference CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Reference].symbolId,
                                     aXml10SymbolId[XML10_CharDataMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ContentInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ContentInterior ::= CDSect CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CDSect].symbolId,
                                     aXml10SymbolId[XML10_CharDataMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ContentInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ContentInterior ::= PI CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PI].symbolId,
                                     aXml10SymbolId[XML10_CharDataMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ContentInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ContentInterior ::= Comment CharDataMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Comment].symbolId,
                                     aXml10SymbolId[XML10_CharDataMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ContentInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PITarget ::= PITARGET */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PITARGET].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PITarget].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ContentInteriorAny ::= ContentInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ContentInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ContentInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* intSubsetUnit ::= markupdecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_markupdecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_intSubsetUnit].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* intSubsetUnit ::= DeclSep */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DeclSep].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_intSubsetUnit].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* intSubsetUnitAny ::= intSubsetUnit * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_intSubsetUnit].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_intSubsetUnitAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* extSubsetDeclUnit ::= markupdecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_markupdecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubsetDeclUnit].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extSubsetDeclUnit ::= conditionalSect */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_conditionalSect].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubsetDeclUnit].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extSubsetDeclUnit ::= DeclSep */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DeclSep].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubsetDeclUnit].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extSubsetDeclUnitAny ::= extSubsetDeclUnit * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_extSubsetDeclUnit].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubsetDeclUnitAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* STagInterior ::= WhiteSpace Attribute */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Attribute].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_STagInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* STagInteriorAny ::= STagInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STagInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_STagInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* PI ::= PiBeg PITarget PiEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PiBeg].symbolId,
                                     aXml10SymbolId[XML10_PITarget].symbolId,
                                     aXml10SymbolId[XML10_PiEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PI].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CharDataMaybe ::= CharData */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CharData].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CharDataMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* CharDataMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CharDataMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* EmptyElemTagInterior ::= WhiteSpace Attribute */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Attribute].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EmptyElemTagInterior].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EmptyElemTagInteriorAny ::= EmptyElemTagInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EmptyElemTagInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EmptyElemTagInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* Quantifier ::= QuestionMark */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_QuestionMark].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Quantifier].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Quantifier ::= Star */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Star].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Quantifier].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Quantifier ::= Plus */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Plus].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Quantifier].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* QuantifierMaybe ::= Quantifier */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Quantifier].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_QuantifierMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* QuantifierMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_QuantifierMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* ChoiceInterior ::= SMaybe Pipe SMaybe cp */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Pipe].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_cp].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ChoiceInterior].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PI ::= PiBeg PITarget WhiteSpace PiInterior PiEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PiBeg].symbolId,
                                     aXml10SymbolId[XML10_PITarget].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_PiInterior].symbolId,
                                     aXml10SymbolId[XML10_PiEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PI].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ChoiceInteriorMany ::= ChoiceInterior + */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ChoiceInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ChoiceInteriorMany].symbolId , 1, &(rhsIds[0]), 1, -1, 0, 0);
    }
    {
        /* SeqInterior ::= SMaybe Comma SMaybe cp */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Comma].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_cp].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SeqInterior].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SeqInteriorAny ::= SeqInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SeqInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SeqInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* MixedInterior ::= SMaybe Pipe SMaybe Name */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Pipe].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_MixedInterior].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* MixedInteriorAny ::= MixedInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_MixedInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_MixedInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* AttDefAny ::= AttDef * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_AttDef].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttDefAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* NotationTypeInterior ::= SMaybe Pipe SMaybe Name */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Pipe].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationTypeInterior].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NotationTypeInteriorAny ::= NotationTypeInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NotationTypeInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationTypeInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* EnumerationInterior ::= SMaybe Pipe SMaybe Nmtoken */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Pipe].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Nmtoken].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EnumerationInterior].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EnumerationInteriorAny ::= EnumerationInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EnumerationInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EnumerationInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* CDSect ::= CDStart CData CDEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CDStart].symbolId,
                                     aXml10SymbolId[XML10_CData].symbolId,
                                     aXml10SymbolId[XML10_CDEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CDSect].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ignoreSectContentsAny ::= ignoreSectContents * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ignoreSectContents].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ignoreSectContentsAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* ignoreSectContentsInterior ::= SectBeg ignoreSectContents SectEnd Ignore */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SectBeg].symbolId,
                                     aXml10SymbolId[XML10_ignoreSectContents].symbolId,
                                     aXml10SymbolId[XML10_SectEnd].symbolId,
                                     aXml10SymbolId[XML10_Ignore].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ignoreSectContentsInterior].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ignoreSectContentsInteriorAny ::= ignoreSectContentsInterior * */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ignoreSectContentsInterior].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ignoreSectContentsInteriorAny].symbolId , 1, &(rhsIds[0]), 0, -1, 0, 0);
    }
    {
        /* VersionInfoMaybe ::= VersionInfo */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_VersionInfo].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_VersionInfoMaybe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    { /* VersionInfoMaybe ::= */
        marpaUtilSetRule(g, aXml10SymbolId[XML10_VersionInfoMaybe].symbolId , 0, NULL, -1, -1, 0, 0);
    }
    {
        /* WhiteSpace ::= S */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_S].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_WhiteSpace].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CommentBeg ::= COMMENT_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_COMMENT_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CommentBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CommentEnd ::= COMMENT_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_COMMENT_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CommentEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CommentInterior ::= COMMENT */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_COMMENT].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CommentInterior].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PiInterior ::= PI_INTERIOR */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PI_INTERIOR].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PiInterior].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CDStart ::= CDSTART */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CDSTART].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CDStart].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* XmlBeg ::= XML_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XML_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XmlBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* XmlEnd ::= XML_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XML_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XmlEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Version ::= VERSION */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_VERSION].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Version].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Squote ::= SQUOTE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SQUOTE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Squote].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Dquote ::= DQUOTE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DQUOTE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Dquote].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Equal ::= EQUAL */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EQUAL].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Equal].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DoctypeBeg ::= DOCTYPE_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DOCTYPE_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DoctypeBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DoctypeEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DoctypeEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Lbracket ::= LBRACKET */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_LBRACKET].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Lbracket].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Rbracket ::= RBRACKET */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_RBRACKET].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Rbracket].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CData ::= CDATA */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CDATA].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CData].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Standalone ::= STANDALONE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STANDALONE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Standalone].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Yes ::= YES */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_YES].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Yes].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* No ::= NO */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NO].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_No].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* XTagBeg ::= XTAG_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTAG_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XTagBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* STagBeg ::= XTagBeg */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagBeg].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_STagBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* XTagEnd ::= XTAG_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTAG_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XTagEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* STagEnd ::= STAG_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STAG_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_STagEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ETagBeg ::= ETAG_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ETAG_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ETagBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ETagEnd ::= ETAG_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ETAG_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ETagEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EmptyElemTagBeg ::= XTagBeg */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagBeg].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EmptyElemTagBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Name ::= NAME */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NAME].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Name].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CDEnd ::= CDEND */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CDEND].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CDEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EmptyElemTagEnd ::= EMPTYELEMTAG_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EMPTYELEMTAG_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EmptyElemTagEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ElementDeclBeg ::= ELEMENTDECL_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ELEMENTDECL_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ElementDeclBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ElementDeclEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ElementDeclEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Empty ::= EMPTY */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EMPTY].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Empty].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Any ::= ANY */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ANY].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Any].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* QuestionMark ::= QUESTION_MARK */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_QUESTION_MARK].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_QuestionMark].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Star ::= STAR */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STAR].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Star].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Plus ::= PLUS */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PLUS].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Plus].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Lparen ::= LPAREN */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_LPAREN].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Lparen].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Rparen ::= RPAREN */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_RPAREN].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Rparen].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* prolog ::= XMLDeclMaybe MiscAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XMLDeclMaybe].symbolId,
                                     aXml10SymbolId[XML10_MiscAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_prolog].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* RparenStar ::= RPARENSTAR */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_RPARENSTAR].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_RparenStar].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Pipe ::= PIPE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PIPE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Pipe].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Comma ::= COMMA */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_COMMA].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Comma].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttlistBeg ::= ATTLIST_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ATTLIST_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttlistBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttlistEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttlistEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeId ::= TYPE_ID */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_ID].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeId].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeIdref ::= TYPE_IDREF */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_IDREF].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeIdref].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeIdrefs ::= TYPE_IDREFS */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_IDREFS].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeIdrefs].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeEntity ::= TYPE_ENTITY */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_ENTITY].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeEntity].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeEntities ::= TYPE_ENTITIES */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_ENTITIES].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeEntities].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* prolog ::= XMLDeclMaybe MiscAny doctypedecl MiscAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XMLDeclMaybe].symbolId,
                                     aXml10SymbolId[XML10_MiscAny].symbolId,
                                     aXml10SymbolId[XML10_doctypedecl].symbolId,
                                     aXml10SymbolId[XML10_MiscAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_prolog].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeNmtoken ::= TYPE_NMTOKEN */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_NMTOKEN].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeNmtoken].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TypeNmtokens ::= TYPE_NMTOKENS */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TYPE_NMTOKENS].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TypeNmtokens].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Notation ::= NOTATION */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NOTATION].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Notation].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NotationBeg ::= NOTATION_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NOTATION_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NotationEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Required ::= REQUIRED */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_REQUIRED].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Required].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Implied ::= IMPLIED */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_IMPLIED].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Implied].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Fixed ::= FIXED */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_FIXED].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Fixed].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SectBeg ::= SECT_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SECT_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SectBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SectEnd ::= SECT_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SECT_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SectEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* XMLDecl ::= XmlBeg VersionInfo EncodingDeclMaybe SDDeclMaybe SMaybe XmlEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XmlBeg].symbolId,
                                     aXml10SymbolId[XML10_VersionInfo].symbolId,
                                     aXml10SymbolId[XML10_EncodingDeclMaybe].symbolId,
                                     aXml10SymbolId[XML10_SDDeclMaybe].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_XmlEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_XMLDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Include ::= INCLUDE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_INCLUDE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Include].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EdeclBeg ::= EDECL_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EDECL_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EdeclBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EdeclEnd ::= XTagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_XTagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EdeclEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Percent ::= PERCENT */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PERCENT].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Percent].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* System ::= SYSTEM */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SYSTEM].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_System].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Public ::= PUBLIC */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PUBLIC].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Public].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Ndata ::= NDATA */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NDATA].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Ndata].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Encoding ::= ENCODING */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ENCODING].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Encoding].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TOKIgnore ::= IGNORE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_IGNORE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TOKIgnore].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Pcdata ::= PCDATA */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PCDATA].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Pcdata].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* VersionInfo ::= WhiteSpace Version Eq Squote VersionNum Squote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Version].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId,
                                     aXml10SymbolId[XML10_VersionNum].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_VersionInfo].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PiBeg ::= PI_BEG */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PI_BEG].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PiBeg].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* PiEnd ::= PI_END */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PI_END].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_PiEnd].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* :start ::= document */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_document].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10___start_].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* VersionInfo ::= WhiteSpace Version Eq Dquote VersionNum Dquote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Version].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId,
                                     aXml10SymbolId[XML10_VersionNum].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_VersionInfo].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Eq ::= SMaybe Equal SMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Equal].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Eq].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* VersionNum ::= VERSIONNUM */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_VERSIONNUM].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_VersionNum].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Misc ::= Comment */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Comment].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Misc].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Misc ::= PI */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PI].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Misc].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Names ::= Name */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Name].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Names].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Misc ::= WhiteSpace */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Misc].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* doctypedecl ::= DoctypeBeg WhiteSpace Name SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DoctypeBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_DoctypeEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_doctypedecl].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* doctypedecl ::= DoctypeBeg WhiteSpace Name SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DoctypeBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Lbracket].symbolId,
                                     aXml10SymbolId[XML10_intSubset].symbolId,
                                     aXml10SymbolId[XML10_Rbracket].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_DoctypeEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_doctypedecl].symbolId , 9, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* doctypedecl ::= DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DoctypeBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_ExternalID].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_DoctypeEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_doctypedecl].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* doctypedecl ::= DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_DoctypeBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_ExternalID].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Lbracket].symbolId,
                                     aXml10SymbolId[XML10_intSubset].symbolId,
                                     aXml10SymbolId[XML10_Rbracket].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_DoctypeEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_doctypedecl].symbolId , 11, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DeclSep ::= PEReference */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PEReference].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DeclSep].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DeclSep ::= WhiteSpace */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DeclSep].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* intSubset ::= intSubsetUnitAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_intSubsetUnitAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_intSubset].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* markupdecl ::= elementdecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_elementdecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_markupdecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* markupdecl ::= AttlistDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_AttlistDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_markupdecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Names ::= x20 Names */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_x20].symbolId,
                                     aXml10SymbolId[XML10_Names].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Names].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* markupdecl ::= EntityDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EntityDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_markupdecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* markupdecl ::= NotationDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NotationDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_markupdecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* markupdecl ::= PI */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_PI].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_markupdecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* markupdecl ::= Comment */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Comment].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_markupdecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extSubset ::= extSubsetDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_extSubsetDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubset].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extSubset ::= TextDecl extSubsetDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TextDecl].symbolId,
                                     aXml10SymbolId[XML10_extSubsetDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubset].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* extSubsetDecl ::= extSubsetDeclUnitAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_extSubsetDeclUnitAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_extSubsetDecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SDDecl ::= WhiteSpace Standalone Eq Squote Yes Squote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Standalone].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId,
                                     aXml10SymbolId[XML10_Yes].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SDDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SDDecl ::= WhiteSpace Standalone Eq Squote No Squote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Standalone].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId,
                                     aXml10SymbolId[XML10_No].symbolId,
                                     aXml10SymbolId[XML10_Squote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SDDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SDDecl ::= WhiteSpace Standalone Eq Dquote Yes Dquote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Standalone].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId,
                                     aXml10SymbolId[XML10_Yes].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SDDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Nmtoken ::= NMTOKEN */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NMTOKEN].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Nmtoken].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* SDDecl ::= WhiteSpace Standalone Eq Dquote No Dquote */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Standalone].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId,
                                     aXml10SymbolId[XML10_No].symbolId,
                                     aXml10SymbolId[XML10_Dquote].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_SDDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* element ::= EmptyElemTag */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EmptyElemTag].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_element].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* element ::= STag content ETag */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STag].symbolId,
                                     aXml10SymbolId[XML10_content].symbolId,
                                     aXml10SymbolId[XML10_ETag].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_element].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* STag ::= STagBeg Name STagInteriorAny SMaybe STagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STagBeg].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_STagInteriorAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_STagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_STag].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Attribute ::= Name Eq AttValue */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_Eq].symbolId,
                                     aXml10SymbolId[XML10_AttValue].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Attribute].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ETag ::= ETagBeg Name SMaybe ETagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ETagBeg].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_ETagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ETag].symbolId , 4, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* content ::= CharDataMaybe ContentInteriorAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CharDataMaybe].symbolId,
                                     aXml10SymbolId[XML10_ContentInteriorAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_content].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EmptyElemTag ::= EmptyElemTagBeg Name EmptyElemTagInteriorAny SMaybe EmptyElemTagEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EmptyElemTagBeg].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_EmptyElemTagInteriorAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_EmptyElemTagEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EmptyElemTag].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* elementdecl ::= ElementDeclBeg WhiteSpace Name WhiteSpace contentspec SMaybe ElementDeclEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ElementDeclBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_contentspec].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_ElementDeclEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_elementdecl].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* contentspec ::= Empty */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Empty].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_contentspec].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Nmtokens ::= Nmtoken */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Nmtoken].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Nmtokens].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* contentspec ::= Any */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Any].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_contentspec].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* contentspec ::= Mixed */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Mixed].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_contentspec].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* contentspec ::= children */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_children].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_contentspec].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* children ::= choice QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_choice].symbolId,
                                     aXml10SymbolId[XML10_QuantifierMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_children].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* children ::= seq QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_seq].symbolId,
                                     aXml10SymbolId[XML10_QuantifierMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_children].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* cp ::= Name QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_QuantifierMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_cp].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* cp ::= choice QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_choice].symbolId,
                                     aXml10SymbolId[XML10_QuantifierMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_cp].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* cp ::= seq QuantifierMaybe */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_seq].symbolId,
                                     aXml10SymbolId[XML10_QuantifierMaybe].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_cp].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* choice ::= Lparen SMaybe cp ChoiceInteriorMany SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Lparen].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_cp].symbolId,
                                     aXml10SymbolId[XML10_ChoiceInteriorMany].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Rparen].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_choice].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* seq ::= Lparen SMaybe cp SeqInteriorAny SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Lparen].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_cp].symbolId,
                                     aXml10SymbolId[XML10_SeqInteriorAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Rparen].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_seq].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Nmtokens ::= x20 Nmtokens */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_x20].symbolId,
                                     aXml10SymbolId[XML10_Nmtokens].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Nmtokens].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Mixed ::= Lparen SMaybe Pcdata MixedInteriorAny SMaybe RparenStar */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Lparen].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Pcdata].symbolId,
                                     aXml10SymbolId[XML10_MixedInteriorAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_RparenStar].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Mixed].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Mixed ::= Lparen SMaybe Pcdata SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Lparen].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Pcdata].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Rparen].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Mixed].symbolId , 5, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttlistDecl ::= AttlistBeg WhiteSpace Name AttDefAny SMaybe AttlistEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_AttlistBeg].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_AttDefAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_AttlistEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttlistDecl].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttDef ::= WhiteSpace Name WhiteSpace AttType WhiteSpace DefaultDecl */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_AttType].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_DefaultDecl].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttDef].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttType ::= StringType */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_StringType].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttType ::= TokenizedType */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TokenizedType].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttType ::= EnumeratedType */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_EnumeratedType].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* StringType ::= STRINGTYPE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_STRINGTYPE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_StringType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeId */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeId].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeIdref */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeIdref].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EntityValue ::= ENTITYVALUE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ENTITYVALUE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EntityValue].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeIdrefs */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeIdrefs].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeEntity */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeEntity].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeEntities */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeEntities].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeNmtoken */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeNmtoken].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* TokenizedType ::= TypeNmtokens */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_TypeNmtokens].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_TokenizedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EnumeratedType ::= NotationType */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_NotationType].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EnumeratedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* EnumeratedType ::= Enumeration */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Enumeration].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_EnumeratedType].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* NotationType ::= Notation WhiteSpace Lparen SMaybe Name NotationTypeInteriorAny SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Notation].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_Lparen].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Name].symbolId,
                                     aXml10SymbolId[XML10_NotationTypeInteriorAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Rparen].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_NotationType].symbolId , 8, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Enumeration ::= Lparen SMaybe Nmtoken EnumerationInteriorAny SMaybe Rparen */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Lparen].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Nmtoken].symbolId,
                                     aXml10SymbolId[XML10_EnumerationInteriorAny].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Rparen].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Enumeration].symbolId , 6, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DefaultDecl ::= Required */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Required].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DefaultDecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* AttValue ::= ATTVALUE */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ATTVALUE].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_AttValue].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DefaultDecl ::= Implied */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Implied].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DefaultDecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DefaultDecl ::= AttValue */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_AttValue].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DefaultDecl].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* DefaultDecl ::= Fixed WhiteSpace AttValue */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Fixed].symbolId,
                                     aXml10SymbolId[XML10_WhiteSpace].symbolId,
                                     aXml10SymbolId[XML10_AttValue].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_DefaultDecl].symbolId , 3, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* conditionalSect ::= includeSect */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_includeSect].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_conditionalSect].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* conditionalSect ::= ignoreSect */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_ignoreSect].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_conditionalSect].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* includeSect ::= SectBeg SMaybe Include SMaybe Lbracket extSubsetDecl SectEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SectBeg].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Include].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Lbracket].symbolId,
                                     aXml10SymbolId[XML10_extSubsetDecl].symbolId,
                                     aXml10SymbolId[XML10_SectEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_includeSect].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ignoreSect ::= SectBeg SMaybe TOKIgnore SMaybe Lbracket ignoreSectContentsAny SectEnd */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_SectBeg].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_TOKIgnore].symbolId,
                                     aXml10SymbolId[XML10_SMaybe].symbolId,
                                     aXml10SymbolId[XML10_Lbracket].symbolId,
                                     aXml10SymbolId[XML10_ignoreSectContentsAny].symbolId,
                                     aXml10SymbolId[XML10_SectEnd].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ignoreSect].symbolId , 7, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* ignoreSectContents ::= Ignore ignoreSectContentsInteriorAny */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_Ignore].symbolId,
                                     aXml10SymbolId[XML10_ignoreSectContentsInteriorAny].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_ignoreSectContents].symbolId , 2, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* Ignore ::= IGNORE_INTERIOR */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_IGNORE_INTERIOR].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_Ignore].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }
    {
        /* CharRef ::= CHARREF */
        Marpa_Symbol_ID rhsIds[] = {
                                     aXml10SymbolId[XML10_CHARREF].symbolId
                                   };
        marpaUtilSetRule(g, aXml10SymbolId[XML10_CharRef].symbolId , 1, &(rhsIds[0]), -1, -1, 0, 0);
    }

    /* Set start symbol */
    marpaUtilSetStartSymbol(g, aXml10SymbolId[XML10___start_].symbolId);

    /* Precompute grammar */
    marpaUtilPrecomputeG(g);

    return g;
}


#endif /* XML10_C */
