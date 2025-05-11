note
	description: "XML element attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-11 9:48:42 GMT (Sunday 11th May 2025)"
	revision: "6"

class
	EL_ELEMENT_ATTRIBUTE

inherit
	EL_VTD_XML_ATTRIBUTE_API

	EL_VTD_SHARED_NATIVE_XPATH_TABLE

	EL_SHARED_C_WIDE_CHARACTER_STRING

	EL_C_OBJECT

	EL_STRING_8_CONSTANTS

create
	make

convert
	as_string: {ZSTRING}, as_string_8: {STRING}, as_string_32: {STRING_32},
	as_real: {REAL}, as_double: {DOUBLE}, as_date: {DATE},
	as_integer: {INTEGER}, as_integer_64: {INTEGER_64},
	as_natural: {NATURAL}, as_natural_64: {NATURAL_64},
	as_file_path: {FILE_PATH}, as_dir_path: {DIR_PATH},
	as_boolean: {BOOLEAN}


feature {NONE} -- Initialization

	make
		do
			name := Default_name
		end

feature -- Numeric value

	as_double: DOUBLE
			--
		require
			is_double: as_string_8.is_double
		do
			Result := c_evx_node_context_attribute_double (exception_callbacks_c_struct, self_ptr, name.base_address)
		end

	as_integer: INTEGER
			--
		require
			is_integer: as_string_8.is_integer
		do
			Result := c_evx_node_context_attribute_integer (exception_callbacks_c_struct, self_ptr, name.base_address)
		end

	as_integer_64: INTEGER_64
			--
		require
			is_integer_64: as_string_8.is_integer_64
		do
			Result := c_evx_node_context_attribute_integer_64 (exception_callbacks_c_struct, self_ptr, name.base_address)
		end

	as_natural: NATURAL
			-- attribute content as a NATURAL
		require
			is_natural: as_string_8.is_natural
		do
			Result := as_integer_64.to_natural_32
		end

	as_natural_64: NATURAL_64
			-- attribute content as a NATURAL_64
		require
			is_natural_64: as_string_8.is_natural_64
		do
			Result := as_string_8.to_natural_64
		end

	as_real: REAL
			--
		require
			is_real: as_string_8.is_real
		do
			Result := c_evx_node_context_attribute_real (exception_callbacks_c_struct, self_ptr, name.base_address)
		end

feature -- Access

	as_boolean: BOOLEAN
			-- `True' if attribute `name' equals "True" or "true"
		require
			is_boolean: as_string_8.is_boolean
		do
			Result := wide_string (attribute_string).to_boolean
		end

	as_date: EL_DATE
			-- attribute content as a DOUBLE
		require
			days_format: as_string_8.is_natural
		do
			create Result.make_by_days (as_integer)
		end

	as_dir_path: DIR_PATH
		do
			Result := as_string
		end

	as_file_path: FILE_PATH
		do
			Result := as_string
		end

	as_raw_string: ZSTRING
			--  attribute content as string with entities and char references not expanded
		do
			Result := wide_string (attribute_raw_string)
		end

	as_raw_string_32: STRING_32
			-- attribute content as wide string with entities and char references not expanded
		do
			Result := wide_string (attribute_raw_string)
		end

	as_string: ZSTRING
		do
			Result := wide_string (attribute_string)
		end

	as_string_32: STRING_32
		do
			Result := wide_string (attribute_string)
		end

	as_string_8: STRING_8
		do
			Result := wide_string (attribute_string)
		end

feature -- Status query

	is_valid_name: BOOLEAN
		do
			Result := is_attached (attribute_string)
		end

	same_as (value: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if attribute `name' has the same characters as `value'
		local
			s: like wide_string; i: INTEGER
		do
			s := wide_string (attribute_string)
			if s.count = value.count then
				Result := True
				from i := 1 until not Result or i > s.count loop
					Result := s.item (i) = value [i]
					i := i + 1
				end
			end
		end

feature -- Element change

	set_context (element_context: EL_XPATH_NODE_CONTEXT; name_general: READABLE_STRING_GENERAL)
		do
			self_ptr := element_context.self_ptr
			exception_callbacks_c_struct := element_context.exception_callbacks_c_struct
			name := Native_xpath_table.item (name_general)
		end

feature {NONE} -- Implementation

	attribute_raw_string: POINTER
			--
		do
			Result := c_evx_node_context_attribute_raw_string (exception_callbacks_c_struct, self_ptr, name.base_address)
		end

	attribute_string: POINTER
			--
		do
			Result := c_evx_node_context_attribute_string (exception_callbacks_c_struct, self_ptr, name.base_address)
		end

feature {NONE} -- Internal attributes

	exception_callbacks_c_struct: POINTER

	name: like Default_name
		-- native VTD name

feature {NONE} -- Constants

	Default_name: EL_VTD_NATIVE_XPATH_I [COMPARABLE]
		once
			create {EL_VTD_NATIVE_XPATH_IMP} Result.make_empty
		end

end