note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-09 14:09:25 GMT (Wednesday 9th April 2025)"
	revision: "43"

class
	EL_STRING_8_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [STRING_8, READABLE_STRING_8, CHARACTER_8]
		rename
			character_string as character_32_string,
			n_character_string as n_character_32_string,
			super_readable_8 as extended_string
		undefine
			bit_count
		redefine
			is_character
		end

	EL_STRING_8_BIT_COUNTABLE [READABLE_STRING_8]

	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_STRING_8_CONSTANTS

feature -- Basic operations

	append_to (str: STRING_8; extra: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} extra as zstr then
				zstr.append_to_string_8 (str)
			else
				str.append_string_general (extra)
			end
		end

	set_lower (str: STRING_8; i: INTEGER)
		do
			str.put (str [i].lower, i)
		end

	set_upper (str: STRING_8; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

	set_substring_lower (str: STRING_8; start_index, end_index: INTEGER)
		do
			set_substring_case (str, start_index, end_index, {EL_CASE}.Lower)
		end

	set_substring_upper (str: STRING_8; start_index, end_index: INTEGER)
		do
			set_substring_case (str, start_index, end_index, {EL_CASE}.Upper)
		end

feature -- Character query

	has_enclosing (s: READABLE_STRING_8; c_first, c_last: CHARACTER_32): BOOLEAN
			--
		local
			upper: INTEGER
		do
			upper := s.count
			inspect upper
				when 0, 1 then
					do_nothing
			else
				Result := s [1] = c_first and then s [upper] = c_last
			end
		end

	is_character (str: READABLE_STRING_8; uc: CHARACTER_32): BOOLEAN
		-- `True' if `str.same_string (uc.out)' is true
		do
			Result := str.count = 1 and then str [1] = uc
		end

	is_subset_of (str: READABLE_STRING_8; set: EL_SET [CHARACTER_8]): BOOLEAN
		-- `True' if set of all characters in `str' is a subset of `set'
		local
			c: EL_CHARACTER_8_ROUTINES
		do
			if attached extended_string (str) as s then
				Result := c.is_subset_of (set, s.area, s.index_lower, s.index_upper)
			end
		end

feature -- Comparison

	ends_with (s, trailing: READABLE_STRING_8): BOOLEAN
		do
			Result := s.ends_with (trailing)
		end

	occurs_at (big, small: READABLE_STRING_8; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: READABLE_STRING_8; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

	same_string (a, b: READABLE_STRING_8): BOOLEAN
		do
			Result := EL_string_8.same_strings (a, b)
		end

	starts_with (s, leading: READABLE_STRING_8): BOOLEAN
		do
			Result := s.starts_with (leading)
		end

feature -- Conversion

	bitmap (n, digit_count: INTEGER): STRING
		-- right most `digit_count' binary digits of `n'
		local
			i, mask: INTEGER
		do
			create Result.make_filled ('0', digit_count)
			from i := 1 until i > digit_count loop
				mask := 1 |<< (digit_count - i)
				if (n & mask).to_boolean then
					Result [i] := '1'
				end
				i := i + 1
			end
		end

	from_code_array (array: SPECIAL [NATURAL_8]): STRING_8
		local
			i: INTEGER; area: SPECIAL [CHARACTER]
		do
			create Result.make_filled ('%U', array.count)
			area := Result.area
			from i := 0 until i = array.count loop
				area [i] := array [i].to_character_8
				i := i + 1
			end
		end

	to_code_array (s: STRING_8): SPECIAL [NATURAL_8]
		local
			i, i_final: INTEGER; area: SPECIAL [CHARACTER]
		do
			area := s.area; i_final := s.count
			create Result.make_empty (i_final)
			from i := 0 until i = i_final loop
				Result.extend (area [i].natural_32_code.to_natural_8)
				i := i + 1
			end
		end

feature -- Factory

	character_string (c: CHARACTER): STRING_8
		-- shared instance of string with `uc' character
		do
			Result := Character_string_8_table.item (c, 1)
		end

	n_character_string (c: CHARACTER; n: INTEGER): STRING_8
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_8_table.item (c, n)
		end

	character_32_string (uc: CHARACTER_32): STRING_8
		-- shared instance of string with `uc' character
		do
			Result := character_string (uc.to_character_8)
		end

	n_character_32_string (uc: CHARACTER_32; n: INTEGER): STRING_8
		-- shared instance of string with `n' times `uc' character
		do
			Result := n_character_string (uc.to_character_8, n)
		end

	new_list (comma_separated: STRING_8): EL_STRING_8_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

	new_line_list (str: STRING_8): EL_STRING_8_LIST
		-- lit of
		do
			create Result.make_split (str, '%N')
		end

	shared_substring (s: STRING_8; new_count: INTEGER): STRING_8
		-- `s.substring (1, new_count)' with shared area
		do
			create Result.make (0)
			Result.share (s)
			Result.set_count (new_count)
		end

feature -- Measurement

	leading_string_count (s: STRING; space_count: INTEGER): INTEGER
		-- count of leading characters up to `space_count' number of spaces counting from end
		local
			i, count: INTEGER
		do
			from i := s.count until count = space_count or else i = 0 loop
				if s [i].is_space then
					count := count + 1
				end
				i := i - 1
			end
			Result := i
		end

	leading_space_count (str: READABLE_STRING_8): INTEGER
		-- count of leading space characters in `str'
		local
			i: INTEGER
		do
			from i := 1 until i > str.count loop
				if str [i].is_space then
					Result := Result + 1
				else
					i := str.count
				end
				i := i + 1
			end
		end

feature -- Transform

	replace_set_members (target: STRING_8; set: EL_SET [CHARACTER_8]; a_new: CHARACTER_8)
		-- Replace all characters that are member of `set' with the `a_new' character
		local
			i, l_count: INTEGER; c_i: CHARACTER_8
		do
			l_count := target.count
			if attached target.area as l_area then
				from i := 0 until i = l_count loop
					c_i := l_area [i]
					if set.has (c_i) then
						l_area [i] := a_new
					end
					i := i + 1
				end
			end
			target.set_count (l_count) -- reset `internal_hash_code' to 0
		end

feature -- Adjust

	pruned (str: STRING_8; c: CHARACTER_32): STRING_8
		do
			create Result.make_from_string (str)
			if c.is_character_8 then
				Result.prune_all (c.to_character_8)
			end
		end

	wipe_out (str: STRING_8)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	append_utf_8_to (utf_8: READABLE_STRING_8; output: STRING_8)
		local
			u8: EL_UTF_8_CONVERTER
		do
			u8.string_8_into_string_general (utf_8, output)
		end

	as_canonically_spaced (s: READABLE_STRING_8): STRING_8
		-- copy of `s' with each substring of whitespace consisting of one space character (ASCII 32)
		do
			create Result.make (s.count)
			Result.append (s)
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_8; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string_8 (target, pattern, 0)
		end

	index_of (str: READABLE_STRING_8; uc: CHARACTER_32; start_index: INTEGER): INTEGER
		do
			if uc.is_character_8 then
				Result := str.index_of (uc.to_character_8, start_index)
			end
		end

	last_index_of (str: READABLE_STRING_8; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c.to_character_8, start_index_from_end)
		end

	is_i_th_alpha (str: READABLE_STRING_8; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical
		do
			Result := str [i].is_alpha
		end

	is_i_th_alpha_numeric (str: READABLE_STRING_8; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical or numeric
		do
			Result := str [i].is_alpha_numeric
		end

	is_i_th_identifier (str: READABLE_STRING_8; i: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			c := str [i]
			Result := c.is_alpha_numeric or else c = '_'
		end

	is_i_th_space (str: READABLE_STRING_8; i: INTEGER): BOOLEAN
		-- `True' if i'th character is white space
		do
			Result := str [i].is_space
		end

	new_shared_substring (s: READABLE_STRING_8; start_index, end_index: INTEGER): READABLE_STRING_8
		do
			Result := Immutable_8.shared_substring (s, start_index, end_index)
		end

	replace_substring (str: STRING_8; insert: READABLE_STRING_8; start_index, end_index: INTEGER)
		do
			str.replace_substring (insert, start_index, end_index)
		end

	split_on_character (str: READABLE_STRING_8; separator: CHARACTER_32): EL_SPLIT_ON_CHARACTER [READABLE_STRING_8]
		do
			if str.is_immutable then
				Result := Split_immutable_string_8
			else
				Result := Split_string_8
			end
			Result.set_target (str); Result.set_separator (separator)
		end

	set_substring_case (str: STRING_8; start_index, end_index: INTEGER; case: NATURAL_8)
		require
			valid_case: is_valid_case (case)
			valid_indices: valid_substring_indices (str, start_index, end_index)
		local
			i: INTEGER
		do
			from i := start_index until i > end_index loop
				inspect case
					when {EL_CASE}.Lower then
						set_lower (str, i)

					when {EL_CASE}.Upper then
						set_upper (str, i)
				else
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Asterisk: CHARACTER_8 = '*'

	Split_string_8: EL_SPLIT_ON_CHARACTER_8 [STRING_8]
		once
			create Result.make (Empty_string_8, '_')
		end

	Split_immutable_string_8: EL_SPLIT_IMMUTABLE_STRING_8_ON_CHARACTER
		once
			create Result.make (Empty_string_8, '_')
		end

	String_searcher: STRING_8_SEARCHER
		once
			Result := EL_string_8.string_searcher
		end

end