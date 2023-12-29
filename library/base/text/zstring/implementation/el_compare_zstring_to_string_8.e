note
	description: "[
		Implementation of [$source EL_ZSTRING_INTERVALS] for comparing with strings conforming
		to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-29 11:07:25 GMT (Friday 29th December 2023)"
	revision: "7"

class
	EL_COMPARE_ZSTRING_TO_STRING_8

inherit
	EL_COMPARABLE_ZSTRING_INTERVALS [CHARACTER_8, READABLE_STRING_8]

	EL_SHARED_STRING_8_CURSOR
		rename
			cursor_8 as string_cursor
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
			l_other_area: SPECIAL [CHARACTER]
		do
			l_unicodes := unicode_table; l_other_area := other_area
			other_offset := other_area_first_index + a_other_offset
			Result := True
			from i := 0 until not Result or else i = a_count loop
				j := i + offset
				c_j := encoded_area [j]
				inspect c_j
					when Control_0 .. Max_ascii then
						Result := c_j = l_other_area [j + other_offset]
				else
					Result := l_unicodes [c_j.code].to_character_8 = l_other_area [j + other_offset]
				end
				i := i + 1
			end
		end

	same_interval_characters (
		current_area: like unencoded_area; a_other_area: SPECIAL [CHARACTER_8]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := 0 until not Result or i = comparison_count loop
				Result := current_area [current_i + i] = a_other_area [other_i + i].to_character_32
				i := i + 1
			end
		end

end