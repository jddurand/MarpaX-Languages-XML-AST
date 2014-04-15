/*
 * Tue Apr 15 11:48:56 2014
 *
 * Generated with:
 * perl GenerateLowLevel.pl --bnf bnf/xml10.bnf --prefix xml10 --output xml10.c
 *
 */

#ifndef XML10_C
#define XML10_C

#include "xmlTypes.h"

enum {
    XML10_ANY = 0                           ,
    XML10_ATTLIST_BEG                       ,
    XML10_ATTVALUE                          ,
    XML10_Any                               ,
    XML10_AttDef                            ,
    XML10_AttDefAny                         ,
    XML10_AttType                           ,
    XML10_AttValue                          ,
    XML10_AttlistBeg                        ,
    XML10_AttlistDecl                       ,
    XML10_AttlistEnd                        ,
    XML10_Attribute                         ,
    XML10_CDATA                             ,
    XML10_CDEND                             ,
    XML10_CDEnd                             ,
    XML10_CDSTART                           ,
    XML10_CDSect                            ,
    XML10_CDStart                           ,
    XML10_CData                             ,
    XML10_CHAR                              ,
    XML10_CHARDATA                          ,
    XML10_CHARREF                           ,
    XML10_COMMA                             ,
    XML10_COMMENT                           ,
    XML10_COMMENT_BEG                       ,
    XML10_COMMENT_END                       ,
    XML10_Char                              ,
    XML10_CharData                          ,
    XML10_CharDataMaybe                     ,
    XML10_CharRef                           ,
    XML10_ChoiceInterior                    ,
    XML10_ChoiceInteriorMany                ,
    XML10_Comma                             ,
    XML10_Comment                           ,
    XML10_CommentBeg                        ,
    XML10_CommentEnd                        ,
    XML10_CommentInterior                   ,
    XML10_ContentInterior                   ,
    XML10_ContentInteriorAny                ,
    XML10_DOCTYPE_BEG                       ,
    XML10_DQUOTE                            ,
    XML10_DeclSep                           ,
    XML10_DefaultDecl                       ,
    XML10_DoctypeBeg                        ,
    XML10_DoctypeEnd                        ,
    XML10_Dquote                            ,
    XML10_EDECL_BEG                         ,
    XML10_ELEMENTDECL_BEG                   ,
    XML10_EMPTY                             ,
    XML10_EMPTYELEMTAG_END                  ,
    XML10_ENCNAME                           ,
    XML10_ENCODING                          ,
    XML10_ENTITYREF                         ,
    XML10_ENTITYVALUE                       ,
    XML10_EQUAL                             ,
    XML10_ETAG_BEG                          ,
    XML10_ETAG_END                          ,
    XML10_ETag                              ,
    XML10_ETagBeg                           ,
    XML10_ETagEnd                           ,
    XML10_EdeclBeg                          ,
    XML10_EdeclEnd                          ,
    XML10_ElementDeclBeg                    ,
    XML10_ElementDeclEnd                    ,
    XML10_Empty                             ,
    XML10_EmptyElemTag                      ,
    XML10_EmptyElemTagBeg                   ,
    XML10_EmptyElemTagEnd                   ,
    XML10_EmptyElemTagInterior              ,
    XML10_EmptyElemTagInteriorAny           ,
    XML10_EncName                           ,
    XML10_Encoding                          ,
    XML10_EncodingDecl                      ,
    XML10_EncodingDeclMaybe                 ,
    XML10_EntityDecl                        ,
    XML10_EntityDef                         ,
    XML10_EntityRef                         ,
    XML10_EntityValue                       ,
    XML10_EnumeratedType                    ,
    XML10_Enumeration                       ,
    XML10_EnumerationInterior               ,
    XML10_EnumerationInteriorAny            ,
    XML10_Eq                                ,
    XML10_Equal                             ,
    XML10_ExternalID                        ,
    XML10_FIXED                             ,
    XML10_Fixed                             ,
    XML10_GEDecl                            ,
    XML10_IGNORE                            ,
    XML10_IGNORE_INTERIOR                   ,
    XML10_IMPLIED                           ,
    XML10_INCLUDE                           ,
    XML10_Ignore                            ,
    XML10_Implied                           ,
    XML10_Include                           ,
    XML10_LBRACKET                          ,
    XML10_LPAREN                            ,
    XML10_Lbracket                          ,
    XML10_Lparen                            ,
    XML10_Misc                              ,
    XML10_MiscAny                           ,
    XML10_Mixed                             ,
    XML10_MixedInterior                     ,
    XML10_MixedInteriorAny                  ,
    XML10_NAME                              ,
    XML10_NDATA                             ,
    XML10_NDataDecl                         ,
    XML10_NMTOKEN                           ,
    XML10_NO                                ,
    XML10_NOTATION                          ,
    XML10_NOTATION_BEG                      ,
    XML10_Name                              ,
    XML10_Names                             ,
    XML10_Ndata                             ,
    XML10_Nmtoken                           ,
    XML10_Nmtokens                          ,
    XML10_No                                ,
    XML10_Notation                          ,
    XML10_NotationBeg                       ,
    XML10_NotationDecl                      ,
    XML10_NotationEnd                       ,
    XML10_NotationType                      ,
    XML10_NotationTypeInterior              ,
    XML10_NotationTypeInteriorAny           ,
    XML10_PCDATA                            ,
    XML10_PEDecl                            ,
    XML10_PEDef                             ,
    XML10_PERCENT                           ,
    XML10_PEREFERENCE                       ,
    XML10_PEReference                       ,
    XML10_PI                                ,
    XML10_PIPE                              ,
    XML10_PITARGET                          ,
    XML10_PITarget                          ,
    XML10_PI_BEG                            ,
    XML10_PI_END                            ,
    XML10_PI_INTERIOR                       ,
    XML10_PLUS                              ,
    XML10_PUBIDLITERAL                      ,
    XML10_PUBLIC                            ,
    XML10_Pcdata                            ,
    XML10_Percent                           ,
    XML10_PiBeg                             ,
    XML10_PiEnd                             ,
    XML10_PiInterior                        ,
    XML10_Pipe                              ,
    XML10_Plus                              ,
    XML10_PubidLiteral                      ,
    XML10_Public                            ,
    XML10_PublicID                          ,
    XML10_QUESTION_MARK                     ,
    XML10_Quantifier                        ,
    XML10_QuantifierMaybe                   ,
    XML10_QuestionMark                      ,
    XML10_RBRACKET                          ,
    XML10_REQUIRED                          ,
    XML10_RPAREN                            ,
    XML10_RPARENSTAR                        ,
    XML10_Rbracket                          ,
    XML10_Reference                         ,
    XML10_Required                          ,
    XML10_Rparen                            ,
    XML10_RparenStar                        ,
    XML10_S                                 ,
    XML10_SDDecl                            ,
    XML10_SDDeclMaybe                       ,
    XML10_SECT_BEG                          ,
    XML10_SECT_END                          ,
    XML10_SMaybe                            ,
    XML10_SQUOTE                            ,
    XML10_STAG_END                          ,
    XML10_STANDALONE                        ,
    XML10_STAR                              ,
    XML10_STRINGTYPE                        ,
    XML10_STag                              ,
    XML10_STagBeg                           ,
    XML10_STagEnd                           ,
    XML10_STagInterior                      ,
    XML10_STagInteriorAny                   ,
    XML10_SYSTEM                            ,
    XML10_SYSTEMLITERAL                     ,
    XML10_SectBeg                           ,
    XML10_SectEnd                           ,
    XML10_SeqInterior                       ,
    XML10_SeqInteriorAny                    ,
    XML10_Squote                            ,
    XML10_Standalone                        ,
    XML10_Star                              ,
    XML10_StringType                        ,
    XML10_System                            ,
    XML10_SystemLiteral                     ,
    XML10_TOKIgnore                         ,
    XML10_TYPE_ENTITIES                     ,
    XML10_TYPE_ENTITY                       ,
    XML10_TYPE_ID                           ,
    XML10_TYPE_IDREF                        ,
    XML10_TYPE_IDREFS                       ,
    XML10_TYPE_NMTOKEN                      ,
    XML10_TYPE_NMTOKENS                     ,
    XML10_TextDecl                          ,
    XML10_TokenizedType                     ,
    XML10_TypeEntities                      ,
    XML10_TypeEntity                        ,
    XML10_TypeId                            ,
    XML10_TypeIdref                         ,
    XML10_TypeIdrefs                        ,
    XML10_TypeNmtoken                       ,
    XML10_TypeNmtokens                      ,
    XML10_VERSION                           ,
    XML10_VERSIONNUM                        ,
    XML10_Version                           ,
    XML10_VersionInfo                       ,
    XML10_VersionInfoMaybe                  ,
    XML10_VersionNum                        ,
    XML10_WhiteSpace                        ,
    XML10_X20                               ,
    XML10_XMLDecl                           ,
    XML10_XMLDeclMaybe                      ,
    XML10_XML_BEG                           ,
    XML10_XML_END                           ,
    XML10_XTAG_BEG                          ,
    XML10_XTAG_END                          ,
    XML10_XTagBeg                           ,
    XML10_XTagEnd                           ,
    XML10_XmlBeg                            ,
    XML10_XmlEnd                            ,
    XML10_YES                               ,
    XML10_Yes                               ,
    XML10___start_                          , /* [:start] (Internal G1 start symbol) */
    XML10_children                          ,
    XML10_choice                            ,
    XML10_conditionalSect                   ,
    XML10_content                           ,
    XML10_contentspec                       ,
    XML10_cp                                ,
    XML10_doctypedecl                       ,
    XML10_document                          ,
    XML10_element                           ,
    XML10_elementdecl                       ,
    XML10_extParsedEnt                      ,
    XML10_extSubset                         ,
    XML10_extSubsetDecl                     ,
    XML10_extSubsetDeclUnit                 ,
    XML10_extSubsetDeclUnitAny              ,
    XML10_ignoreSect                        ,
    XML10_ignoreSectContents                ,
    XML10_ignoreSectContentsAny             ,
    XML10_ignoreSectContentsInterior        ,
    XML10_ignoreSectContentsInteriorAny     ,
    XML10_includeSect                       ,
    XML10_intSubset                         ,
    XML10_intSubsetUnit                     ,
    XML10_intSubsetUnitAny                  ,
    XML10_markupdecl                        ,
    XML10_prolog                            ,
    XML10_seq                               ,
    XML10_x20                               ,
};
struct sXmlSymbolId aXml10SymbolId[] = {
   /*
    * Id, Enum                                    , Name                                    , Description
    */
    { -1, XML10_ANY                               , "ANY"                                   , "ANY" },
    { -1, XML10_ATTLIST_BEG                       , "ATTLIST_BEG"                           , "ATTLIST_BEG" },
    { -1, XML10_ATTVALUE                          , "ATTVALUE"                              , "ATTVALUE" },
    { -1, XML10_Any                               , "Any"                                   , "Any" },
    { -1, XML10_AttDef                            , "AttDef"                                , "AttDef" },
    { -1, XML10_AttDefAny                         , "AttDefAny"                             , "AttDefAny" },
    { -1, XML10_AttType                           , "AttType"                               , "AttType" },
    { -1, XML10_AttValue                          , "AttValue"                              , "AttValue" },
    { -1, XML10_AttlistBeg                        , "AttlistBeg"                            , "AttlistBeg" },
    { -1, XML10_AttlistDecl                       , "AttlistDecl"                           , "AttlistDecl" },
    { -1, XML10_AttlistEnd                        , "AttlistEnd"                            , "AttlistEnd" },
    { -1, XML10_Attribute                         , "Attribute"                             , "Attribute" },
    { -1, XML10_CDATA                             , "CDATA"                                 , "CDATA" },
    { -1, XML10_CDEND                             , "CDEND"                                 , "CDEND" },
    { -1, XML10_CDEnd                             , "CDEnd"                                 , "CDEnd" },
    { -1, XML10_CDSTART                           , "CDSTART"                               , "CDSTART" },
    { -1, XML10_CDSect                            , "CDSect"                                , "CDSect" },
    { -1, XML10_CDStart                           , "CDStart"                               , "CDStart" },
    { -1, XML10_CData                             , "CData"                                 , "CData" },
    { -1, XML10_CHAR                              , "CHAR"                                  , "CHAR" },
    { -1, XML10_CHARDATA                          , "CHARDATA"                              , "CHARDATA" },
    { -1, XML10_CHARREF                           , "CHARREF"                               , "CHARREF" },
    { -1, XML10_COMMA                             , "COMMA"                                 , "COMMA" },
    { -1, XML10_COMMENT                           , "COMMENT"                               , "COMMENT" },
    { -1, XML10_COMMENT_BEG                       , "COMMENT_BEG"                           , "COMMENT_BEG" },
    { -1, XML10_COMMENT_END                       , "COMMENT_END"                           , "COMMENT_END" },
    { -1, XML10_Char                              , "Char"                                  , "Char" },
    { -1, XML10_CharData                          , "CharData"                              , "CharData" },
    { -1, XML10_CharDataMaybe                     , "CharDataMaybe"                         , "CharDataMaybe" },
    { -1, XML10_CharRef                           , "CharRef"                               , "CharRef" },
    { -1, XML10_ChoiceInterior                    , "ChoiceInterior"                        , "ChoiceInterior" },
    { -1, XML10_ChoiceInteriorMany                , "ChoiceInteriorMany"                    , "ChoiceInteriorMany" },
    { -1, XML10_Comma                             , "Comma"                                 , "Comma" },
    { -1, XML10_Comment                           , "Comment"                               , "Comment" },
    { -1, XML10_CommentBeg                        , "CommentBeg"                            , "CommentBeg" },
    { -1, XML10_CommentEnd                        , "CommentEnd"                            , "CommentEnd" },
    { -1, XML10_CommentInterior                   , "CommentInterior"                       , "CommentInterior" },
    { -1, XML10_ContentInterior                   , "ContentInterior"                       , "ContentInterior" },
    { -1, XML10_ContentInteriorAny                , "ContentInteriorAny"                    , "ContentInteriorAny" },
    { -1, XML10_DOCTYPE_BEG                       , "DOCTYPE_BEG"                           , "DOCTYPE_BEG" },
    { -1, XML10_DQUOTE                            , "DQUOTE"                                , "DQUOTE" },
    { -1, XML10_DeclSep                           , "DeclSep"                               , "DeclSep" },
    { -1, XML10_DefaultDecl                       , "DefaultDecl"                           , "DefaultDecl" },
    { -1, XML10_DoctypeBeg                        , "DoctypeBeg"                            , "DoctypeBeg" },
    { -1, XML10_DoctypeEnd                        , "DoctypeEnd"                            , "DoctypeEnd" },
    { -1, XML10_Dquote                            , "Dquote"                                , "Dquote" },
    { -1, XML10_EDECL_BEG                         , "EDECL_BEG"                             , "EDECL_BEG" },
    { -1, XML10_ELEMENTDECL_BEG                   , "ELEMENTDECL_BEG"                       , "ELEMENTDECL_BEG" },
    { -1, XML10_EMPTY                             , "EMPTY"                                 , "EMPTY" },
    { -1, XML10_EMPTYELEMTAG_END                  , "EMPTYELEMTAG_END"                      , "EMPTYELEMTAG_END" },
    { -1, XML10_ENCNAME                           , "ENCNAME"                               , "ENCNAME" },
    { -1, XML10_ENCODING                          , "ENCODING"                              , "ENCODING" },
    { -1, XML10_ENTITYREF                         , "ENTITYREF"                             , "ENTITYREF" },
    { -1, XML10_ENTITYVALUE                       , "ENTITYVALUE"                           , "ENTITYVALUE" },
    { -1, XML10_EQUAL                             , "EQUAL"                                 , "EQUAL" },
    { -1, XML10_ETAG_BEG                          , "ETAG_BEG"                              , "ETAG_BEG" },
    { -1, XML10_ETAG_END                          , "ETAG_END"                              , "ETAG_END" },
    { -1, XML10_ETag                              , "ETag"                                  , "ETag" },
    { -1, XML10_ETagBeg                           , "ETagBeg"                               , "ETagBeg" },
    { -1, XML10_ETagEnd                           , "ETagEnd"                               , "ETagEnd" },
    { -1, XML10_EdeclBeg                          , "EdeclBeg"                              , "EdeclBeg" },
    { -1, XML10_EdeclEnd                          , "EdeclEnd"                              , "EdeclEnd" },
    { -1, XML10_ElementDeclBeg                    , "ElementDeclBeg"                        , "ElementDeclBeg" },
    { -1, XML10_ElementDeclEnd                    , "ElementDeclEnd"                        , "ElementDeclEnd" },
    { -1, XML10_Empty                             , "Empty"                                 , "Empty" },
    { -1, XML10_EmptyElemTag                      , "EmptyElemTag"                          , "EmptyElemTag" },
    { -1, XML10_EmptyElemTagBeg                   , "EmptyElemTagBeg"                       , "EmptyElemTagBeg" },
    { -1, XML10_EmptyElemTagEnd                   , "EmptyElemTagEnd"                       , "EmptyElemTagEnd" },
    { -1, XML10_EmptyElemTagInterior              , "EmptyElemTagInterior"                  , "EmptyElemTagInterior" },
    { -1, XML10_EmptyElemTagInteriorAny           , "EmptyElemTagInteriorAny"               , "EmptyElemTagInteriorAny" },
    { -1, XML10_EncName                           , "EncName"                               , "EncName" },
    { -1, XML10_Encoding                          , "Encoding"                              , "Encoding" },
    { -1, XML10_EncodingDecl                      , "EncodingDecl"                          , "EncodingDecl" },
    { -1, XML10_EncodingDeclMaybe                 , "EncodingDeclMaybe"                     , "EncodingDeclMaybe" },
    { -1, XML10_EntityDecl                        , "EntityDecl"                            , "EntityDecl" },
    { -1, XML10_EntityDef                         , "EntityDef"                             , "EntityDef" },
    { -1, XML10_EntityRef                         , "EntityRef"                             , "EntityRef" },
    { -1, XML10_EntityValue                       , "EntityValue"                           , "EntityValue" },
    { -1, XML10_EnumeratedType                    , "EnumeratedType"                        , "EnumeratedType" },
    { -1, XML10_Enumeration                       , "Enumeration"                           , "Enumeration" },
    { -1, XML10_EnumerationInterior               , "EnumerationInterior"                   , "EnumerationInterior" },
    { -1, XML10_EnumerationInteriorAny            , "EnumerationInteriorAny"                , "EnumerationInteriorAny" },
    { -1, XML10_Eq                                , "Eq"                                    , "Eq" },
    { -1, XML10_Equal                             , "Equal"                                 , "Equal" },
    { -1, XML10_ExternalID                        , "ExternalID"                            , "ExternalID" },
    { -1, XML10_FIXED                             , "FIXED"                                 , "FIXED" },
    { -1, XML10_Fixed                             , "Fixed"                                 , "Fixed" },
    { -1, XML10_GEDecl                            , "GEDecl"                                , "GEDecl" },
    { -1, XML10_IGNORE                            , "IGNORE"                                , "IGNORE" },
    { -1, XML10_IGNORE_INTERIOR                   , "IGNORE_INTERIOR"                       , "IGNORE_INTERIOR" },
    { -1, XML10_IMPLIED                           , "IMPLIED"                               , "IMPLIED" },
    { -1, XML10_INCLUDE                           , "INCLUDE"                               , "INCLUDE" },
    { -1, XML10_Ignore                            , "Ignore"                                , "Ignore" },
    { -1, XML10_Implied                           , "Implied"                               , "Implied" },
    { -1, XML10_Include                           , "Include"                               , "Include" },
    { -1, XML10_LBRACKET                          , "LBRACKET"                              , "LBRACKET" },
    { -1, XML10_LPAREN                            , "LPAREN"                                , "LPAREN" },
    { -1, XML10_Lbracket                          , "Lbracket"                              , "Lbracket" },
    { -1, XML10_Lparen                            , "Lparen"                                , "Lparen" },
    { -1, XML10_Misc                              , "Misc"                                  , "Misc" },
    { -1, XML10_MiscAny                           , "MiscAny"                               , "MiscAny" },
    { -1, XML10_Mixed                             , "Mixed"                                 , "Mixed" },
    { -1, XML10_MixedInterior                     , "MixedInterior"                         , "MixedInterior" },
    { -1, XML10_MixedInteriorAny                  , "MixedInteriorAny"                      , "MixedInteriorAny" },
    { -1, XML10_NAME                              , "NAME"                                  , "NAME" },
    { -1, XML10_NDATA                             , "NDATA"                                 , "NDATA" },
    { -1, XML10_NDataDecl                         , "NDataDecl"                             , "NDataDecl" },
    { -1, XML10_NMTOKEN                           , "NMTOKEN"                               , "NMTOKEN" },
    { -1, XML10_NO                                , "NO"                                    , "NO" },
    { -1, XML10_NOTATION                          , "NOTATION"                              , "NOTATION" },
    { -1, XML10_NOTATION_BEG                      , "NOTATION_BEG"                          , "NOTATION_BEG" },
    { -1, XML10_Name                              , "Name"                                  , "Name" },
    { -1, XML10_Names                             , "Names"                                 , "Names" },
    { -1, XML10_Ndata                             , "Ndata"                                 , "Ndata" },
    { -1, XML10_Nmtoken                           , "Nmtoken"                               , "Nmtoken" },
    { -1, XML10_Nmtokens                          , "Nmtokens"                              , "Nmtokens" },
    { -1, XML10_No                                , "No"                                    , "No" },
    { -1, XML10_Notation                          , "Notation"                              , "Notation" },
    { -1, XML10_NotationBeg                       , "NotationBeg"                           , "NotationBeg" },
    { -1, XML10_NotationDecl                      , "NotationDecl"                          , "NotationDecl" },
    { -1, XML10_NotationEnd                       , "NotationEnd"                           , "NotationEnd" },
    { -1, XML10_NotationType                      , "NotationType"                          , "NotationType" },
    { -1, XML10_NotationTypeInterior              , "NotationTypeInterior"                  , "NotationTypeInterior" },
    { -1, XML10_NotationTypeInteriorAny           , "NotationTypeInteriorAny"               , "NotationTypeInteriorAny" },
    { -1, XML10_PCDATA                            , "PCDATA"                                , "PCDATA" },
    { -1, XML10_PEDecl                            , "PEDecl"                                , "PEDecl" },
    { -1, XML10_PEDef                             , "PEDef"                                 , "PEDef" },
    { -1, XML10_PERCENT                           , "PERCENT"                               , "PERCENT" },
    { -1, XML10_PEREFERENCE                       , "PEREFERENCE"                           , "PEREFERENCE" },
    { -1, XML10_PEReference                       , "PEReference"                           , "PEReference" },
    { -1, XML10_PI                                , "PI"                                    , "PI" },
    { -1, XML10_PIPE                              , "PIPE"                                  , "PIPE" },
    { -1, XML10_PITARGET                          , "PITARGET"                              , "PITARGET" },
    { -1, XML10_PITarget                          , "PITarget"                              , "PITarget" },
    { -1, XML10_PI_BEG                            , "PI_BEG"                                , "PI_BEG" },
    { -1, XML10_PI_END                            , "PI_END"                                , "PI_END" },
    { -1, XML10_PI_INTERIOR                       , "PI_INTERIOR"                           , "PI_INTERIOR" },
    { -1, XML10_PLUS                              , "PLUS"                                  , "PLUS" },
    { -1, XML10_PUBIDLITERAL                      , "PUBIDLITERAL"                          , "PUBIDLITERAL" },
    { -1, XML10_PUBLIC                            , "PUBLIC"                                , "PUBLIC" },
    { -1, XML10_Pcdata                            , "Pcdata"                                , "Pcdata" },
    { -1, XML10_Percent                           , "Percent"                               , "Percent" },
    { -1, XML10_PiBeg                             , "PiBeg"                                 , "PiBeg" },
    { -1, XML10_PiEnd                             , "PiEnd"                                 , "PiEnd" },
    { -1, XML10_PiInterior                        , "PiInterior"                            , "PiInterior" },
    { -1, XML10_Pipe                              , "Pipe"                                  , "Pipe" },
    { -1, XML10_Plus                              , "Plus"                                  , "Plus" },
    { -1, XML10_PubidLiteral                      , "PubidLiteral"                          , "PubidLiteral" },
    { -1, XML10_Public                            , "Public"                                , "Public" },
    { -1, XML10_PublicID                          , "PublicID"                              , "PublicID" },
    { -1, XML10_QUESTION_MARK                     , "QUESTION_MARK"                         , "QUESTION_MARK" },
    { -1, XML10_Quantifier                        , "Quantifier"                            , "Quantifier" },
    { -1, XML10_QuantifierMaybe                   , "QuantifierMaybe"                       , "QuantifierMaybe" },
    { -1, XML10_QuestionMark                      , "QuestionMark"                          , "QuestionMark" },
    { -1, XML10_RBRACKET                          , "RBRACKET"                              , "RBRACKET" },
    { -1, XML10_REQUIRED                          , "REQUIRED"                              , "REQUIRED" },
    { -1, XML10_RPAREN                            , "RPAREN"                                , "RPAREN" },
    { -1, XML10_RPARENSTAR                        , "RPARENSTAR"                            , "RPARENSTAR" },
    { -1, XML10_Rbracket                          , "Rbracket"                              , "Rbracket" },
    { -1, XML10_Reference                         , "Reference"                             , "Reference" },
    { -1, XML10_Required                          , "Required"                              , "Required" },
    { -1, XML10_Rparen                            , "Rparen"                                , "Rparen" },
    { -1, XML10_RparenStar                        , "RparenStar"                            , "RparenStar" },
    { -1, XML10_S                                 , "S"                                     , "S" },
    { -1, XML10_SDDecl                            , "SDDecl"                                , "SDDecl" },
    { -1, XML10_SDDeclMaybe                       , "SDDeclMaybe"                           , "SDDeclMaybe" },
    { -1, XML10_SECT_BEG                          , "SECT_BEG"                              , "SECT_BEG" },
    { -1, XML10_SECT_END                          , "SECT_END"                              , "SECT_END" },
    { -1, XML10_SMaybe                            , "SMaybe"                                , "SMaybe" },
    { -1, XML10_SQUOTE                            , "SQUOTE"                                , "SQUOTE" },
    { -1, XML10_STAG_END                          , "STAG_END"                              , "STAG_END" },
    { -1, XML10_STANDALONE                        , "STANDALONE"                            , "STANDALONE" },
    { -1, XML10_STAR                              , "STAR"                                  , "STAR" },
    { -1, XML10_STRINGTYPE                        , "STRINGTYPE"                            , "STRINGTYPE" },
    { -1, XML10_STag                              , "STag"                                  , "STag" },
    { -1, XML10_STagBeg                           , "STagBeg"                               , "STagBeg" },
    { -1, XML10_STagEnd                           , "STagEnd"                               , "STagEnd" },
    { -1, XML10_STagInterior                      , "STagInterior"                          , "STagInterior" },
    { -1, XML10_STagInteriorAny                   , "STagInteriorAny"                       , "STagInteriorAny" },
    { -1, XML10_SYSTEM                            , "SYSTEM"                                , "SYSTEM" },
    { -1, XML10_SYSTEMLITERAL                     , "SYSTEMLITERAL"                         , "SYSTEMLITERAL" },
    { -1, XML10_SectBeg                           , "SectBeg"                               , "SectBeg" },
    { -1, XML10_SectEnd                           , "SectEnd"                               , "SectEnd" },
    { -1, XML10_SeqInterior                       , "SeqInterior"                           , "SeqInterior" },
    { -1, XML10_SeqInteriorAny                    , "SeqInteriorAny"                        , "SeqInteriorAny" },
    { -1, XML10_Squote                            , "Squote"                                , "Squote" },
    { -1, XML10_Standalone                        , "Standalone"                            , "Standalone" },
    { -1, XML10_Star                              , "Star"                                  , "Star" },
    { -1, XML10_StringType                        , "StringType"                            , "StringType" },
    { -1, XML10_System                            , "System"                                , "System" },
    { -1, XML10_SystemLiteral                     , "SystemLiteral"                         , "SystemLiteral" },
    { -1, XML10_TOKIgnore                         , "TOKIgnore"                             , "TOKIgnore" },
    { -1, XML10_TYPE_ENTITIES                     , "TYPE_ENTITIES"                         , "TYPE_ENTITIES" },
    { -1, XML10_TYPE_ENTITY                       , "TYPE_ENTITY"                           , "TYPE_ENTITY" },
    { -1, XML10_TYPE_ID                           , "TYPE_ID"                               , "TYPE_ID" },
    { -1, XML10_TYPE_IDREF                        , "TYPE_IDREF"                            , "TYPE_IDREF" },
    { -1, XML10_TYPE_IDREFS                       , "TYPE_IDREFS"                           , "TYPE_IDREFS" },
    { -1, XML10_TYPE_NMTOKEN                      , "TYPE_NMTOKEN"                          , "TYPE_NMTOKEN" },
    { -1, XML10_TYPE_NMTOKENS                     , "TYPE_NMTOKENS"                         , "TYPE_NMTOKENS" },
    { -1, XML10_TextDecl                          , "TextDecl"                              , "TextDecl" },
    { -1, XML10_TokenizedType                     , "TokenizedType"                         , "TokenizedType" },
    { -1, XML10_TypeEntities                      , "TypeEntities"                          , "TypeEntities" },
    { -1, XML10_TypeEntity                        , "TypeEntity"                            , "TypeEntity" },
    { -1, XML10_TypeId                            , "TypeId"                                , "TypeId" },
    { -1, XML10_TypeIdref                         , "TypeIdref"                             , "TypeIdref" },
    { -1, XML10_TypeIdrefs                        , "TypeIdrefs"                            , "TypeIdrefs" },
    { -1, XML10_TypeNmtoken                       , "TypeNmtoken"                           , "TypeNmtoken" },
    { -1, XML10_TypeNmtokens                      , "TypeNmtokens"                          , "TypeNmtokens" },
    { -1, XML10_VERSION                           , "VERSION"                               , "VERSION" },
    { -1, XML10_VERSIONNUM                        , "VERSIONNUM"                            , "VERSIONNUM" },
    { -1, XML10_Version                           , "Version"                               , "Version" },
    { -1, XML10_VersionInfo                       , "VersionInfo"                           , "VersionInfo" },
    { -1, XML10_VersionInfoMaybe                  , "VersionInfoMaybe"                      , "VersionInfoMaybe" },
    { -1, XML10_VersionNum                        , "VersionNum"                            , "VersionNum" },
    { -1, XML10_WhiteSpace                        , "WhiteSpace"                            , "WhiteSpace" },
    { -1, XML10_X20                               , "X20"                                   , "X20" },
    { -1, XML10_XMLDecl                           , "XMLDecl"                               , "XMLDecl" },
    { -1, XML10_XMLDeclMaybe                      , "XMLDeclMaybe"                          , "XMLDeclMaybe" },
    { -1, XML10_XML_BEG                           , "XML_BEG"                               , "XML_BEG" },
    { -1, XML10_XML_END                           , "XML_END"                               , "XML_END" },
    { -1, XML10_XTAG_BEG                          , "XTAG_BEG"                              , "XTAG_BEG" },
    { -1, XML10_XTAG_END                          , "XTAG_END"                              , "XTAG_END" },
    { -1, XML10_XTagBeg                           , "XTagBeg"                               , "XTagBeg" },
    { -1, XML10_XTagEnd                           , "XTagEnd"                               , "XTagEnd" },
    { -1, XML10_XmlBeg                            , "XmlBeg"                                , "XmlBeg" },
    { -1, XML10_XmlEnd                            , "XmlEnd"                                , "XmlEnd" },
    { -1, XML10_YES                               , "YES"                                   , "YES" },
    { -1, XML10_Yes                               , "Yes"                                   , "Yes" },
    { -1, XML10___start_                          , "[:start]"                              , "Internal G1 start symbol" },
    { -1, XML10_children                          , "children"                              , "children" },
    { -1, XML10_choice                            , "choice"                                , "choice" },
    { -1, XML10_conditionalSect                   , "conditionalSect"                       , "conditionalSect" },
    { -1, XML10_content                           , "content"                               , "content" },
    { -1, XML10_contentspec                       , "contentspec"                           , "contentspec" },
    { -1, XML10_cp                                , "cp"                                    , "cp" },
    { -1, XML10_doctypedecl                       , "doctypedecl"                           , "doctypedecl" },
    { -1, XML10_document                          , "document"                              , "document" },
    { -1, XML10_element                           , "element"                               , "element" },
    { -1, XML10_elementdecl                       , "elementdecl"                           , "elementdecl" },
    { -1, XML10_extParsedEnt                      , "extParsedEnt"                          , "extParsedEnt" },
    { -1, XML10_extSubset                         , "extSubset"                             , "extSubset" },
    { -1, XML10_extSubsetDecl                     , "extSubsetDecl"                         , "extSubsetDecl" },
    { -1, XML10_extSubsetDeclUnit                 , "extSubsetDeclUnit"                     , "extSubsetDeclUnit" },
    { -1, XML10_extSubsetDeclUnitAny              , "extSubsetDeclUnitAny"                  , "extSubsetDeclUnitAny" },
    { -1, XML10_ignoreSect                        , "ignoreSect"                            , "ignoreSect" },
    { -1, XML10_ignoreSectContents                , "ignoreSectContents"                    , "ignoreSectContents" },
    { -1, XML10_ignoreSectContentsAny             , "ignoreSectContentsAny"                 , "ignoreSectContentsAny" },
    { -1, XML10_ignoreSectContentsInterior        , "ignoreSectContentsInterior"            , "ignoreSectContentsInterior" },
    { -1, XML10_ignoreSectContentsInteriorAny     , "ignoreSectContentsInteriorAny"         , "ignoreSectContentsInteriorAny" },
    { -1, XML10_includeSect                       , "includeSect"                           , "includeSect" },
    { -1, XML10_intSubset                         , "intSubset"                             , "intSubset" },
    { -1, XML10_intSubsetUnit                     , "intSubsetUnit"                         , "intSubsetUnit" },
    { -1, XML10_intSubsetUnitAny                  , "intSubsetUnitAny"                      , "intSubsetUnitAny" },
    { -1, XML10_markupdecl                        , "markupdecl"                            , "markupdecl" },
    { -1, XML10_prolog                            , "prolog"                                , "prolog" },
    { -1, XML10_seq                               , "seq"                                   , "seq" },
    { -1, XML10_x20                               , "x20"                                   , "x20" },
};

