note
	description: "[
		Implementation of [$source EL_ZSTRING_INTERVALS] for comparing with strings conforming
		to [$source READABLE_STRING_32]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-15 13:44:20 GMT (Wednesday 15th February 2023)"
	revision: "1"

class
	EL_ZSTRING_INTERVALS_32

inherit
	EL_ZSTRING_INTERVALS [CHARACTER_32, READABLE_STRING_32]

create
	make

feature {NONE} -- Implementation

	area_first_index (a_cursor: like new_string_cursor): INTEGER
		do
			Result := a_cursor.area_first_index
		end

	cursor_area (a_cursor: like new_string_cursor): SPECIAL [CHARACTER_32]
		do
			Result := a_cursor.area
		end

	new_string_cursor: EL_STRING_32_ITERATION_CURSOR
		do
			create Result.make_empty
		end

	same_encoded_interval_characters (
		a_codec: like codec; encoded_area: SPECIAL [CHARACTER]
		a_count, offset, a_other_offset: INTEGER; other: EL_STRING_32_ITERATION_CURSOR
	): BOOLEAN
		do
			Result := a_codec.same_as_other_32 (encoded_area, a_count, offset, a_other_offset, other)
		end

	same_interval_characters (
		current_area: like unencoded_area; other_area: SPECIAL [CHARACTER_32]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		do
			Result := current_area.same_items (other_area, other_i, current_i, comparison_count)
		end

end