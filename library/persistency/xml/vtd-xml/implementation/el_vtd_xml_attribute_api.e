note
	description: "Summary description for {EL_VTD_XML_ATTRIBUTE_API}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "6"

class
	EL_VTD_XML_ATTRIBUTE_API

inherit
	EL_VTD_SHARED_NATIVE_XPATH
		rename
			native_xpath as native_name
		end

	EL_SHARED_C_WIDE_CHARACTER_STRING

feature {NONE} -- Implementation

	c_node_context_attribute_string (name: STRING_32): POINTER
			--
		do
			Result := c_evx_node_context_attribute_string (
				exception_callbacks_c_struct, c_node_context, native_name (name).base_address
			)
		end

	c_node_context_attribute_raw_string (name: STRING_32): POINTER
			--
		do
			Result := c_evx_node_context_attribute_raw_string (
				exception_callbacks_c_struct, c_node_context, native_name (name).base_address
			)
		end

	c_node_context_attribute_integer (name: STRING_32): INTEGER
			--
		do
			Result := c_evx_node_context_attribute_integer (
				exception_callbacks_c_struct, c_node_context, native_name (name).base_address
			)
		end

	c_node_context_attribute_integer_64 (name: STRING_32): INTEGER_64
			--
		do
			Result := c_evx_node_context_attribute_integer_64 (
				exception_callbacks_c_struct, c_node_context, native_name (name).base_address
			)
		end

	c_node_context_attribute_real (name: STRING_32): REAL
			--
		do
			Result := c_evx_node_context_attribute_real (
				exception_callbacks_c_struct, c_node_context, native_name (name).base_address
			)
		end

	c_node_context_attribute_double (name: STRING_32): DOUBLE
			--
		do
			Result := c_evx_node_context_attribute_double (
				exception_callbacks_c_struct, c_node_context, native_name (name).base_address
			)
		end

	c_node_context: POINTER

	exception_callbacks_c_struct: POINTER

feature {NONE} -- C Externals

	c_evx_node_context_attribute_string (exception_callbacks, elem_context, attribute_name: POINTER): POINTER
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_attribute_string"
		end

	c_evx_node_context_attribute_raw_string (exception_callbacks, elem_context, attribute_name: POINTER): POINTER
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_POINTER | <vtd2eiffel.h>"
		alias
			"evx_node_context_attribute_raw_string"
		end

	c_evx_node_context_attribute_integer (exception_callbacks, elem_context, attribute_name: POINTER): INTEGER
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_attribute_Int"
		end

	c_evx_node_context_attribute_integer_64 (exception_callbacks, elem_context, attribute_name: POINTER): INTEGER_64
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_attribute_Long"
		end

	c_evx_node_context_attribute_real (exception_callbacks, elem_context, attribute_name: POINTER): REAL
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_attribute_Float"
		end

	c_evx_node_context_attribute_double (exception_callbacks, elem_context, attribute_name: POINTER): DOUBLE
			--
		external
			"C (Exception_handlers_t *, EIF_POINTER, EIF_POINTER): EIF_INTEGER | <vtd2eiffel.h>"
		alias
			"evx_node_context_attribute_Double"
		end

end
