note
	description: "Implementation routines for ${EL_XPATH_NODE_CONTEXT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-07 16:13:56 GMT (Thursday 7th September 2023)"
	revision: "5"

deferred class
	EL_XPATH_NODE_CONTEXT_IMPLEMENTATION

inherit
	EL_OWNED_C_OBJECT -- VTDNav
		rename
			c_free as c_evx_free_node_context
		export
			{EL_XPATH_NODE_CONTEXT, EL_VTD_XPATH_QUERY, EL_VTD_XML_ATTRIBUTE_API} self_ptr
		end

	EL_VTD_XML_API
		export
			{NONE} all
			{EL_VTD_XML_ATTRIBUTE_API} exception_callbacks_c_struct
		end

	EL_STRING_8_CONSTANTS

	EL_VTD_CONSTANTS

	EL_MODULE_EXCEPTION; EL_MODULE_EIFFEL; EL_MODULE_FILE; EL_MODULE_HTML

	EL_MODULE_LIO; EL_MODULE_XML

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_IMMUTABLE_8_MANAGER

	EL_SHARED_CLASS_ID

feature -- Numeric values

	as_boolean: BOOLEAN
		require
			value_is_boolean: is_boolean_value
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr)).to_boolean
		end

	as_double, as_real_64: DOUBLE
			-- element content as a DOUBLE
		require
			value_is_double: value.is_double
		do
			Result := c_node_context_double (self_ptr)
		end

	as_integer, as_integer_32: INTEGER
			-- element content as an INTEGER
		require
			value_is_integer: value.is_integer
		do
			Result := c_node_context_integer (self_ptr)
		end

	as_integer_64: INTEGER_64
			-- element content as an INTEGER_64
		require
			value_is_integer_64: value.is_integer_64
		do
			Result := c_node_context_integer_64 (self_ptr)
		end

	as_natural: NATURAL
			-- element content as a NATURAL
		require
			value_is_natural: value.is_natural
		do
			Result := value.to_natural
		end

	as_natural_64: NATURAL_64
			-- element content as a NATURAL_64
		require
			value_is_natural_64: value.is_natural_64
		do
			Result := value.to_natural_64
		end

	as_real, as_real_32: REAL
			-- element content as a REAL
		require
			value_is_real: value.is_real
		do
			Result := c_node_context_real (self_ptr)
		end

feature -- String values

	as_full_string: ZSTRING
			-- The entity and character references will be resolved
			-- whitespace not trimmed
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	as_full_string_32: STRING_32
			-- The entity and character references will be resolved
			-- whitespace not trimmed
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end

	as_full_string_8: STRING
			-- The entity and character references will be resolved
			-- whitespace not trimmed
		do
			Result := wide_string (c_node_context_string (self_ptr))
		end


	as_raw_string: ZSTRING
			-- element content as string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	as_raw_string_32: STRING_32
			-- element content as wide string with entities and char references not expanded
			-- built-in entity and char references not resolved
			-- entities and char references not expanded
		do
			Result := wide_string (c_node_context_raw_string (self_ptr))
		end

	as_string: ZSTRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	as_string_32: STRING_32
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

	as_string_8, value: STRING
			-- The leading and trailing white space characters will be stripped.
			-- The entity and character references will be resolved
			-- Multiple whitespaces char will be collapsed into one
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr))
		end

feature -- Element values

	as_date: DATE
			-- element content as a DOUBLE
		require
			days_format: as_string.is_natural
		do
			create Result.make_by_days (as_integer)
		end

	as_dir_path: DIR_PATH
			--
		do
			Result := as_string
		end

	as_file_path: FILE_PATH
			--
		do
			Result := as_string
		end

feature -- Contract Support

	is_boolean_value: BOOLEAN
		do
			Result := Boolean_values.has (value.as_lower)
		end

end