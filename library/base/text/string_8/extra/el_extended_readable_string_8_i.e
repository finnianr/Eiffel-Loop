note
	description: "{EL_EXTENDED_READABLE_STRING_I} implemented for ${CHARACTER_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 11:16:56 GMT (Saturday 5th April 2025)"
	revision: "2"

deferred class
	EL_EXTENDED_READABLE_STRING_8_I

inherit
	EL_EXTENDED_READABLE_STRING_I [CHARACTER_8]
		rename
			READABLE_X as READABLE_8
		redefine
			target
		end

	EL_STRING_8_CONSTANTS

	EL_SHARED_IMMUTABLE_8_MANAGER

feature {NONE} -- Implementation

	all_ascii_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			Result := c.is_ascii_area (area, i_lower, i_upper)
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

	target: READABLE_STRING_8
		deferred
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

feature {NONE} -- Type definitions

	READABLE_8: READABLE_STRING_8
		once
			Result := Empty_string_8
		end

end