note
	description: "[$source EL_COMPARE_ZSTRING_TO_STRING_8] with case-insensitive comparisons"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-29 10:50:52 GMT (Friday 29th December 2023)"
	revision: "7"

class
	EL_CASELESS_COMPARE_ZSTRING_TO_STRING_8

inherit
	EL_COMPARE_ZSTRING_TO_STRING_8
		redefine
			same_encoded_interval_characters, same_interval_characters
		end

create
	make

feature {NONE} -- Implementation

	same_encoded_interval_characters (encoded_area: SPECIAL [CHARACTER]; a_count, offset, a_other_offset: INTEGER): BOOLEAN
		local
			i, j, code_i, other_offset: INTEGER; l_unicodes: like unicode_table
			l_other_area: SPECIAL [CHARACTER_8]; c_32: EL_CHARACTER_32_ROUTINES
			uc_i, o_uc_i: CHARACTER_32
		do
			l_unicodes := unicode_table; l_other_area := other_area
			other_offset := other_area_first_index + a_other_offset
			Result := True
			from i := 0 until not Result or else i = a_count loop
				j := i + offset
			-- converting to UCS4 because of issues with {CHARACTER_8}.as_lower
				uc_i := encoded_area [j]; code_i := uc_i.code
				o_uc_i := l_other_area [j + other_offset]
				inspect code_i
					when 0 .. Max_ascii_code then
						uc_i := l_unicodes [code_i]
				else
				end
				Result := c_32.to_lower (uc_i) = c_32.to_lower (o_uc_i)
				i := i + 1
			end
		end

	same_interval_characters (
		current_area: like unencoded_area; a_other_area: SPECIAL [CHARACTER_8]
		other_i, current_i, comparison_count: INTEGER

	): BOOLEAN
		local
			i: INTEGER; other_as_lower: CHARACTER_32; c32: EL_CHARACTER_32_ROUTINES
		do
			Result := True
			from i := 0 until not Result or i = comparison_count loop
				other_as_lower := a_other_area [other_i + i].as_lower.to_character_32
				Result := c32.to_lower (current_area [current_i + i]) = other_as_lower
				i := i + 1
			end
		end

end