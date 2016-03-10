note
	description: "Expat API and associated classes modified to only have ISE base dependency"

	library: "Gobo Eiffel XML Library"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "4"

class EL_EXPAT_API

inherit
	ANY

	PLATFORM
		export {NONE} all end

	EL_MEMORY
		export
			{NONE} all
			{ANY} is_attached
		end

feature {NONE} -- Creating and destroying parsers

	exml_XML_ParserCreate (encoding: POINTER): POINTER
			-- Create a new parser; encoding is the encoding
			-- specified by the external protocol or null if there
			-- is none specified.
		external
			"C (XML_Char *): EIF_POINTER | <expat.h>"
		alias
			"XML_ParserCreate"
		end

	exml_XML_ParserCreateNS (encoding: POINTER; namespace_separator: CHARACTER): POINTER
			-- Create a new parser and namespace processor. Element
			-- type names and attribute names that belong to a namespace
			-- will be expanded; unprefixed attribute names are never
			-- expanded; unprefixed element type names are expanded only
			-- if there is a default namespace. The expanded name is the
			-- concatenation of the namespace URI, the namespace
			-- separator character, and the local part of the name. If
			-- the namespace separator is '\0' then the namespace URI and
			-- the local part will be concatenated without any separator.
			-- When a namespace is not declared, the name and prefix will
			-- be passed through without expansion.
		external
			"C (XML_Char *, XML_Char): EIF_POINTER | <expat.h>"
		alias
			"XML_ParserCreateNS"
		end

	exml_XML_ParserCreate_MM (encoding, memsuite: POINTER; namespace_separator: POINTER): POINTER
			-- Create a new parser using the memory management suit
			-- referred to by `memsuite'. If `memsuite' is NULL, then use the
			-- standard library memory suite. If `namespace_separator' is
			-- non-NULL it creates a parser with namespace processing as
			-- described above. The character pointed at will serve as
			-- the namespace separator.
			-- All further memory operations used for the created parser
			-- will come from the given suite.
		external
			"C (XML_Char *, XML_Memory_Handling_Suite *, XML_Char *): EIF_POINTER | <expat.h>"
		alias
			"XML_ParserCreate_MM"
		end

	exml_XML_ExternalEntityParserCreate (parser_handle: POINTER; context: POINTER; encoding: POINTER): POINTER
			-- Create an XM_Parser object that can parse an external general
			-- entity;
			-- `context' is a '\0'-terminated string specifying the parse context;
			-- `encoding' is a '\0'-terminated string giving the name of
			-- the externally specified encoding, or null if there is no
			-- externally specified encoding.
			-- The context string consists of a sequence of tokens
			-- separated by formfeeds (\f); a token consisting of a name
			-- specifies that the general entity of the name is open; a
			-- token of the form prefix=uri specifies the namespace for a
			-- particular prefix; a token of the form =uri specifies the
			-- default namespace.
			-- This can be called at any point after the first call to an
			-- ExternalEntityRefHandler so longer as the parser has not
			-- yet been freed.
			-- The new parser is completely independent and may safely be
			-- used in a separate thread.
			-- The handlers and userData are initialized from the parser
			-- argument.
			-- Returns 0 if out of memory.  Otherwise returns a new XM_Parser
			-- object.
		external
			"C (XML_Parser, XML_Char *, XML_Char *): EIF_POINTER | <expat.h>"
		alias
			"XML_ExternalEntityParserCreate"
		end

	exml_XML_ParserFree (parser_handle: POINTER)
			-- Free memory used by the parser.
			-- If an Eiffel callback has been specified, make sure you
			-- have called `exml_XM_SetUserData' with a Void argument,
			-- else your callback is never available for the gc again.
		external
			"C (XML_Parser) | <expat.h>"
		alias
			"XML_ParserFree"
		end