#define XML10_NUMBER_OF_SYMBOLS 257

static void _fillXml10G(g)
    Marpa_Grammar g;
{
    /* Create all the symbols */
    _fillSymbols(g, XML10_NUMBER_OF_SYMBOLS, aXml10SymbolId);

    /* Populate the rules */
    /* :start ::= document */
    _fillRule(g, 0 , 1, 1);
    /* document ::= prolog element MiscAny */
    _fillRule(g, 1 , 3, 2, 3, 4);
    /* x20 ::= X20 */
    _fillRule(g, 10 , 1, 177);
    /* Any ::= ANY */
    _fillRule(g, 100 , 1, 222);
    /* Mixed ::= Lparen SMaybe Pcdata SMaybe Rparen */
    _fillRule(g, 101 , 5, 107, 49, 111, 49, 109);
    /* children ::= seq QuantifierMaybe */
    _fillRule(g, 102 , 2, 105, 104);
    /* choice ::= Lparen SMaybe cp ChoiceInteriorMany SMaybe Rparen */
    _fillRule(g, 103 , 6, 107, 49, 106, 108, 49, 109);
    /* QuantifierMaybe ::= */
    _fillRule(g, 104 , 0);
    /* seq ::= Lparen SMaybe cp SeqInteriorAny SMaybe Rparen */
    _fillRule(g, 105 , 6, 107, 49, 106, 110, 49, 109);
    /* cp ::= seq QuantifierMaybe */
    _fillRule(g, 106 , 2, 105, 104);
    /* Lparen ::= LPAREN */
    _fillRule(g, 107 , 1, 226);
    /* ChoiceInteriorMany ::= ChoiceInterior + */
    _fillRule(g, 108 , 1, 187);
    /* Rparen ::= RPAREN */
    _fillRule(g, 109 , 1, 227);
    /* Nmtoken ::= NMTOKEN */
    _fillRule(g, 11 , 1, 12);
    /* SeqInteriorAny ::= SeqInterior * */
    _fillRule(g, 110 , 1, 189);
    /* Pcdata ::= PCDATA */
    _fillRule(g, 111 , 1, 254);
    /* MixedInteriorAny ::= MixedInterior * */
    _fillRule(g, 112 , 1, 191);
    /* RparenStar ::= RPARENSTAR */
    _fillRule(g, 113 , 1, 228);
    /* AttlistBeg ::= ATTLIST_BEG */
    _fillRule(g, 114 , 1, 231);
    /* AttDefAny ::= AttDef * */
    _fillRule(g, 115 , 1, 117);
    /* AttlistEnd ::= XTagEnd */
    _fillRule(g, 116 , 1, 207);
    /* AttDef ::= WhiteSpace Name WhiteSpace AttType WhiteSpace DefaultDecl */
    _fillRule(g, 117 , 6, 33, 7, 33, 118, 33, 119);
    /* AttType ::= EnumeratedType */
    _fillRule(g, 118 , 1, 122);
    /* DefaultDecl ::= Fixed WhiteSpace AttValue */
    _fillRule(g, 119 , 3, 138, 33, 16);
    /* StringType ::= STRINGTYPE */
    _fillRule(g, 120 , 1, 123);
    /* TokenizedType ::= TypeNmtokens */
    _fillRule(g, 121 , 1, 130);
    /* EnumeratedType ::= Enumeration */
    _fillRule(g, 122 , 1, 132);
    /* TypeId ::= TYPE_ID */
    _fillRule(g, 124 , 1, 232);
    /* TypeIdref ::= TYPE_IDREF */
    _fillRule(g, 125 , 1, 233);
    /* TypeIdrefs ::= TYPE_IDREFS */
    _fillRule(g, 126 , 1, 234);
    /* TypeEntity ::= TYPE_ENTITY */
    _fillRule(g, 127 , 1, 235);
    /* TypeEntities ::= TYPE_ENTITIES */
    _fillRule(g, 128 , 1, 236);
    /* TypeNmtoken ::= TYPE_NMTOKEN */
    _fillRule(g, 129 , 1, 237);
    /* Nmtokens ::= x20 Nmtokens */
    _fillRule(g, 13 , 2, 10, 13);
    /* TypeNmtokens ::= TYPE_NMTOKENS */
    _fillRule(g, 130 , 1, 238);
    /* NotationType ::= Notation WhiteSpace Lparen SMaybe Name NotationTypeInteriorAny SMaybe Rparen */
    _fillRule(g, 131 , 8, 133, 33, 107, 49, 7, 134, 49, 109);
    /* Enumeration ::= Lparen SMaybe Nmtoken EnumerationInteriorAny SMaybe Rparen */
    _fillRule(g, 132 , 6, 107, 49, 11, 135, 49, 109);
    /* Notation ::= NOTATION */
    _fillRule(g, 133 , 1, 239);
    /* NotationTypeInteriorAny ::= NotationTypeInterior * */
    _fillRule(g, 134 , 1, 192);
    /* EnumerationInteriorAny ::= EnumerationInterior * */
    _fillRule(g, 135 , 1, 193);
    /* Required ::= REQUIRED */
    _fillRule(g, 136 , 1, 241);
    /* Implied ::= IMPLIED */
    _fillRule(g, 137 , 1, 242);
    /* Fixed ::= FIXED */
    _fillRule(g, 138 , 1, 243);
    /* conditionalSect ::= ignoreSect */
    _fillRule(g, 139 , 1, 141);
    /* EntityValue ::= ENTITYVALUE */
    _fillRule(g, 14 , 1, 15);
    /* includeSect ::= SectBeg SMaybe Include SMaybe Lbracket extSubsetDecl SectEnd */
    _fillRule(g, 140 , 7, 142, 49, 143, 49, 61, 74, 144);
    /* ignoreSect ::= SectBeg SMaybe TOKIgnore SMaybe Lbracket ignoreSectContentsAny SectEnd */
    _fillRule(g, 141 , 7, 142, 49, 145, 49, 61, 146, 144);
    /* SectBeg ::= SECT_BEG */
    _fillRule(g, 142 , 1, 244);
    /* Include ::= INCLUDE */
    _fillRule(g, 143 , 1, 246);
    /* SectEnd ::= SECT_END */
    _fillRule(g, 144 , 1, 245);
    /* TOKIgnore ::= IGNORE */
    _fillRule(g, 145 , 1, 253);
    /* ignoreSectContentsAny ::= ignoreSectContents * */
    _fillRule(g, 146 , 1, 147);
    /* ignoreSectContents ::= Ignore ignoreSectContentsInteriorAny */
    _fillRule(g, 147 , 2, 148, 149);
    /* Ignore ::= IGNORE_INTERIOR */
    _fillRule(g, 148 , 1, 150);
    /* ignoreSectContentsInteriorAny ::= ignoreSectContentsInterior * */
    _fillRule(g, 149 , 1, 194);
    /* CharRef ::= CHARREF */
    _fillRule(g, 151 , 1, 152);
    /* Reference ::= CharRef */
    _fillRule(g, 153 , 1, 151);
    /* EntityRef ::= ENTITYREF */
    _fillRule(g, 154 , 1, 155);
    /* GEDecl ::= EdeclBeg WhiteSpace Name WhiteSpace EntityDef SMaybe EdeclEnd */
    _fillRule(g, 157 , 7, 159, 33, 7, 33, 160, 49, 161);
    /* PEDecl ::= EdeclBeg WhiteSpace Percent WhiteSpace Name WhiteSpace PEDef SMaybe EdeclEnd */
    _fillRule(g, 158 , 9, 159, 33, 162, 33, 7, 33, 163, 49, 161);
    /* EdeclBeg ::= EDECL_BEG */
    _fillRule(g, 159 , 1, 247);
    /* AttValue ::= ATTVALUE */
    _fillRule(g, 16 , 1, 17);
    /* EntityDef ::= ExternalID NDataDecl */
    _fillRule(g, 160 , 2, 64, 164);
    /* EdeclEnd ::= XTagEnd */
    _fillRule(g, 161 , 1, 207);
    /* Percent ::= PERCENT */
    _fillRule(g, 162 , 1, 248);
    /* PEDef ::= ExternalID */
    _fillRule(g, 163 , 1, 64);
    /* NDataDecl ::= WhiteSpace Ndata WhiteSpace Name */
    _fillRule(g, 164 , 4, 33, 167, 33, 7);
    /* System ::= SYSTEM */
    _fillRule(g, 165 , 1, 249);
    /* Public ::= PUBLIC */
    _fillRule(g, 166 , 1, 250);
    /* Ndata ::= NDATA */
    _fillRule(g, 167 , 1, 251);
    /* VersionInfoMaybe ::= */
    _fillRule(g, 168 , 0);
    /* EncodingDecl ::= WhiteSpace Encoding Eq Squote EncName Squote */
    _fillRule(g, 169 , 6, 33, 171, 52, 53, 172, 53);
    /* extParsedEnt ::= TextDecl content */
    _fillRule(g, 170 , 2, 75, 83);
    /* Encoding ::= ENCODING */
    _fillRule(g, 171 , 1, 252);
    /* EncName ::= ENCNAME */
    _fillRule(g, 172 , 1, 173);
    /* NotationBeg ::= NOTATION_BEG */
    _fillRule(g, 174 , 1, 240);
    /* NotationEnd ::= XTagEnd */
    _fillRule(g, 175 , 1, 207);
    /* PublicID ::= Public WhiteSpace PubidLiteral */
    _fillRule(g, 176 , 3, 166, 33, 20);
    /* ContentInterior ::= Comment CharDataMaybe */
    _fillRule(g, 178 , 2, 24, 91);
    /* intSubsetUnit ::= DeclSep */
    _fillRule(g, 179 , 1, 65);
    /* SystemLiteral ::= SYSTEMLITERAL */
    _fillRule(g, 18 , 1, 19);
    /* extSubsetDeclUnit ::= DeclSep */
    _fillRule(g, 180 , 1, 65);
    /* STagInterior ::= WhiteSpace Attribute */
    _fillRule(g, 181 , 2, 33, 88);
    /* EmptyElemTagInterior ::= WhiteSpace Attribute */
    _fillRule(g, 182 , 2, 33, 88);
    /* Quantifier ::= Plus */
    _fillRule(g, 183 , 1, 186);
    /* QuestionMark ::= QUESTION_MARK */
    _fillRule(g, 184 , 1, 223);
    /* Star ::= STAR */
    _fillRule(g, 185 , 1, 224);
    /* Plus ::= PLUS */
    _fillRule(g, 186 , 1, 225);
    /* ChoiceInterior ::= SMaybe Pipe SMaybe cp */
    _fillRule(g, 187 , 4, 49, 188, 49, 106);
    /* Pipe ::= PIPE */
    _fillRule(g, 188 , 1, 229);
    /* SeqInterior ::= SMaybe Comma SMaybe cp */
    _fillRule(g, 189 , 4, 49, 190, 49, 106);
    /* Comma ::= COMMA */
    _fillRule(g, 190 , 1, 230);
    /* MixedInterior ::= SMaybe Pipe SMaybe Name */
    _fillRule(g, 191 , 4, 49, 188, 49, 7);
    /* NotationTypeInterior ::= SMaybe Pipe SMaybe Name */
    _fillRule(g, 192 , 4, 49, 188, 49, 7);
    /* EnumerationInterior ::= SMaybe Pipe SMaybe Nmtoken */
    _fillRule(g, 193 , 4, 49, 188, 49, 11);
    /* ignoreSectContentsInterior ::= SectBeg ignoreSectContents SectEnd Ignore */
    _fillRule(g, 194 , 4, 142, 147, 144, 148);
    /* prolog ::= XMLDeclMaybe MiscAny doctypedecl MiscAny */
    _fillRule(g, 2 , 4, 42, 4, 43, 4);
    /* PubidLiteral ::= PUBIDLITERAL */
    _fillRule(g, 20 , 1, 21);
    /* XTagEnd ::= XTAG_END */
    _fillRule(g, 207 , 1, 215);
    /* XTagBeg ::= XTAG_BEG */
    _fillRule(g, 213 , 1, 214);
    /* CharData ::= CHARDATA */
    _fillRule(g, 22 , 1, 23);
    /* Comment ::= CommentBeg CommentInterior CommentEnd */
    _fillRule(g, 24 , 3, 25, 26, 27);
    /* CommentBeg ::= COMMENT_BEG */
    _fillRule(g, 25 , 1, 196);
    /* CommentInterior ::= COMMENT */
    _fillRule(g, 26 , 1, 198);
    /* CommentEnd ::= COMMENT_END */
    _fillRule(g, 27 , 1, 197);
    /* PITarget ::= PITARGET */
    _fillRule(g, 28 , 1, 29);
    /* element ::= STag content ETag */
    _fillRule(g, 3 , 3, 82, 83, 84);
    /* PI ::= PiBeg PITarget WhiteSpace PiInterior PiEnd */
    _fillRule(g, 30 , 5, 31, 28, 33, 34, 32);
    /* PiBeg ::= PI_BEG */
    _fillRule(g, 31 , 1, 255);
    /* PiEnd ::= PI_END */
    _fillRule(g, 32 , 1, 256);
    /* WhiteSpace ::= S */
    _fillRule(g, 33 , 1, 195);
    /* PiInterior ::= PI_INTERIOR */
    _fillRule(g, 34 , 1, 199);
    /* CDSect ::= CDStart CData CDEnd */
    _fillRule(g, 35 , 3, 36, 37, 38);
    /* CDStart ::= CDSTART */
    _fillRule(g, 36 , 1, 39);
    /* CData ::= CDATA */
    _fillRule(g, 37 , 1, 40);
    /* CDEnd ::= CDEND */
    _fillRule(g, 38 , 1, 41);
    /* MiscAny ::= Misc * */
    _fillRule(g, 4 , 1, 58);
    /* XMLDeclMaybe ::= */
    _fillRule(g, 42 , 0);
    /* doctypedecl ::= DoctypeBeg WhiteSpace Name WhiteSpace ExternalID SMaybe Lbracket intSubset Rbracket SMaybe DoctypeEnd */
    _fillRule(g, 43 , 11, 59, 33, 7, 33, 64, 49, 61, 62, 63, 49, 60);
    /* XMLDecl ::= XmlBeg VersionInfo EncodingDeclMaybe SDDeclMaybe SMaybe XmlEnd */
    _fillRule(g, 44 , 6, 45, 46, 47, 48, 49, 50);
    /* XmlBeg ::= XML_BEG */
    _fillRule(g, 45 , 1, 200);
    /* VersionInfo ::= WhiteSpace Version Eq Dquote VersionNum Dquote */
    _fillRule(g, 46 , 6, 33, 51, 52, 55, 54, 55);
    /* EncodingDeclMaybe ::= */
    _fillRule(g, 47 , 0);
    /* SDDeclMaybe ::= */
    _fillRule(g, 48 , 0);
    /* SMaybe ::= */
    _fillRule(g, 49 , 0);
    /* Char ::= CHAR */
    _fillRule(g, 5 , 1, 6);
    /* XmlEnd ::= XML_END */
    _fillRule(g, 50 , 1, 201);
    /* Version ::= VERSION */
    _fillRule(g, 51 , 1, 202);
    /* Eq ::= SMaybe Equal SMaybe */
    _fillRule(g, 52 , 3, 49, 56, 49);
    /* Squote ::= SQUOTE */
    _fillRule(g, 53 , 1, 203);
    /* VersionNum ::= VERSIONNUM */
    _fillRule(g, 54 , 1, 57);
    /* Dquote ::= DQUOTE */
    _fillRule(g, 55 , 1, 204);
    /* Equal ::= EQUAL */
    _fillRule(g, 56 , 1, 205);
    /* Misc ::= WhiteSpace */
    _fillRule(g, 58 , 1, 33);
    /* DoctypeBeg ::= DOCTYPE_BEG */
    _fillRule(g, 59 , 1, 206);
    /* DoctypeEnd ::= XTagEnd */
    _fillRule(g, 60 , 1, 207);
    /* Lbracket ::= LBRACKET */
    _fillRule(g, 61 , 1, 208);
    /* intSubset ::= intSubsetUnitAny */
    _fillRule(g, 62 , 1, 67);
    /* Rbracket ::= RBRACKET */
    _fillRule(g, 63 , 1, 209);
    /* ExternalID ::= Public WhiteSpace PubidLiteral WhiteSpace SystemLiteral */
    _fillRule(g, 64 , 5, 166, 33, 20, 33, 18);
    /* DeclSep ::= WhiteSpace */
    _fillRule(g, 65 , 1, 33);
    /* PEReference ::= PEREFERENCE */
    _fillRule(g, 66 , 1, 156);
    /* intSubsetUnitAny ::= intSubsetUnit * */
    _fillRule(g, 67 , 1, 179);
    /* markupdecl ::= Comment */
    _fillRule(g, 68 , 1, 24);
    /* elementdecl ::= ElementDeclBeg WhiteSpace Name WhiteSpace contentspec SMaybe ElementDeclEnd */
    _fillRule(g, 69 , 7, 96, 33, 7, 33, 97, 49, 98);
    /* Name ::= NAME */
    _fillRule(g, 7 , 1, 8);
    /* AttlistDecl ::= AttlistBeg WhiteSpace Name AttDefAny SMaybe AttlistEnd */
    _fillRule(g, 70 , 6, 114, 33, 7, 115, 49, 116);
    /* EntityDecl ::= PEDecl */
    _fillRule(g, 71 , 1, 158);
    /* NotationDecl ::= NotationBeg WhiteSpace Name WhiteSpace PublicID SMaybe NotationEnd */
    _fillRule(g, 72 , 7, 174, 33, 7, 33, 176, 49, 175);
    /* extSubset ::= TextDecl extSubsetDecl */
    _fillRule(g, 73 , 2, 75, 74);
    /* extSubsetDecl ::= extSubsetDeclUnitAny */
    _fillRule(g, 74 , 1, 76);
    /* TextDecl ::= XmlBeg VersionInfoMaybe EncodingDecl SMaybe XmlEnd */
    _fillRule(g, 75 , 5, 45, 168, 169, 49, 50);
    /* extSubsetDeclUnitAny ::= extSubsetDeclUnit * */
    _fillRule(g, 76 , 1, 180);
    /* SDDecl ::= WhiteSpace Standalone Eq Dquote No Dquote */
    _fillRule(g, 77 , 6, 33, 78, 52, 55, 80, 55);
    /* Standalone ::= STANDALONE */
    _fillRule(g, 78 , 1, 210);
    /* Yes ::= YES */
    _fillRule(g, 79 , 1, 211);
    /* No ::= NO */
    _fillRule(g, 80 , 1, 212);
    /* EmptyElemTag ::= EmptyElemTagBeg Name EmptyElemTagInteriorAny SMaybe EmptyElemTagEnd */
    _fillRule(g, 81 , 5, 93, 7, 94, 49, 95);
    /* STag ::= STagBeg Name STagInteriorAny SMaybe STagEnd */
    _fillRule(g, 82 , 5, 85, 7, 86, 49, 87);
    /* content ::= CharDataMaybe ContentInteriorAny */
    _fillRule(g, 83 , 2, 91, 92);
    /* ETag ::= ETagBeg Name SMaybe ETagEnd */
    _fillRule(g, 84 , 4, 89, 7, 49, 90);
    /* STagBeg ::= XTagBeg */
    _fillRule(g, 85 , 1, 213);
    /* STagInteriorAny ::= STagInterior * */
    _fillRule(g, 86 , 1, 181);
    /* STagEnd ::= STAG_END */
    _fillRule(g, 87 , 1, 216);
    /* Attribute ::= Name Eq AttValue */
    _fillRule(g, 88 , 3, 7, 52, 16);
    /* ETagBeg ::= ETAG_BEG */
    _fillRule(g, 89 , 1, 217);
    /* Names ::= x20 Names */
    _fillRule(g, 9 , 2, 10, 9);
    /* ETagEnd ::= ETAG_END */
    _fillRule(g, 90 , 1, 218);
    /* CharDataMaybe ::= */
    _fillRule(g, 91 , 0);
    /* ContentInteriorAny ::= ContentInterior * */
    _fillRule(g, 92 , 1, 178);
    /* EmptyElemTagBeg ::= XTagBeg */
    _fillRule(g, 93 , 1, 213);
    /* EmptyElemTagInteriorAny ::= EmptyElemTagInterior * */
    _fillRule(g, 94 , 1, 182);
    /* EmptyElemTagEnd ::= EMPTYELEMTAG_END */
    _fillRule(g, 95 , 1, 219);
    /* ElementDeclBeg ::= ELEMENTDECL_BEG */
    _fillRule(g, 96 , 1, 220);
    /* contentspec ::= children */
    _fillRule(g, 97 , 1, 102);
    /* ElementDeclEnd ::= XTagEnd */
    _fillRule(g, 98 , 1, 207);
    /* Empty ::= EMPTY */
    _fillRule(g, 99 , 1, 221);
}


#endif /* XML10_C */
