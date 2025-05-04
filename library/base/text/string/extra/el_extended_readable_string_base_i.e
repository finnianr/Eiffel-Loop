note
	description: "Base routines for ${EL_EXTENDED_READABLE_STRING_BASE_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 7:14:19 GMT (Sunday 4th May 2025)"
	revision: "16"

deferred class
	EL_EXTENDED_READABLE_STRING_BASE_I [CHAR -> COMPARABLE]

inherit
	EL_INDEXABLE_FROM_1

	EL_BIT_COUNTABLE

	EL_CASE_CONTRACT

	EL_UC_ROUTINES_I
		rename
			utf_8_byte_count as code_utf_8_byte_count
		end

	EL_TYPED_POINTER_ROUTINES_I

	EL_STRING_HANDLER

	EL_SIDE_ROUTINES
		export
			{ANY} valid_side
		end

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

	is_identifier_string (str: like READABLE_X): BOOLEAN
		do
			if attached new_readable as super then
				super.set_target (str)
				Result := super.is_eiffel
			end
		end

	is_valid_as_string_8: BOOLEAN
		do
			Result := target.is_valid_as_string_8
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := target.valid_index (i)
		end

feature -- Conversion

	split (c: CHAR): EL_SPLIT_ON_CHARACTER [like target, CHAR]
		-- left adjusted iterable split of `target'
		deferred
		end

	split_adjusted (c: CHAR; adjustments: INTEGER): like split
		require
			valid_side: valid_side (adjustments)
		deferred
		end

	to_char (uc: CHARACTER_32): CHAR
		deferred
		end

feature {NONE} -- Measurement

	index_lower: INTEGER
		deferred
		end

	index_of (c: CHAR; start_index: INTEGER): INTEGER
		-- Position of first occurrence of `c' at or after `start_index', 0 if none.
		deferred
		end

	index_upper: INTEGER
		deferred
		end

	last_index_of (c: CHAR; start_index_from_end: INTEGER): INTEGER
		-- Position of last occurrence of `c', 0 if none.
		deferred
		end

	latin_1_count: INTEGER
		deferred
		end

feature {NONE} -- Deferred Character

	has (c: CHAR): BOOLEAN
		-- `True' if `target' has `c'
		deferred
		ensure
			definition: target.has (to_character_32 (c))
		end

	is_character (c: CHAR): BOOLEAN
		-- `True' if `target' consists exactly of one character `c'
		deferred
		ensure
			definition: Result implies target.count = 1 and then target.occurrences (to_character_32 (c)) = 1
		end

	is_i_th_alpha (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is alphabetical
		deferred
		end

	is_i_th_alpha_numeric (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is alphabetical or numeric
		deferred
		end

	is_i_th_identifier (a_area: like area; i: INTEGER): BOOLEAN
		-- `True' if i'th character in `a_area' is a code identifier character
		deferred
		end

	is_i_th_space (a_area: like area; i: INTEGER; unicode: EL_UNICODE_PROPERTY): BOOLEAN
		-- `True' if i'th character in `a_area'  is white space
		deferred
		end

	is_left_bracket (c: CHAR): BOOLEAN
		deferred
		end

	all_ascii_in_bounds (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if all characters in `a_area' from `i_lower' to `i_upper' are in the ASCII character range
		deferred
		end

	is_substring_c_identifier (a_area: like area; i_lower, i_upper: INTEGER): BOOLEAN
		-- `True' if characters in `a_area' from `i_lower' to `i_upper' constitute
		-- a C language identifier
		deferred
		end

	is_substring_eiffel_identifier (a_area: like area; i_lower, i_upper: INTEGER; case: NATURAL_8): BOOLEAN
		deferred
		end

feature {NONE} -- Deferred Conversion

	to_character_32 (c: CHAR): CHARACTER_32
		deferred
		end

	to_character_8 (c: CHAR): CHARACTER_8
		deferred
		end

	to_lower_case (c: CHAR): CHAR
		deferred
		end

	to_natural_32_code (c: CHAR): NATURAL
		deferred
		end

	to_upper_case (c: CHAR): CHAR
		deferred
		end

feature {NONE} -- Deferred

	area: SPECIAL [CHAR]
		deferred
		end

	new_readable: EL_EXTENDED_READABLE_STRING_I [COMPARABLE]
		deferred
		end

	new_shared_substring (str: like READABLE_X; start_index, end_index: INTEGER): like READABLE_X
		deferred
		end

	occurs_at (smaller: like READABLE_X; index: INTEGER): BOOLEAN
		-- `True' if `smaller' string occurs in `Current' at `index'
		deferred
		end

	occurs_caseless_at (smaller: like READABLE_X; index: INTEGER): BOOLEAN
		-- `True' if `smaller' string occurs in `big' string at `index' regardless of case
		deferred
		end

	other_area (other: like READABLE_X): like area
		deferred
		end

	other_index_lower (other: like READABLE_X): INTEGER
		deferred
		end

	shared_substring (a_target: IMMUTABLE_STRING_GENERAL; start_index, end_index: INTEGER_32): IMMUTABLE_STRING_GENERAL
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