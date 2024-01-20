note
	description: "${EL_COMPARE_ZSTRING_TO_STRING_32} with case-insensitive comparisons"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:25 GMT (Saturday 20th January 2024)"
	revision: "8"

class
	EL_CASELESS_COMPARE_ZSTRING_TO_STRING_32

inherit
	EL_COMPARE_ZSTRING_TO_STRING_32
		redefine
			same_encoded_interval_characters, same_interval_characters
		end

create
	make

feature {NONE} -- Implementation

	same_encoded_interval_characters (
		encoded_area: SPECIAL [CHARACTER]; a_count, offset, a_other_offset: INTEGER
	): BOOLEAN
		local
			i, j, other_offset: INTEGER; c_j: CHARACTER; l_unicodes: like unicode_table
			l_other_area: SPECIAL [CHARACTER_32]; c32: EL_CHARACTER_32_ROUTINES
			lower_case: CHARACTER_32
		do
			l_unicodes := unicode_table; l_other_area := other_area
			other_offset := other_area_first_index + a_other_offset
			Result := True
			from i := 0 until not Result or else i = a_count loop
				j := i + offset
				c_j := encoded_area [j]
				inspect c_j
					when Control_0 .. Max_ascii then
						lower_case := c32.to_lower (c_j.to_character_32)
				else
					lower_case := c32.to_lower (l_unicodes [c_j.code])
				end
				Result := lower_case = c32.to_lower (l_other_area [j + other_offset])
				i := i + 1
			end
		end

	same_interval_characters (
		current_area: like unencoded_area; a_other_area: SPECIAL [CHARACTER_32]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.same_caseless_sub_array (current_area, a_other_area, current_i, other_i, comparison_count)
		end
end