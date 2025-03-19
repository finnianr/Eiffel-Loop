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
	date: "2025-03-18 7:03:52 GMT (Tuesday 18th March 2025)"
	revision: "9"

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
			s8: EL_STRING_8_ROUTINES
		do
			Result := s8.same_string (a_search_key, a_key)
		end

end