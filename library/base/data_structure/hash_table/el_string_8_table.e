note
	description: "Table with keys conforming to ${READABLE_STRING_8}"
	descendants: "[
			EL_STRING_8_TABLE [G]
				${EL_FIELD_VALUE_TABLE [G]}
				${EL_DATE_FUNCTION_TABLE}
				${EVC_FUNCTION_TABLE}
				${EL_XPATH_TOKEN_TABLE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:26:03 GMT (Monday 21st April 2025)"
	revision: "10"

class
	EL_STRING_8_TABLE [G]

inherit
	EL_HASH_TABLE [G, READABLE_STRING_8]
		redefine
			same_keys
		end

	EL_STRING_8_BIT_COUNTABLE [READABLE_STRING_8]

create
	default_create, make_assignments, make, make_equal, make_from_map_list

feature -- Comparison

	same_keys (a_search_key, a_key: READABLE_STRING_8): BOOLEAN
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			Result := sg.super_readable_8 (a_search_key).same_string (a_key)
		end

end