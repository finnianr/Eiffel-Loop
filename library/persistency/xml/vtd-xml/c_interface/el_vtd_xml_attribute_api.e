note
	description: "Vtd xml attribute api"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_VTD_XML_ATTRIBUTE_API

inherit
	EL_C_API

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