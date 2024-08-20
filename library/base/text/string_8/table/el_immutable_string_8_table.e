note
	description: "[
		Implementation of ${EL_IMMUTABLE_STRING_TABLE} for keys and virtual items of type
		${IMMUTABLE_STRING_8} and initialized by a manifest string of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:09:24 GMT (Tuesday 20th August 2024)"
	revision: "15"

class
	EL_IMMUTABLE_STRING_8_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_8, IMMUTABLE_STRING_8]
		rename
			has_key_x as has_key_8,
			shared_cursor as shared_cursor_8,
			string as string_8
		undefine
			bit_count
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

	EL_MODULE_STRING_8

create
	make_code_map, make_comma_separated, make_assignments, make_field_map, make_empty, make_subset, make_reversed

feature -- Status query

	has_key_code (a_code: INTEGER_64): BOOLEAN
		do
			Result := has_key_8 (Buffer.integer_string (a_code))
		end

feature {NONE} -- Implementation

	new_shared (a_manifest: STRING_8): IMMUTABLE_STRING_8
		do
			Result := Immutable_8.new_substring (a_manifest.area, 0, a_manifest.count)
		end

	new_split_list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			create Result.make_empty
		end

	new_substring (str: IMMUTABLE_STRING_8; start_index, end_index: INTEGER): IMMUTABLE_STRING_8
		do
			Result := str.shared_substring (start_index, end_index)
		end

feature {NONE} -- Constants

	Buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end