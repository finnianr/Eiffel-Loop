note
	description: "[
		Implementation of [$source EL_IMMUTABLE_STRING_TABLE] for keys and virtual items of type
		[$source IMMUTABLE_STRING_32] and initialized by a manifest string of type [$source STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 10:49:36 GMT (Monday 14th August 2023)"
	revision: "8"

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

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_MODULE_STRING_32

	EL_SHARED_IMMUTABLE_32_MANAGER

create
	make, make_by_assignment, make_by_indented, make_empty

feature -- Status query

	has_key_32 (a_key: READABLE_STRING_32): BOOLEAN
		do
			Result := has_immutable_key (Immutable_32.as_shared (a_key))
		end

	has_key_general (a_key: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached {READABLE_STRING_32} a_key as key_32 then
				Result := has_key_32 (key_32)
			else
				Result := has_key_32 (a_key.to_string_32)
			end
		end

feature {NONE} -- Implementation

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_32_LIST
		do
			create Result.make_empty
		end

	new_shared (a_manifest: STRING_32): IMMUTABLE_STRING_32
		do
			Result := Immutable_32.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_substring (start_index, end_index: INTEGER): IMMUTABLE_STRING_32
		do
			Result := manifest.shared_substring (start_index, end_index)
		end

end