note
	description: "Table of XML node attribute values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-29 11:02:53 GMT (Saturday 29th August 2020)"
	revision: "5"

class
	EL_ELEMENT_ATTRIBUTE_TABLE

inherit
	EL_VTD_XML_ATTRIBUTE_API

create
	make

feature {NONE} -- Initialization

	make (element_context: EL_XPATH_NODE_CONTEXT)
			--
		do
			c_node_context := element_context.self_ptr
			exception_callbacks_c_struct := element_context.exception_callbacks_c_struct
		end

feature -- Numeric value

	double (name: READABLE_STRING_GENERAL): DOUBLE
			-- attribute content as a DOUBLE
		require
			exists: has (name)
		do
			Result := c_node_context_attribute_double (name)
		end

	integer (name: READABLE_STRING_GENERAL): INTEGER
			-- attribute content as an INTEGER
		require
			exists: has (name)
			is_integer: item (name).is_integer
		do
			Result := c_node_context_attribute_integer (name)
		end

	integer_64 (name: READABLE_STRING_GENERAL): INTEGER_64
			-- attribute content as an INTEGER_64
		require
			exists: has (name)
			is_integer_64: item (name).is_integer_64
		do
			Result := c_node_context_attribute_integer_64 (name)
		end

	real (name: READABLE_STRING_GENERAL): REAL
			-- attribute content as a REAL
		require
			exists: has (name)
			is_real: item (name).is_real
		do
			Result := c_node_context_attribute_real (name)
		end

	natural (name: READABLE_STRING_GENERAL): NATURAL
			-- attribute content as a NATURAL
		require
			exists: has (name)
			is_natural: item (name).is_natural
		do
			Result := item (name).to_natural
		end

	natural_64 (name: READABLE_STRING_GENERAL): NATURAL_64
			-- attribute content as a NATURAL_64
		require
			exists: has (name)
			is_natural_64: item (name).is_natural_64
		do
			Result := item (name).to_natural_64
		end

feature -- Access

	date (name: READABLE_STRING_GENERAL): DATE
			-- attribute content as a DOUBLE
		require
			exists: has (name)
			days_format: item (name).is_natural
		do
			create Result.make_by_days (integer (name))
		end

	item alias "[]", string (name: READABLE_STRING_GENERAL): ZSTRING
			-- attribute content as augmented latin string
		require
			exists: has (name)
		do
			Result := wide_string (c_node_context_attribute_string (name))
		end

	string_8 (name: READABLE_STRING_GENERAL): STRING_8
		require
			exists: has (name)
		do
			Result := wide_string (c_node_context_attribute_string (name))
		end

	string_32 (name: READABLE_STRING_GENERAL): STRING_32
		require
			exists: has (name)
		do
			Result := wide_string (c_node_context_attribute_string (name))
		end

	raw_string (name: READABLE_STRING_GENERAL): ZSTRING
			--  attribute content as string with entities and char references not expanded
		require
			exists: has (name)
		do
			Result := wide_string (c_node_context_attribute_raw_string (name))
		end

	raw_string_32 (name: READABLE_STRING_GENERAL): STRING_32
			-- attribute content as wide string with entities and char references not expanded
		require
			exists: has (name)
		do
			Result := wide_string (c_node_context_attribute_raw_string (name))
		end

feature -- Status query

	boolean (name: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if attribute `name' equals "True" or "true"
		require
			exists: has (name)
			is_boolean: item (name).is_boolean
		local
			s: like wide_string
		do
			s := wide_string (c_node_context_attribute_string (name))
			if s.count = 4 then
				inspect s.item (1).to_character_8
					when 'T', 't' then
						Result := True
				else
				end
			end
		end

	has (name: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := not c_node_context_attribute_string (name).is_default_pointer
		end

	same_as (name, value: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if attribute `name' has the same characters as `value'
		require
			exists: has (name)
		local
			s: like wide_string; i: INTEGER
		do
			s := wide_string (c_node_context_attribute_string (name))
			if s.count = value.count then
				Result := True
				from i := 1 until not Result or i > s.count loop
					Result := s.item (i).to_character_32 = value.item (i)
					i := i + 1
				end
			end
		end

end
