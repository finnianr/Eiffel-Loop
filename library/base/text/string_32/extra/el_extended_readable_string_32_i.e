note
	description: "{EL_EXTENDED_READABLE_STRING_I} implemented for ${CHARACTER_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-06 18:39:24 GMT (Sunday 6th April 2025)"
	revision: "4"

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

feature -- Status query

	is_alpha_numeric: BOOLEAN
		-- `True' if all characters in `target' are alphabetical or numerical
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_alpha_numeric_area (area, index_lower, index_upper)
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
			Result := unicode.is_space (a_area [i])
		end

	new_shared_substring (str: READABLE_STRING_32; start_index, end_index: INTEGER): READABLE_STRING_32
		do
			Result := Immutable_32.shared_substring (str, start_index, end_index)
		end

	new_readable: EL_EXTENDED_READABLE_STRING_32
		do
		-- Required to compile EL_EXTENDED_READABLE_ZSTRING
			create {EL_READABLE_STRING_32} Result.make_empty
		end

	target: READABLE_STRING_32
		deferred
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

feature {NONE} -- Type definitions

	READABLE_32: READABLE_STRING_32
		once
			Result := Empty_string_32
		end

end