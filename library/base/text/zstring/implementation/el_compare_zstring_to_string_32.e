note
	description: "[
		Implementation of ${EL_ZSTRING_INTERVALS} for comparing with strings conforming
		to ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-29 10:42:49 GMT (Friday 29th December 2023)"
	revision: "6"

class
	EL_COMPARE_ZSTRING_TO_STRING_32

inherit
	EL_COMPARABLE_ZSTRING_INTERVALS [CHARACTER_32, READABLE_STRING_32]

	EL_SHARED_STRING_32_CURSOR
		rename
			cursor_32 as string_cursor
		end

create
	make

feature -- Element change

	set_other_area (a_cursor: like string_cursor)
		do
			other_area := a_cursor.area
			other_area_first_index := a_cursor.area_first_index
		end

feature {NONE} -- Implementation

	same_encoded_interval_characters (
		encoded_area: SPECIAL [CHARACTER]; a_count, offset, a_other_offset: INTEGER
	): BOOLEAN
		local
			i, j, other_offset: INTEGER; c_j: CHARACTER; l_unicodes: like unicode_table
			l_other_area: SPECIAL [CHARACTER_32]
		do
			l_unicodes := unicode_table; l_other_area := other_area
			other_offset := other_area_first_index + a_other_offset
			Result := True
			from i := 0 until not Result or else i = a_count loop
				j := i + offset
				c_j := encoded_area [j]
				inspect c_j
					when Control_0 .. Max_ascii then
						Result := c_j.to_character_32 = l_other_area [j + other_offset]
				else
					Result := l_unicodes [c_j.code] = l_other_area [j + other_offset]
				end
				i := i + 1
			end
		end

	same_interval_characters (
		current_area: like unencoded_area; a_other_area: SPECIAL [CHARACTER_32]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		do
			Result := current_area.same_items (a_other_area, other_i, current_i, comparison_count)
		end

end