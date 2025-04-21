note
	description: "Table with keys conforming to ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 12:25:47 GMT (Monday 21st April 2025)"
	revision: "7"

class
	EL_STRING_32_TABLE [G]

inherit
	EL_HASH_TABLE [G, READABLE_STRING_32]
		redefine
			same_keys
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

create
	default_create, make, make_equal, make_assignments, make_from_map_list

feature -- Comparison

	same_keys (a_search_key, a_key: READABLE_STRING_32): BOOLEAN
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			Result := sg.super_readable_32 (a_search_key).same_string (a_key)
		end

end