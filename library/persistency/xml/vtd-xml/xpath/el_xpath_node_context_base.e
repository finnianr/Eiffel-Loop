note
	description: "Implementation routines for ${EL_XPATH_NODE_CONTEXT}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-22 12:13:14 GMT (Saturday 22nd March 2025)"
	revision: "8"

deferred class
	EL_XPATH_NODE_CONTEXT_BASE

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

	EL_READABLE
		rename
			read_character_8 as as_character_8,
			read_character_32 as as_character_32,
			read_integer_8 as as_integer_8,
			read_integer_16 as as_integer_16,
			read_integer_32 as as_integer,
			read_integer_64 as as_integer_64,
			read_natural_8 as as_natural_8,
			read_natural_16 as as_natural_16,
			read_natural_32 as as_natural,
			read_natural_64 as as_natural_64,
			read_real_32 as as_real,
			read_real_64 as as_double,
			read_string as as_string,
			read_string_8 as as_string_8,
			read_string_32 as as_string_32,
			read_boolean as as_boolean,
			read_pointer as as_pointer
--		undefine
--			copy, is_equal, out
		end

	EL_STRING_8_CONSTANTS

	EL_VTD_CONSTANTS

	EL_MODULE_EXCEPTION; EL_MODULE_EIFFEL; EL_MODULE_FILE; EL_MODULE_HTML

	EL_MODULE_LIO; EL_MODULE_XML

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_IMMUTABLE_8_MANAGER

	EL_SHARED_CLASS_ID

feature -- Numeric values

	as_boolean: BOOLEAN
		require else
			value_is_boolean: is_boolean_value
		do
			Result := wide_string (c_node_context_normalized_string (self_ptr)).to_boolean
		end

	as_character_8: CHARACTER_8
		do
			if attached wide_string (c_node_context_normalized_string (self_ptr)) as str
				and then str.count > 0
			then
				Result := str.code (1).to_character_8
			end
		end

	as_character_32: CHARACTER_32
		do
			if attached wide_string (c_node_context_normalized_string (self_ptr)) as str
				and then str.count > 0
			then
				Result := str.item (1)
			end
		end

	as_double, as_real_64: DOUBLE
			-- element content as a DOUBLE
		require else
			value_is_double: value.is_double
		do
			Result := c_node_context_double (self_ptr)
		end

	as_integer_8: INTEGER_8
		-- element content as an INTEGER_8
		require else
			value_is_integer: value.is_integer_8
		do
			Result := as_integer_32.to_integer_8
		end

	as_integer_16: INTEGER_16
		-- element content as an INTEGER_16
		require else
			value_is_integer: value.is_integer_16
		do
			Result := as_integer_32.to_integer_16
		end

	as_integer, as_integer_32: INTEGER
			-- element content as an INTEGER
		require else
			value_is_integer: value.is_integer
		do
			Result := c_node_context_integer (self_ptr)
		end

	as_integer_64: INTEGER_64
			-- element content as an INTEGER_64
		require else
			value_is_integer_64: value.is_integer_64
		do
			Result := c_node_context_integer_64 (self_ptr)
		end

	as_natural_8: NATURAL_8
			-- element content as a NATURAL_8
		require else
			value_is_natural: value.is_natural_8
		do
			Result := as_natural_32.to_natural_8
		end

	as_natural_16: NATURAL_16
			-- element content as a NATURAL_16
		require else
			value_is_natural: value.is_natural_16
		do
			Result := as_natural_32.to_natural_16
		end

	as_natural_32, as_natural: NATURAL
			-- element content as a NATURAL
		require else
			value_is_natural: value.is_natural
		do
			Result := value.to_natural
		end

	as_natural_64: NATURAL_64
			-- element content as a NATURAL_64
		require else
			value_is_natural_64: value.is_natural_64
		do
			Result := value.to_natural_64
		end

	as_pointer: POINTER
		do
		end

	as_real, as_real_32: REAL
			-- element content as a REAL
		require else
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
		require else
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