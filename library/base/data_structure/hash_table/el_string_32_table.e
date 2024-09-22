note
	description: "Table with keys conforming to ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:47:51 GMT (Sunday 22nd September 2024)"
	revision: "6"

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
			s32: EL_STRING_32_ROUTINES
		do
			Result := s32.same_string (a_search_key, a_key)
		end

end