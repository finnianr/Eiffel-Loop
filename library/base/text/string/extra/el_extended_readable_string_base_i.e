note
	description: "Base routines for ${EL_EXTENDED_READABLE_STRING_BASE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-13 17:47:58 GMT (Sunday 13th April 2025)"
	revision: "4"

deferred class
	EL_EXTENDED_READABLE_STRING_BASE_I [CHAR -> COMPARABLE]

inherit
	EL_INDEXABLE_FROM_1
		rename
			valid_indices_range as valid_substring_indices
		end

	EL_BIT_COUNTABLE

	EL_CASE_CONTRACT

	EL_UC_ROUTINES
		rename
			utf_8_byte_count as code_utf_8_byte_count
		export
			{NONE} all
		undefine
			copy, is_equal, out
		end

	EL_STRING_HANDLER

	EL_SHARED_UNICODE_PROPERTY; EL_SHARED_UTF_8_SEQUENCE; EL_SHARED_ZSTRING_CODEC

feature -- Element change

	set_target (a_target: like target)
		deferred
		end

feature -- Contract Support

	convertible_to_char (uc: CHARACTER_32): BOOLEAN
		do
			Result := True
		end

	ends_with_target (str: READABLE_STRING_GENERAL; index: INTEGER): BOOLEAN
		do
			Result := target.same_characters (str, index, str.count, 1)
		end

	ends_with_target_substring (str: READABLE_STRING_GENERAL; target_index, index: INTEGER): BOOLEAN
		do
			Result := target.same_characters (str, index, str.count, target_index)
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := target.is_valid_as_string_8
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := target.valid_index (i)
		end

feature {NONE} -- Measurement

	index_lower: INTEGER
		deferred
		end

	index_upper: INTEGER
		deferred
		end

	latin_1_count: INTEGER
		deferred
		end

feature {NONE} -- Character query

	is_c_identifier_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if characters in `a_area' from `i_lower' to `i_upper' constitute
		-- a C language identifier
		deferred
		end

	is_eiffel_identifier_in_range (a_area: like area; i_lower, i_upper: INTEGER; case: NATURAL_8): BOOLEAN
		deferred
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area'  is alphabetical or numeric
		deferred
		end

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		deferred
		end

feature {NONE} -- Conversion

	to_char (uc: CHARACTER_32): CHAR
		deferred
		end

	to_character_32 (c: CHAR): CHARACTER_32
		deferred
		end

	to_character_8 (c: CHAR): CHARACTER_8
		deferred
		end

	to_natural_32_code (c: CHAR): NATURAL
		deferred
		end

feature {NONE} -- Deferred

	all_ascii_in_range (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		deferred
		end

	area: SPECIAL [CHAR]
		deferred
		end

	empty_target: like target
		deferred
		end

	new_readable: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		deferred
		end

	new_shared_substring (str: like READABLE_X; start_index, end_index: INTEGER): like READABLE_X
		deferred
		end

	other_area (other: like READABLE_X): like area
		deferred
		end

	other_index_lower (other: like READABLE_X): INTEGER
		deferred
		end

	target: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Type definitions

	READABLE_X: READABLE_STRING_GENERAL
		require
			never_called: False
		deferred
		end

invariant
	consistent_with_count: index_upper - index_lower + 1 = count
end