feature {NONE} -- Parsing

	exml_XML_GetBuffer (a_parser: POINTER; len: INTEGER): POINTER
			-- Obtain a buffer of size len to read a piece of the
			-- document into. `default_pointer' value is returned if
			-- expat can't allocate enough memory for this buffer. This
			-- has to be called prior to every call to XML_ParseBuffer.
		require
			a_parser_attached: is_attached (a_parser)
			len_not_negative: len >= 0
		external
			"C (XML_Parser, int): EIF_POINTER | <expat.h>"
		alias
			"XML_GetBuffer"
		ensure
			we_dont_handle_nil_yet: is_attached (Result)
		end

	exml_XML_Parse_string (a_parser: POINTER; str: STRING; is_final: BOOLEAN): INTEGER
			-- Parse some input. Return 0 if a fatal error is
			-- detected. The last call to XML_Parse must have `is_final'
			-- true; `str' may be empty.
			-- You should not change the contents of `str' while Expat
			-- might still need it. So be extremely careful with
			-- last_string type of loops.
		require
			a_parser_attached: is_attached (a_parser)
		local
			int: INTEGER

			c_str: ANY

		do
			if is_final then
				int := 1
			end

			c_str := str.to_c
			Result := exml_XML_Parse (a_parser, $c_str, str.count, int)
		end

	exml_XML_Parse (a_parser: POINTER; s: POINTER; len: INTEGER; is_final: INTEGER): INTEGER
			-- Parse some input. Return 0 if a fatal error is
			-- detected. The last call to XML_Parse must have `is_final'
			-- true; `len' may be zero for this call (or any other).
		require
			a_parser_attached: is_attached (a_parser)
			s_attached: is_attached (s)
			len_not_negative: len >= 0
		external
			"C (XML_Parser, char *, int, int): EIF_INTEGER | <expat.h>"
		alias
			"XML_Parse"
		end

	exml_XML_ParseBuffer (a_parser: POINTER; len: INTEGER; is_final: INTEGER): INTEGER
			-- This is just like XML_Parse, except in this case expat
			-- provides the buffer. By obtaining the buffer from expat
			-- with the XML_GetBuffer function, the application can avoid
			-- double copying of the input.
			-- Return 0 if a fatal error is detected. The last call to
			-- XML_ParseBuffer must have `is_final' true; `len' may be zero for
			-- this call (or any other).
		require
			a_parser_attached: is_attached (a_parser)
			len_not_negative: len >= 0
		external
			"C (XML_Parser, int, int): EIF_INTEGER | <expat.h>"
		alias
			"XML_ParseBuffer"
		end

feature {NONE} -- Error reporting

	exml_XML_GetErrorCode (a_parser: POINTER): INTEGER
			-- If XML_Parse or XML_ParseBuffer have returned 0, then
			-- XML_GetErrorCode returns information about the error.
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser): EIF_INTEGER | <expat.h>"
		alias
			"XML_GetErrorCode"
		end

	exml_XML_ErrorString (code: INTEGER): POINTER
			-- Return a string describing the error.
		external
			"C (int): EIF_POINTER | <expat.h>"
		alias
			"XML_ErrorString"
		end

feature {NONE} -- Parse state

-- These functions return information about the current parse
-- location. They may be called when XM_Parse or XML_ParseBuffer
-- return 0; in this case the location is the location of the
-- character at which the error was detected.

-- They may also be called from any other callback called to
-- report some parse event; in this the location is the location of the
-- first of the sequence of characters that generated the event.

	exml_XML_GetCurrentLineNumber (a_parser: POINTER): INTEGER
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser): EIF_INTEGER | <expat.h>"
		alias
			"XML_GetCurrentLineNumber"
		end

	exml_XML_GetCurrentColumnNumber (a_parser: POINTER): INTEGER
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser): EIF_INTEGER | <expat.h>"
		alias
			"XML_GetCurrentColumnNumber"
		end

	exml_XML_GetCurrentByteIndex (a_parser: POINTER): INTEGER
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser): EIF_INTEGER | <expat.h>"
		alias
			"XML_GetCurrentByteIndex"
		end

