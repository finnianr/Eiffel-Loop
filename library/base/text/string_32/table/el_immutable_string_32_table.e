note
	description: "[
		Implementation of ${EL_IMMUTABLE_STRING_TABLE} for keys and virtual items of type
		${IMMUTABLE_STRING_32} and initialized by a manifest string of type ${STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 9:44:50 GMT (Monday 21st April 2025)"
	revision: "21"

class
	EL_IMMUTABLE_STRING_32_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_32, IMMUTABLE_STRING_32]
		rename
			has_key_x as has_key_32,
			extended_string as super_readable_32
		undefine
			bit_count
		end

	EL_STRING_GENERAL_ROUTINES_I

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_SHARED_IMMUTABLE_32_MANAGER

create
	make_comma_separated, make_assignments, make_empty, make_reversed

feature -- Status query

	has_key_32 (a_key: READABLE_STRING_32): BOOLEAN
		local
			l_key: READABLE_STRING_32
		do
			if conforms_to_zstring (a_key) then
			-- ZSTRING
				l_key := a_key.to_string_32
			else
				l_key := a_key
			end
			Result := has_immutable_key (Immutable_32.as_shared (l_key))
		end

	has_key_code (a_code: INTEGER_64): BOOLEAN
		do
			Result := has_key_32 (Buffer.integer_string (a_code))
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		local
			l_key: READABLE_STRING_32
		do
			if a_key.is_string_32 and then not conforms_to_zstring (a_key)
				and then attached {READABLE_STRING_32} a_key as key_32
			then
				l_key := key_32
			else
				l_key := a_key.to_string_32
			end
			Result := has_immutable_key (Immutable_32.as_shared (l_key))
		end

feature {NONE} -- Implementation

	immutable_interval (a_str: IMMUTABLE_STRING_32): INTEGER_64
		local
			index_lower, index_upper: INTEGER
		do
			if attached Character_area_32.get (a_str, $index_lower, $index_upper) as l_area then
				Result := compact_interval (index_lower + 1, index_upper + 1)
			end
		end

	new_list (iterable_list: ITERABLE [IMMUTABLE_STRING_32]): EL_STRING_32_LIST
		do
			create Result.make_from_general (iterable_list)
		end

	new_shared (a_manifest: STRING_32): IMMUTABLE_STRING_32
		do
			Result := Immutable_32.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_32_LIST
		do
			create Result.make_empty
		end

	new_substring (str: IMMUTABLE_STRING_32; start_index, end_index: INTEGER): IMMUTABLE_STRING_32
		do
			Result := str.shared_substring (start_index, end_index)
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_32_BUFFER
		once
			create Result
		end

end