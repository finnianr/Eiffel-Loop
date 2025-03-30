note
	description: "HTTP name value parameter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:43 GMT (Sunday 30th March 2025)"
	revision: "16"

class
	EL_HTTP_NAME_VALUE_PARAMETER

inherit
	EL_HTTP_PARAMETER

	EL_STRING_GENERAL_ROUTINES_I

	DEBUG_OUTPUT

create
	make, make_from_field

feature {NONE} -- Initialization

	make (a_name, a_value: READABLE_STRING_GENERAL)
		do
			name := as_zstring (a_name); value := as_zstring (a_value)
		end

	make_from_field (object: EL_REFLECTIVE; field: EL_REFLECTED_FIELD)
		do
			make (field.export_name, field.to_string (object))
		end

feature -- Access

	name: ZSTRING

	value: ZSTRING

feature -- Status report

	debug_output: STRING_32
		local
			s: EL_STRING_32_ROUTINES
		do

			Result := s.joined_list (<< name.to_string_32, value.to_string_32 >>, '=')
		end

feature {EL_HTTP_PARAMETER} -- Implementation

	add_to_table (table: EL_URI_QUERY_ZSTRING_HASH_TABLE)
		do
			table.set_string (name, value)
		end
end