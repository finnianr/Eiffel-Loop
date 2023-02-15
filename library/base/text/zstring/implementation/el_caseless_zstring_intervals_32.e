note
	description: "[
		Implementation of [$source EL_ZSTRING_INTERVALS_32] with caseless string comparisons
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-15 17:32:03 GMT (Wednesday 15th February 2023)"
	revision: "3"

class
	EL_CASELESS_ZSTRING_INTERVALS_32

inherit
	EL_ZSTRING_INTERVALS_32
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
			i, j, code, other_offset: INTEGER; c: CHARACTER; l_unicodes: like unicode_table
			l_other_area: SPECIAL [CHARACTER_32]; c32: EL_CHARACTER_32_ROUTINES
			lower_case: CHARACTER_32
		do
			l_unicodes := unicode_table; l_other_area := other_area
			other_offset := other_area_first_index + a_other_offset
			Result := True
			from i := 0 until not Result or else i = a_count loop
				j := i + offset
				c := encoded_area [j]; code := c.code
				if code <= Max_7_bit_code then
					lower_case := c32.to_lower (code.to_character_32)
				else
					lower_case := c32.to_lower (l_unicodes [code])
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
			i: INTEGER; other_as_lower: CHARACTER_32; c32: EL_CHARACTER_32_ROUTINES
		do
			Result := True
			from i := 0 until not Result or i = comparison_count loop
				other_as_lower := c32.to_lower (a_other_area [other_i + i])
				Result := c32.to_lower (current_area [current_i + i]) = other_as_lower
				i := i + 1
			end
		end
end