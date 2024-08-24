note
	description: "Table with keys conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-24 13:56:18 GMT (Saturday 24th August 2024)"
	revision: "9"

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

	same_keys (search_key, key: READABLE_STRING_GENERAL): BOOLEAN
		do
			if search_key.is_string_8 then
				if key.is_string_8 then
					Result := as_readable_string_8 (search_key).same_string (as_readable_string_8 (key))
				else
					Result := search_key.same_string (key)
				end

			elseif is_zstring (search_key) and then attached {ZSTRING} search_key as z_str then
			-- ZSTRING has it's own implementation of `same_characters_general'
				Result := z_str.same_string_general (key)

			elseif is_zstring (key) and then attached {ZSTRING} key as z_str then
				Result := z_str.same_string_general (search_key)

			elseif key.is_string_32 then
				Result := as_readable_string_32 (search_key).same_string (as_readable_string_32 (key))

			else
				Result := search_key.same_string (key)
			end
		end

end