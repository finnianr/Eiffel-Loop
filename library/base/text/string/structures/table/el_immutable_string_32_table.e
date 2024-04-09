note
	description: "[
		Implementation of ${EL_IMMUTABLE_STRING_TABLE} for keys and virtual items of type
		${IMMUTABLE_STRING_32} and initialized by a manifest string of type ${STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-09 17:11:03 GMT (Tuesday 9th April 2024)"
	revision: "12"

class
	EL_IMMUTABLE_STRING_32_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_32, IMMUTABLE_STRING_32]
		rename
			has_key_x as has_key_32,
			string as string_32
		undefine
			bit_count
		end

	EL_STRING_GENERAL_ROUTINES

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_MODULE_STRING_32

	EL_SHARED_IMMUTABLE_32_MANAGER; EL_SHARED_STRING_32_CURSOR

create
	make, make_by_assignment, make_by_indented, make_empty, make_reversed

feature -- Status query

	has_key_32 (a_key: READABLE_STRING_32): BOOLEAN
		local
			l_key: READABLE_STRING_32
		do
			if is_zstring (a_key) then
			-- ZSTRING
				l_key := a_key.to_string_32
			else
				l_key := a_key
			end
			Result := has_immutable_key (Immutable_32.as_shared (l_key))
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		local
			l_key: READABLE_STRING_32
		do
			if a_key.is_string_32 and then not is_zstring (a_key)
				and then attached {READABLE_STRING_32} a_key as key_32
			then
				l_key := key_32
			else
				l_key := a_key.to_string_32
			end
			Result := has_immutable_key (Immutable_32.as_shared (l_key))
		end

feature {NONE} -- Implementation

	new_shared (a_manifest: STRING_32): IMMUTABLE_STRING_32
		do
			Result := Immutable_32.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_32_LIST
		do
			create Result.make_empty
		end

	new_substring (start_index, end_index: INTEGER): IMMUTABLE_STRING_32
		do
			Result := manifest.shared_substring (start_index, end_index)
		end

	shared_cursor (str: IMMUTABLE_STRING_32): EL_STRING_ITERATION_CURSOR
		do
			Result := cursor_32 (str)
		end
end