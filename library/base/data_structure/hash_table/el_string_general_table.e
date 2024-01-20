note
	description: "Table with keys conforming to ${READABLE_STRING_GENERAL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "6"

class
	EL_STRING_GENERAL_TABLE [G]

inherit
	EL_HASH_TABLE [G, READABLE_STRING_GENERAL]
		redefine
			same_keys
		end

	EL_SHARED_CLASS_ID

create
	default_create, make, make_size, make_equal, make_from_map_list

feature -- Comparison

	same_keys (a_search_key, a_key: READABLE_STRING_GENERAL): BOOLEAN
		local
			s32: EL_STRING_32_ROUTINES; s8: EL_STRING_8_ROUTINES
			id_search: CHARACTER
		do
			id_search := Class_id.character_bytes (a_search_key)
			if id_search = Class_id.character_bytes (a_key) then
				inspect id_search
					when '1' then
						if attached {READABLE_STRING_8} a_search_key as a
							and then attached {READABLE_STRING_8} a_key as b
						then
							Result := s8.same_strings (a, b)
						end
					when '4' then
						if attached {READABLE_STRING_32} a_search_key as a
							and then attached {READABLE_STRING_32} a_key as b
						then
							Result := s32.same_strings (a, b)
						end
					when 'X' then
						if attached {EL_READABLE_ZSTRING} a_search_key as a
							and then attached {EL_READABLE_ZSTRING} a_key as b
						then
							Result := a.same_string (b)
						end
				end
			else
				Result := a_search_key.same_string (a_key)
			end
		end

end