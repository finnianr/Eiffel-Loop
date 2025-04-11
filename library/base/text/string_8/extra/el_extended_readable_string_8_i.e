note
	description: "{EL_EXTENDED_READABLE_STRING_I} implemented for ${CHARACTER_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-11 15:13:11 GMT (Friday 11th April 2025)"
	revision: "7"

deferred class
	EL_EXTENDED_READABLE_STRING_8_I

inherit
	EL_EXTENDED_READABLE_STRING_I [CHARACTER_8]
		rename
			READABLE_X as READABLE_8
		redefine
			latin_1_count, target
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_IMMUTABLE_8_MANAGER

feature -- Measurement

	latin_1_count: INTEGER
		do
			Result := count
		end

feature -- Status query

	is_alpha_numeric: BOOLEAN
		-- `True' if all characters in `target' are alphabetical or numerical
		local
			c8: EL_CHARACTER_8_ROUTINES
		do
			Result := c8.is_alpha_numeric_area (area, index_lower, index_upper)
		end

feature {NONE} -- Implementation

	all_ascii_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_ascii_area (area, i_lower, i_upper)
		end

	is_c_identifier_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if characters in `a_area' from `i_lower' to `i_upper' constitute
		-- a C language identifier
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_c_identifier_area (area, i_lower, i_upper)
		end

	is_eiffel_identifier_in_range (a_area: like area; i_lower, i_upper: INTEGER; case: NATURAL_8): BOOLEAN
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_eiffel_identifier_area (area, i_lower, i_upper, case)
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		do
			Result := a_area [i].is_alpha
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		do
			Result := a_area [i].is_alpha_numeric
		end

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		do
			Result := a_area [i].is_space
		end

	new_shared_substring (str: READABLE_STRING_8; start_index, end_index: INTEGER): READABLE_STRING_8
		do
			Result := Immutable_8.shared_substring (str, start_index, end_index)
		end

	right_bracket_index (a_area: like area; left_bracket: CHARACTER_8; start_index, end_index: INTEGER): INTEGER
		-- index of right bracket corresponding to `left_bracket'. `-1' if not found.
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.right_bracket_index (a_area, left_bracket, start_index, end_index)
		end

	to_char (uc: CHARACTER_32): CHARACTER_8
		do
			Result := uc.to_character_8
		end

	to_character_32 (c: CHARACTER_8): CHARACTER_32
		do
			Result := c.to_character_32
		end

	to_character_8 (c: CHARACTER_8): CHARACTER_8
		do
			Result := c
		end

	to_natural_32_code (c: CHARACTER_8): NATURAL
		do
			Result := c.natural_32_code
		end

feature {NONE} -- Deferred

	target: READABLE_STRING_8
		deferred
		end

feature {NONE} -- Type definitions

	READABLE_8: READABLE_STRING_8
		once
			Result := Empty_string_8
		end

end