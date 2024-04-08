note
	description: "Table with keys conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-08 13:52:31 GMT (Monday 8th April 2024)"
	revision: "7"

class
	EL_STRING_GENERAL_TABLE [G]

inherit
	EL_HASH_TABLE [G, READABLE_STRING_GENERAL]
		redefine
			same_keys
		end

	EL_STRING_GENERAL_ROUTINES

create
	default_create, make, make_size, make_equal, make_from_map_list

feature -- Comparison

	same_keys (a_search_key, a_key: READABLE_STRING_GENERAL): BOOLEAN
		local
			s32: EL_STRING_32_ROUTINES; s8: EL_STRING_8_ROUTINES
		do
			if a_search_key.is_string_8 and a_key.is_string_8 then
				Result := s8.same_strings (readable_string_8 (a_search_key), readable_string_8 (a_key))

			elseif is_zstring (a_search_key) and is_zstring (a_key) then
				Result := as_zstring (a_search_key) ~ as_zstring (a_key)

			elseif a_search_key.is_string_32 and a_key.is_string_32 then
				Result := s32.same_strings (readable_string_32 (a_search_key), readable_string_32 (a_key))
			else
				Result := a_search_key.same_string (a_key)
			end
		end

end