note
	description: "{EL_EXTENDED_READABLE_STRING_I} implemented for ${CHARACTER_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 8:50:20 GMT (Tuesday 15th April 2025)"
	revision: "11"

deferred class
	EL_EXTENDED_READABLE_STRING_32_I

inherit
	EL_EXTENDED_READABLE_STRING_I [CHARACTER_32]
		rename
			READABLE_X as READABLE_32
		redefine
			target
		end

	EL_STRING_32_CONSTANTS

	EL_SHARED_IMMUTABLE_32_MANAGER

feature -- Measurement

	latin_1_count: INTEGER
		local
			i, i_upper: INTEGER
		do
			if attached area as l_area then
				i_upper := index_upper
				from i := index_lower until i > i_upper or else not l_area [i].is_character_8 loop
					i := i + 1
				end
				Result := i - index_lower
			end
		end

feature -- Status query

	has (uc: CHARACTER_32): BOOLEAN
		-- `True' if `target' has `uc'
		do
			Result := target.has (uc)
		end

	is_alpha_numeric: BOOLEAN
		-- `True' if all characters in `target' are alphabetical or numerical
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_alpha_numeric_area (area, index_lower, index_upper)
		end

	is_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if `target' consists exactly of one character `uc'
		do
			Result := count = 1 and then target [1] = uc
		end

feature {NONE} -- Implementation

	all_ascii_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_ascii_area (area, i_lower, i_upper)
		end

	is_c_identifier_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if characters in `a_area' from `i_lower' to `i_upper' constitute
		-- a C language identifier
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_c_identifier_area (area, i_lower, i_upper)
		end

	is_eiffel_identifier_in_range (a_area: like area; i_lower, i_upper: INTEGER; case: NATURAL_8): BOOLEAN
		local
			c: EL_CHARACTER_32_ROUTINES
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

	is_i_th_identifier (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is a code identifier character
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.is_c_identifier (a_area [i], False)
		end

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		do
			Result := unicode.is_space (a_area [i])
		end

	is_left_bracket (c: CHARACTER_32): BOOLEAN
		local
			r: EL_CHARACTER_32_ROUTINES
		do
			Result := r.is_left_bracket (c)
		end

	new_shared_substring (str: READABLE_STRING_32; start_index, end_index: INTEGER): READABLE_STRING_32
		do
			Result := Immutable_32.shared_substring (str, start_index, end_index)
		end

	right_bracket_index (a_area: like area; left_bracket: CHARACTER_32; start_index, end_index: INTEGER): INTEGER
		-- index of right bracket corresponding to `left_bracket'. `-1' if not found.
		local
			c: EL_CHARACTER_32_ROUTINES
		do
			Result := c.right_bracket_index (a_area, left_bracket, start_index, end_index)
		end

	shared_substring (a_target: IMMUTABLE_STRING_32; start_index, end_index: INTEGER_32): IMMUTABLE_STRING_32
		do
			Result := a_target.shared_substring (start_index, end_index)
		end

	to_char (uc: CHARACTER_32): CHARACTER_32
		do
			Result := uc
		end

	to_character_32 (uc: CHARACTER_32): CHARACTER_32
		do
			Result := uc
		end

	to_character_8 (uc: CHARACTER_32): CHARACTER_8
		require else
			is_character_8: uc.is_character_8
		do
			Result := uc.to_character_8
		end

	to_natural_32_code (uc: CHARACTER_32): NATURAL
		do
			Result := uc.natural_32_code
		end

feature {NONE} -- Deferred

	target: READABLE_STRING_32
		deferred
		end

feature {NONE} -- Type definitions

	READABLE_32: READABLE_STRING_32
		once
			Result := Empty_string_32
		end

end