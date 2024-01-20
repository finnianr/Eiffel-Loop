note
	description: "[
		Implementation of ${EL_IMMUTABLE_STRING_TABLE} for keys and virtual items of type
		${IMMUTABLE_STRING_8} and initialized by a manifest string of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	EL_IMMUTABLE_STRING_8_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_8, IMMUTABLE_STRING_8]
		rename
			has_key_x as has_key_8,
			string as string_8
		undefine
			bit_count
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

	EL_MODULE_STRING_8

	EL_SHARED_STRING_8_CURSOR

create
	make, make_by_assignment, make_by_indented, make_empty, make_subset, make_reversed

feature {NONE} -- Implementation

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_empty
		end

	new_shared (a_manifest: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_substring (start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		do
			Result := manifest.shared_substring (start_index, end_index)
		end

	shared_cursor (str: IMMUTABLE_STRING_8): EL_STRING_ITERATION_CURSOR
		do
			Result := cursor_8 (str)
		end

end