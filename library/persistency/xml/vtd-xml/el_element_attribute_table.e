note
	description: "Table of XML node attribute values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 10:44:03 GMT (Tuesday 18th April 2017)"
	revision: "3"

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

feature -- Access

	boolean (name: READABLE_STRING_GENERAL): BOOLEAN
			-- attribute content as a BOOLEAN
		require
			exists: has (name)
			is_boolean: item (name).is_boolean
		do
			Result := item (name).to_boolean
		end

	date (name: READABLE_STRING_GENERAL): DATE
			-- attribute content as a DOUBLE
		require
			exists: has (name)
			days_format: item (name).is_natural
		do
			create Result.make_by_days (integer (name))
		end

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

feature -- Status query

	has (name: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := not c_node_context_attribute_string (name).is_default_pointer
		end

end