feature {NONE} -- Miscellaneous

	exml_XML_ParserReset (a_parser, encoding: POINTER): BOOLEAN
			-- Supposed to reset parser but doesn't seem to work
			-- Better to create new one each time
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_Char *): EIF_BOOLEAN | <expat.h>"
		alias
			"XML_ParserReset"
		end

	exml_XML_SetUserData (a_parser, a_callback: POINTER)

			-- This value is passed as the userData argument to
			-- callbacks.
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, void *) | <expat.h>"
		alias
			"XML_SetUserData"
		end

	exml_XML_SetBase_string (a_parser: POINTER; a_base: STRING): BOOLEAN
			-- Set the base to be used for resolving relative URIs in
			-- system identifiers in declarations. Resolving relative
			-- identifiers is left to the application: this value will be
			-- passed through as the base argument to the
			-- XML_ExternalEntityRefHandler, XML_NotationDeclHandler and
			-- XML_UnparsedEntityDeclHandler. The base argument will be
			-- copied.
			-- Returns zero if out of memory, non-zero otherwise.
		require
			a_parser_attached: is_attached (a_parser)
			a_base_not_void: a_base /= Void

		local
			c_str: ANY

		do
			c_str := a_base.to_c
			Result := exml_XML_SetBase (a_parser, $c_str)
		end

	exml_XML_SetBase (a_parser: POINTER; a_base: POINTER): BOOLEAN
			-- Set the base to be used for resolving relative URIs in
			-- system identifiers in declarations. Resolving relative
			-- identifiers is left to the application: this value will be
			-- passed through as the base argument to the
			-- XML_ExternalEntityRefHandler, XML_NotationDeclHandler and
			-- XML_UnparsedEntityDeclHandler. The base argument will be
			-- copied.
			-- Returns zero if out of memory, non-zero otherwise.
		require
			a_parser_attached: is_attached (a_parser)
			a_base_attached: is_attached (a_base)
		external
			"C | <expat.h>"
		alias
			"XML_SetBase"
		end

	exml_XML_GetBase (a_parser: POINTER): POINTER
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser): EIF_POINTER | <expat.h>"
		alias
			"XML_GetBase"
		end

	exml_XML_SetParamEntityParsing (a_parser: POINTER; parsing: INTEGER): BOOLEAN
			-- Control parsing of parameter entities (including the
			-- external DTD subset). If parsing of parameter entities is
			-- enabled, then references to external parameter entities
			-- (including the external DTD subset) will be passed to the
			-- handler set with `XML_SetExternalEntityRefHandler'. The
			-- context passed will be 0. Unlike external general
			-- entities, external parameter entities can only be parsed
			-- synchronously. If the external parameter entity is to be
			-- parsed, it must be parsed during the call to the external
			-- entity ref handler: the complete sequence of
			-- `XML_ExternalEntityParserCreate', `XML_Parse'/`XML_ParseBuffer'
			-- and `XML_ParserFree' calls must be made during this call.
			-- After `XML_ExternalEntityParserCreate' has been called to
			-- create the parser for the external parameter entity
			-- (context must be 0 for this call), it is illegal to make
			-- any calls on the old parser until `XML_ParserFree' has been
			-- called on the newly created parser. If the library has
			-- been compiled without support for parameter entity parsing
			-- (i.e. without XM_DTD being defined), then
			-- `XML_SetParamEntityParsing' will return 0 if parsing of
			-- parameter entities is requested; otherwise it will return
			-- non-zero.
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, enum XML_ParamEntityParsing): unsigned char | <expat.h>"
		alias
			"XML_SetParamEntityParsing"
		end

	exml_XML_ExpatVersion: POINTER
			-- Return a string containing the version number of this expat
		external
			"C (): EIF_POINTER | <expat.h>"
		alias
			"XML_ExpatVersion"
		end

feature {NONE} -- Encoding structure

--		typedef struct {
--		  int map[256];
--		  void *data;
--		  int (*convert)(void *data, const char *s);
--		  void (*release)(void *data);
--		} XML_Encoding;

	exml_set_encoding_info_callback_object (encoding_info_struct_ptr, callback_object: POINTER)
		external
			"C [struct <expat.h>] (XML_Encoding, void*)"
		alias
			"data"
		end

	exml_set_encoding_info_convert_callback (encoding_info_struct_ptr, convert_function: POINTER)
		external
			"C [struct <expat.h>] (XML_Encoding, void*)"
		alias
			"convert"
		end

	exml_set_encoding_info_release_callback (encoding_info_struct_ptr, release_function: POINTER)
		external
			"C [struct <expat.h>] (XML_Encoding, void*)"
		alias
			"release"
		end

	exml_XML_encoding_size: INTEGER
		external
			"C [macro <expat.h>]: EIF_INTEGER"
		alias
			"sizeof(XML_Encoding)"
		end

feature {NONE} -- Handlers

	exml_XML_SetElementDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_ElementDeclHandler) | <expat.h>"
		alias
			"XML_SetElementDeclHandler"
		end

	exml_XML_SetAttlistDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_AttlistDeclHandler) | <expat.h>"
		alias
			"XML_SetAttlistDeclHandler"
		end

	exml_XML_SetXmlDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_XmlDeclHandler) | <expat.h>"
		alias
			"XML_SetXmlDeclHandler"
		end

	exml_XML_SetEntityDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_EntityDeclHandler) | <expat.h>"
		alias
			"XML_SetEntityDeclHandler"
		end

	exml_XML_SetElementHandler (a_parser, a_start, a_end: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartElementHandler, XML_EndElementHandler) | <expat.h>"
		alias
			"XML_SetElementHandler"
		end

	exml_XML_SetStartElementHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartElementHandler) | <expat.h>"
		alias
			"XML_SetStartElementHandler"
		end

	exml_XML_SetEndElementHandler (a_parser, a_hanlder: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_EndElementHandler) | <expat.h>"
		alias
			"XML_SetEndElementHandler"
		end

	exml_XML_SetCharacterDataHandler (a_parser, a_hanlder: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_CharacterDataHandler) | <expat.h>"
		alias
			"XML_SetCharacterDataHandler"
		end

	exml_XML_SetProcessingInstructionHandler (a_parser, a_hanlder: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_ProcessingInstructionHandler) | <expat.h>"
		alias
			"XML_SetProcessingInstructionHandler"
		end

	exml_XML_SetCommentHandler (a_parser, a_hanlder: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_CommentHandler) | <expat.h>"
		alias
			"XML_SetCommentHandler"
		end

	exml_XML_SetCdataSectionHandler (a_parser, a_start, a_end: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartCdataSectionHandler, XML_EndCdataSectionHandler) | <expat.h>"
		alias
			"XML_SetCdataSectionHandler"
		end

	exml_XML_SetStartCdataSectionHandler (a_parser, a_hanlder: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartCdataSectionHandler) | <expat.h>"
		alias
			"XML_SetStartCdataSectionHandler"
		end

	exml_XML_SetEndCdataSectionHandler (a_parser, a_hanlder: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_EndCdataSectionHandler) | <expat.h>"
		alias
			"XML_SetEndCdataSectionHandler"
		end

	exml_XML_SetDefaultHandler (a_parser, a_hanlder: POINTER)
			-- Set default handler and also inhibits expansion
			-- of internal entities.
			-- The entity reference will be passed to the default handler.
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_DefaultHandler) | <expat.h>"
		alias
			"XML_SetDefaultHandler"
		end

	exml_XML_SetDefaultHandlerExpand (a_parser, a_hanlder: POINTER)
			-- Set default handler but does not inhibit
			-- expansion of internal entities.
			-- The entity reference will not be passed to the default handler.
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_DefaultHandler) | <expat.h>"
		alias
			"XML_SetDefaultHandlerExpand"
		end

	exml_XML_SetDoctypeDeclHandler (a_parser, a_start, a_end: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartDoctypeDeclHandler, XML_EndDoctypeDeclHandler) | <expat.h>"
		alias
			"XML_SetDoctypeDeclHandler"
		end

	exml_XML_SetStartDoctypeDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartDoctypeDeclHandler) | <expat.h>"
		alias
			"XML_SetStartDoctypeDeclHandler"
		end

	exml_XML_SetEndDoctypeDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_EndDoctypeDeclHandler) | <expat.h>"
		alias
			"XML_SetEndDoctypeDeclHandler"
		end

	exml_XML_SetNotationDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_NotationDeclHandler) | <expat.h>"
		alias
			"XML_SetNotationDeclHandler"
		end

	exml_XML_SetNamespaceDeclHandler (a_parser, a_start, a_end: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartNamespaceDeclHandler, XML_EndNamespaceDeclHandler) | <expat.h>"
		alias
			"XML_SetNamespaceDeclHandler"
		end

	exml_XML_SetStartNamespaceDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_StartNamespaceDeclHandler) | <expat.h>"
		alias
			"XML_SetStartNamespaceDeclHandler"
		end

	exml_XML_SetEndNamespaceDeclHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_EndNamespaceDeclHandler) | <expat.h>"
		alias
			"XML_SetEndNamespaceDeclHandler"
		end

	exml_XML_SetNotStandaloneHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_NotStandaloneHandler) | <expat.h>"
		alias
			"XML_SetNotStandaloneHandler"
		end

	exml_XML_SetExternalEntityRefHandler (a_parser, a_handler: POINTER)
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser,  XML_ExternalEntityRefHandler) | <expat.h>"
		alias
			"XML_SetExternalEntityRefHandler"
		end

	exml_XML_SetExternalEntityRefHandlerArg (a_parser: POINTER; a_arg: POINTER)

		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, void *) | <expat.h>"
		alias
			"XML_SetExternalEntityRefHandlerArg"
		end

	exml_XML_SetUnknownEncodingHandler (a_parser, a_handler, object: POINTER)
			--
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C (XML_Parser, XML_UnknownEncodingHandler, void *) | <expat.h>"
		alias
			"XML_SetUnknownEncodingHandler"
		end

feature {NONE} -- XML_ParamEntityParsing enum

	XML_PARAM_ENTITY_PARSING_NEVER: INTEGER
		external
			"C [macro <expat.h>]"
		alias
			"XML_PARAM_ENTITY_PARSING_NEVER"
		end

	XML_PARAM_ENTITY_PARSING_UNLESS_STANDALONE: INTEGER
			--
		external
			"C [macro <expat.h>]"
		alias
			"XML_PARAM_ENTITY_PARSING_UNLESS_STANDALONE"
		end

	XML_PARAM_ENTITY_PARSING_ALWAYS: INTEGER
			--
		external
			"C [macro <expat.h>]"
		alias
			"XML_PARAM_ENTITY_PARSING_ALWAYS"
		end

feature {NONE} -- XML_Content_Type enum

	XML_CTYPE_EMPTY: INTEGER
		external
			"C [macro <expat.h>]"
		alias
			"XML_CTYPE_EMPTY"
		end

	XML_CTYPE_ANY: INTEGER
		external
			"C [macro <expat.h>]"

		alias
			"XML_CTYPE_ANY"
		end

	XML_CTYPE_MIXED: INTEGER
		external
			"C [macro <expat.h>]"
		alias
			"XML_CTYPE_MIXED"
		end

	XML_CTYPE_NAME: INTEGER
		external

			"C [macro <expat.h>]"

		alias
			"XML_CTYPE_NAME"
		end

	XML_CTYPE_CHOICE: INTEGER
		external
			"C [macro <expat.h>]"
		alias
			"XML_CTYPE_CHOICE"
		end

	XML_CTYPE_SEQ: INTEGER
		external
			"C [macro <expat.h>]"
		alias
			"XML_CTYPE_SEQ"
		end

feature {NONE} -- XML_Content_Quant enum

	XML_CQUANT_NONE: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_CQUANT_NONE"
		end

	XML_CQUANT_OPT: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_CQUANT_OPT"
		end

	XML_CQUANT_REP: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_CQUANT_REP"
		end

	XML_CQUANT_PLUS: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_CQUANT_PLUS"
		end

feature -- XML_Error enum

	XML_ERROR_NONE: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_NONE"
		end

	XML_ERROR_NO_MEMORY: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_NO_MEMORY"
		end

	XML_ERROR_SYNTAX: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_SYNTAX"
		end

	XML_ERROR_NO_ELEMENTS: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_NO_ELEMENTS"
		end

	XML_ERROR_INVALID_TOKEN: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_INVALID_TOKEN"
		end

	XML_ERROR_UNCLOSED_TOKEN: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_UNCLOSED_TOKEN"
		end

	XML_ERROR_PARTIAL_CHAR: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_PARTIAL_CHAR"
		end

	XML_ERROR_TAG_MISMATCH: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_TAG_MISMATCH"
		end

	XML_ERROR_DUPLICATE_ATTRIBUTE: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_DUPLICATE_ATTRIBUTE"
		end

	XML_ERROR_JUNK_AFTER_DOC_ELEMENT: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_JUNK_AFTER_DOC_ELEMENT"
		end

	XML_ERROR_PARAM_ENTITY_REF: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_PARAM_ENTITY_REF"
		end

	XML_ERROR_UNDEFINED_ENTITY: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_UNDEFINED_ENTITY"
		end

	XML_ERROR_RECURSIVE_ENTITY_REF: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_RECURSIVE_ENTITY_REF"
		end

	XML_ERROR_ASYNC_ENTITY: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_ASYNC_ENTITY"
		end

	XML_ERROR_BAD_CHAR_REF: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_BAD_CHAR_REF"
		end

	XML_ERROR_BINARY_ENTITY_REF: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_BINARY_ENTITY_REF"
		end

	XML_ERROR_ATTRIBUTE_EXTERNAL_ENTITY_REF: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_ATTRIBUTE_EXTERNAL_ENTITY_REF"
		end

	XML_ERROR_MISPLACED_XML_PI: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_MISPLACED_XML_PI"
		end

	XML_ERROR_UNKNOWN_ENCODING: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_UNKNOWN_ENCODING"
		end

	XML_ERROR_INCORRECT_ENCODING: INTEGER
		external

			"C macro use <expat.h>"
		alias
			"XML_ERROR_INCORRECT_ENCODING"
		end

	XML_ERROR_UNCLOSED_CDATA_SECTION: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_UNCLOSED_CDATA_SECTION"
		end

	XML_ERROR_EXTERNAL_ENTITY_HANDLING: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_EXTERNAL_ENTITY_HANDLING"
		end

	XML_ERROR_NOT_STANDALONE: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_NOT_STANDALONE"
		end

	XML_ERROR_UNEXPECTED_STATE: INTEGER
		external
			"C macro use <expat.h>"
		alias
			"XML_ERROR_UNEXPECTED_STATE"
		end

feature -- XML_cp members

	exml_XML_cp_size: INTEGER
		external
			"C [macro <expat.h>]: EIF_INTEGER"
		alias
			"sizeof(XML_Content)"
		end

	exml_XML_cp_type (cp: POINTER): INTEGER
		require
			have_struct_pointer: is_attached (cp)
		external
		"C [struct <expat.h>] (struct XML_cp): EIF_INTEGER"
		alias
			"type"
		end

	exml_XML_cp_quant (cp: POINTER): INTEGER
			--
		require
			have_struct_pointer: is_attached (cp)
		external
			"C [struct <expat.h>] (struct XML_cp): EIF_INTEGER"
		alias
			"quant"
		end

	exml_XML_cp_name (cp: POINTER): POINTER
			--
		require
			have_struct_pointer: is_attached (cp)
		external
			"C [struct <expat.h>] (struct XML_cp): EIF_POINTER"
		alias
			"name"
		end

	exml_XML_cp_numchildren (cp: POINTER): INTEGER
		require
			have_struct_pointer: is_attached (cp)		external
			"C [struct <expat.h>] (struct XML_cp): EIF_INTEGER"
		alias
			"numchildren"
		end

	exml_XML_cp_children_0 (cp: POINTER): POINTER
		external
			"C [struct <expat.h>] (struct XML_cp): EIF_INTEGER"
		alias
			"children"
		end

	exml_XML_cp_children (cp: POINTER; index: INTEGER): POINTER
		require
			have_struct_pointer: is_attached (cp)
			valid_index: index >= 0 and index < exml_XML_cp_numchildren (cp)
		local
			children: POINTER
		do
			children := exml_XML_cp_children_0 (cp)

			Result := children + (index * exml_XML_cp_size)
		ensure
			valid_struct: is_attached (Result)
		end

feature -- XML_Content freeing

	exml_XML_cp_free (cp: POINTER)
			-- Free the Expat allocated XML_Content struct by assuming it
			-- has been allocated by malloc so free likes it.
		require
			cp_points_attached: is_attached (cp)
		external
			"C use <stdlib.h>"
		alias
			"free"
		end

feature {NONE} -- Implementation

	exml_XML_GetUserData (a_parser: POINTER): POINTER
			-- Last value set by XML_SetUserData or null.
		require
			a_parser_attached: is_attached (a_parser)
		external
			"C [macro <expat.h>]"
		alias
			"XML_GetUserData"
		end

end

