note
	description: "[
		Implementation of ${EL_IMMUTABLE_STRING_TABLE} for keys and virtual items of type
		${IMMUTABLE_STRING_8} and initialized by a manifest string of type ${STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-03 8:47:25 GMT (Monday 3rd March 2025)"
	revision: "18"

class
	EL_IMMUTABLE_STRING_8_TABLE

inherit
	EL_IMMUTABLE_STRING_TABLE [STRING_8, IMMUTABLE_STRING_8]
		rename
			has_key_x as has_key,
			shared_cursor as shared_cursor_8,
			string as string_8
		undefine
			bit_count
		end

	EL_IMMUTABLE_KEY_8_LOOKUP

	EL_STRING_8_BIT_COUNTABLE [STRING_8]

	EL_MODULE_STRING_8

create
	make, make_comma_separated, make_assignments, make_empty, make_subset, make_reversed

feature -- Status query

	has_key_code (a_code: INTEGER_64): BOOLEAN
		do
			Result := has_key (Key_buffer.integer_string (a_code))
		end

feature -- Access

	unidented_item_for_iteration: STRING_8
		local
			interval: INTEGER_64
		do
			interval := interval_item_for_iteration
			Result := String_8.new_from_immutable_8 (manifest, to_lower (interval), to_upper (interval), True, False)
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

end