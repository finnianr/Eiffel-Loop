note
	description: "Table with keys conforming to [$source READABLE_STRING_32]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 9:27:51 GMT (Monday 31st July 2023)"
	revision: "3"

class
	EL_STRING_32_TABLE [G]

inherit
	EL_HASH_TABLE [G, READABLE_STRING_32]
		redefine
			same_keys
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

create
	default_create, make, make_size, make_equal, make_from_map_list

feature -- Comparison

	same_keys (a_search_key, a_key: READABLE_STRING_32): BOOLEAN
		local
			s32: EL_STRING_32_ROUTINES
		do
			Result := s32.same_strings (a_search_key, a_key)
		end

end