note
	description: "Table with keys conforming to [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-12 13:00:14 GMT (Sunday 12th November 2023)"
	revision: "4"

class
	EL_STRING_GENERAL_TABLE [G]

inherit
	EL_HASH_TABLE [G, READABLE_STRING_GENERAL]
		redefine
			same_keys
		end

create
	default_create, make, make_size, make_equal, make_from_map_list

feature -- Comparison

	same_keys (a_search_key, a_key: READABLE_STRING_GENERAL): BOOLEAN
		local
			s32: EL_STRING_32_ROUTINES; s8: EL_STRING_8_ROUTINES
		do
			if a_search_key.is_string_8 and then attached {READABLE_STRING_8} a_search_key as a
				and then attached {READABLE_STRING_8} a_key as b
			then
				Result := s8.same_strings (a, b)

			elseif attached {READABLE_STRING_32} a_search_key as a
				and then attached {READABLE_STRING_32} a_key as b
			then
				Result := s32.same_strings (a, b)
			else
				Result := a_search_key.same_string (a_key)
			end
		end

end