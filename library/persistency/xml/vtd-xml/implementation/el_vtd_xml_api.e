note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_VTD_XML_API

inherit
	EL_SHARED_C_WIDE_CHARACTER_STRING
		export
			{NONE} all
		end

feature {NONE} -- Access

	c_node_text_at_index (node_context: POINTER; index: INTEGER): POINTER
			--
		do
			Result := c_evx_node_text_at_index (Exception_callbacks_c_struct, node_context, index)
		end

	c_node_context_normalized_string (node_context: POINTER): POINTER
			--
		do
			Result := c_evx_node_context_normalized_string (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_string (node_context: POINTER): POINTER
			--
		do
			Result := c_evx_node_context_string (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_raw_string (node_context: POINTER): POINTER
			-- entities and char references not expanded
		do
			Result := c_evx_node_context_raw_string (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_integer (node_context: POINTER): INTEGER
			--
		do
			Result := c_evx_node_context_integer (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_integer_64 (node_context: POINTER): INTEGER_64
			--
		do
			Result := c_evx_node_context_integer_64 (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_real (node_context: POINTER): REAL
			--
		do
			Result := c_evx_node_context_real (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_double (node_context: POINTER): DOUBLE
			--
		do
			Result := c_evx_node_context_double (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_name (node_context: POINTER): POINTER
			--
		do
			Result := c_evx_node_context_name (Exception_callbacks_c_struct, node_context)
		end

	c_node_context_encoding (node_context: POINTER): INTEGER
			--	EIF_INTEGER evx_node_context_encoding (EIF_POINTER a_node_context);
		external
			"C (EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_encoding"
		end

	c_node_context_encoding_type (node_context: POINTER): POINTER
			--	EIF_POINTER evx_node_context_encoding_type (EIF_POINTER a_node_context);
		external
			"C (EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_encoding_type"
		end

	c_create_context_copy (node_context: POINTER): POINTER
			--
		do
			Result := c_evx_create_context_copy (Exception_callbacks_c_struct, node_context)
		end

feature {NONE} -- Basic operations

	c_create_xpath_query (xpath: POINTER): POINTER
			--
		do
			Result := c_evx_create_xpath_query (Exception_callbacks_c_struct, xpath)
		end

	c_create_xpath_query_for_namespace (xpath, ns_prefix, ns_url: POINTER): POINTER
			--
		do
			Result := c_evx_create_xpath_query_for_namespace (Exception_callbacks_c_struct, xpath, ns_prefix, ns_url)
		end

	c_evaluate_xpath_to_number (node_context, xpath_query: POINTER): DOUBLE
			--
		do
			Result := c_evx_evaluate_xpath_to_number (Exception_callbacks_c_struct, node_context, xpath_query)
		end

	c_evaluate_xpath_to_boolean (node_context, xpath_query: POINTER): BOOLEAN
			--
		do
			Result := c_evx_evaluate_xpath_to_boolean (Exception_callbacks_c_struct, node_context, xpath_query)
		end

	c_evaluate_xpath_to_string (node_context, xpath_query: POINTER): POINTER
			--
		do
			Result := c_evx_evaluate_xpath_to_string (Exception_callbacks_c_struct, node_context, xpath_query)
		end

	c_xpath_query_start (node_context, xpath_query: POINTER): INTEGER
			--
		do
			Result := c_evx_xpath_query_start (Exception_callbacks_c_struct, node_context, xpath_query)
		end

	c_xpath_query_forth (node_context, xpath_query: POINTER): INTEGER
			--
		do
			Result := c_evx_xpath_query_forth (Exception_callbacks_c_struct, node_context, xpath_query)
		end

	c_parse (parser_ptr: POINTER; is_namespace_aware: BOOLEAN)
			--
		do
			c_evx_parse (Exception_callbacks_c_struct, parser_ptr, is_namespace_aware)
		end

feature {NONE} -- Implementation

	Exception_callbacks_c_struct: POINTER
			--
		once
			Result := Exception_callbacks_struct.item
		end

	Exception_callbacks_struct: EL_C_TO_EIFFEL_CALLBACK_STRUCT [EL_VTD_EXCEPTIONS]
			--
		once
			create Result.make
		end

feature {NONE} -- Access VTDNav (Node context)

	c_evx_size_of_node_context_image (node_context: POINTER): INTEGER
			--
		external
			"C (EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_size_of_node_context_image"
		end

	c_evx_create_context_copy (exception_callbacks, other_node_context: POINTER): POINTER
			-- EIF_POINTER evx_create_context_copy (Exception_handlers_t *p_handlers, EIF_POINTER a_other_node_context);
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_create_context_copy"
		end

	c_evx_node_context_name (exception_callbacks, node_context: POINTER): POINTER
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_name"
		end

	c_evx_node_text_at_index (exception_callbacks, node_context: POINTER; index: INTEGER): POINTER
			-- EIF_POINTER evx_node_text_at_index (Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, int index)
		external
			"C (Exception_handlers_t *, EIF_POINTER, int): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_text_at_index"
		end

	c_evx_node_context_normalized_string (exception_callbacks, node_context: POINTER): POINTER
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_NormalizedString"
		end

	c_evx_node_context_string (exception_callbacks, node_context: POINTER): POINTER
			-- entities and char references not expanded
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_String"
		end

	c_evx_node_context_raw_string (exception_callbacks, node_context: POINTER): POINTER
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_RawString"
		end

	c_evx_node_context_integer (exception_callbacks, node_context: POINTER): INTEGER
			--	EIF_INTEGER evx_node_context_Int (
			--		Exception_handlers_t *p_handlers, EIF_POINTER node_context
			--	)
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_Int"
		end

	c_evx_node_context_integer_64 (exception_callbacks, node_context: POINTER): INTEGER_64
			--	EIF_INTEGER evx_node_context_Long (
			--		Exception_handlers_t *p_handlers, EIF_POINTER node_context
			--	)
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_Long"
		end

	c_evx_node_context_real (exception_callbacks, node_context: POINTER): REAL
			--	EIF_REAL evx_node_context_Float (
			--		Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
			--	)
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_REAL | <vtd2eiffel.h>"
		alias
			"evx_node_context_Float"
		end

	c_evx_node_context_double (exception_callbacks, node_context: POINTER): DOUBLE
			--	EIF_DOUBLE evx_node_context_Double (
			--		Exception_handlers_t *p_handlers, EIF_POINTER a_node_context
			--	)
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_DOUBLE | <vtd2eiffel.h>"
		alias
			"evx_node_context_Double"
		end

	c_evx_get_token_type (node_context: POINTER; index: INTEGER): INTEGER
			-- int evx_get_token_type (EIF_POINTER a_node_context, int index);
		external
			"C (EIF_POINTER, int): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_get_token_type"
		end

	c_evx_get_token_depth (node_context: POINTER; index: INTEGER): INTEGER
			-- int evx_get_token_depth (EIF_POINTER a_node_context, int index);
		external
			"C (EIF_POINTER, int): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_get_token_depth"
		end

	c_evx_get_token_count (node_context: POINTER): INTEGER
			-- int evx_get_token_count (EIF_POINTER a_node_context);
		external
			"C (EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_get_token_count"
		end

feature {NONE} -- Element change VTDNav (Node context)

	c_evx_read_node_context (node_context, context_image_dest: POINTER)
			-- Read into context_image_dest
		external
			"C (EIF_POINTER, int *) | <vtd2eiffel.h>"
		alias
			"evx_read_node_context"
		end

	c_evx_set_node_context (node_context, context_image: POINTER)
			--
		external
			"C (EIF_POINTER, int *) | <vtd2eiffel.h>"
		alias
			"evx_set_node_context"
		end

	c_evx_free_node_context (node_context: POINTER)
			-- void evx_free_node_context (EIF_POINTER a_node_context);
		external
			"C (EIF_POINTER) | <vtd2eiffel.h>"
		alias
			"evx_free_node_context"
		end

feature {NONE} -- C Externals: AutoPilot (XPath query)

	c_evx_create_xpath_query (exception_callbacks, xpath: POINTER): POINTER
			-- EIF_POINTER evx_create_xpath_query (Exception_handlers_t *p_handlers, EIF_POINTER a_xpath)
		external
			"C (Exception_handlers_t *, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_create_xpath_query"
		end

	c_evx_create_xpath_query_for_namespace (exception_callbacks, xpath, ns_prefix, ns_url: POINTER): POINTER
			-- EIF_POINTER evx_create_xpath_query_for_namespace (
			-- 		Exception_handlers_t *p_handlers, EIF_POINTER a_xpath, EIF_POINTER a_ns_prefix, EIF_POINTER a_ns_url
			-- )
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_create_xpath_query_for_namespace"
		end

	c_evx_evaluate_xpath_to_number (exception_callbacks, node_context, xpath_query: POINTER): DOUBLE
			--	EIF_DOUBLE evx_evaluate_xpath_to_number (
			--		Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
			--	);
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_DOUBLE | <vtd2eiffel.h>"
		alias
			"evx_evaluate_xpath_to_Number"
		end

	c_evx_evaluate_xpath_to_boolean (exception_callbacks, node_context, xpath_query: POINTER): BOOLEAN
			--	EIF_BOOLEAN evx_evaluate_xpath_to_boolean (
			--		Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
			--	);
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_BOOLEAN | <vtd2eiffel.h>"
		alias
			"evx_evaluate_xpath_to_Boolean"
		end

	c_evx_evaluate_xpath_to_string (exception_callbacks, node_context, xpath_query: POINTER): POINTER
			--	EIF_POINTER evx_evaluate_xpath_to_string (
			--		Exception_handlers_t *p_handlers, EIF_POINTER a_node_context, EIF_POINTER  a_xpath_query
			--	);
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_evaluate_xpath_to_String"
		end

	c_evx_xpath_query_start (exception_callbacks, node_context, xpath_query: POINTER): INTEGER
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_xpath_query_start"
		end

	c_evx_xpath_query_forth (exception_callbacks, node_context, xpath_query: POINTER): INTEGER
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_xpath_query_forth"
		end

	c_evx_reset_xpath_query (xpath_query: POINTER)
			-- void evx_reset_xpath_query (EIF_POINTER a_xpath_query)
		external
			"C (EIF_POINTER) | <vtd2eiffel.h>"
		alias
			"evx_reset_xpath_query"
		end

	c_evx_free_xpath_query (xpath_query: POINTER)
			-- void evx_free_xpath_query (EIF_POINTER a_xpath_query)
		external
			"C (EIF_POINTER) | <vtd2eiffel.h>"
		alias
			"evx_free_xpath_query"
		end

feature {NONE} -- C Externals: VTDGen (Parser)

	c_evx_parse (exception_callbacks, parser: POINTER; is_namespace_aware: BOOLEAN)
			-- void evx_parse (Exception_handlers_t *p_handlers, EIF_POINTER parser, UByte *xml, int xml_size)

		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_BOOLEAN) | <vtd2eiffel.h>"
		alias
			"evx_parse"
		end

	c_evx_set_document (parser, document: POINTER; length: INTEGER)
			-- void evx_set_document (EIF_POINTER a_parser, EIF_POINTER a_string, int string_count)
		external
			"C (EIF_POINTER, EIF_POINTER, int) | <vtd2eiffel.h>"
		alias
			"evx_set_document"
		end

	c_evx_root_node_context (parser: POINTER): POINTER
			-- EIF_POINTER evx_root_node_context (EIF_POINTER a_parser);
		external
			"C (EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_root_node_context"
		end

	c_evx_create_parser: POINTER
			-- EIF_POINTER evx_create_parser ();
		external
			"C (): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_create_parser"
		end

	c_evx_free_parser (self: POINTER)
			-- void evx_free_parser (EIF_POINTER a_parser);
		external
			"C (EIF_POINTER) | <vtd2eiffel.h>"
		alias
			"evx_free_parser"
		end

end -- class VTD_XML_API
