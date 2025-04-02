note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-01 10:28:02 GMT (Tuesday 1st April 2025)"
	revision: "67"

class
	EL_STRING_32_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [STRING_32, READABLE_STRING_32, CHARACTER_32]
		rename
			shared_cursor_32 as cursor
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

	EL_STRING_32_CONSTANTS

	EL_SHARED_IMMUTABLE_32_MANAGER

feature -- Character query

	ends_with_character (s: STRING_32; c: CHARACTER_32): BOOLEAN
		local
			i: INTEGER
		do
			i := s.count
			Result := i > 0 and then s [i] = c
		end

	has_enclosing (s: READABLE_STRING_32; c_first, c_last: CHARACTER_32): BOOLEAN
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

	has_member (str: READABLE_STRING_32; set: EL_SET [CHARACTER_32]): BOOLEAN
		-- `True' if at least one character in `str' is a member of `set'
		local
			r: EL_CHARACTER_32_ROUTINES
		do
			if attached cursor (str) as c then
				Result := r.has_member (set, c.area, c.area_first_index, c.area_last_index)
			end
		end

	is_i_th_alpha (str: READABLE_STRING_32; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical
		do
			Result := str [i].is_alpha
		end

	is_i_th_alpha_numeric (str: READABLE_STRING_32; i: INTEGER): BOOLEAN
		-- `True' if i'th character is alphabetical or numeric
		do
			Result := str [i].is_alpha_numeric
		end

	is_i_th_identifier (str: READABLE_STRING_32; i: INTEGER): BOOLEAN
		local
			c: CHARACTER_32
		do
			c := str [i]
			Result := c.is_alpha_numeric or c = '_'
		end

	is_i_th_space (str: READABLE_STRING_32; i: INTEGER): BOOLEAN
		-- `True' if i'th character is white space
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_space (str [i])
		end

	is_subset_of (str: READABLE_STRING_32; set: EL_SET [CHARACTER_32]): BOOLEAN
		-- `True' if set of all characters in `str' is a subset of `set'
		local
			r: EL_CHARACTER_32_ROUTINES
		do
			if attached cursor (str) as c then
				Result := r.is_subset_of (set, c.area, c.area_first_index, c.area_last_index)
			end
		end

	starts_with_character (s: STRING_32; c: CHARACTER_32): BOOLEAN
		do
			Result := s.count > 0 and then s [1] = c
		end

feature -- Comparison

	ends_with (s, trailing: STRING_32): BOOLEAN
		do
			Result := s.ends_with (trailing)
		end

	occurs_at (big, small: STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

	same_string (a, b: READABLE_STRING_32): BOOLEAN
		do
			Result := EL_string_32.same_strings (a, b)
		end

	starts_with (s, leading: STRING_32): BOOLEAN
		do
			Result := s.starts_with (leading)
		end

feature -- Basic operations

	append_area_32 (str: STRING_32; area: SPECIAL [CHARACTER_32])
		local
			new_count: INTEGER
		do
			new_count := str.count + area.count
			str.grow (new_count)
			str.area.copy_data (area, 0, str.count, area.count)
			str.area [new_count] := '%U'
			str.set_count (new_count)
		end

	append_to (str: STRING_32; extra: READABLE_STRING_GENERAL)
		do
			if is_zstring (extra) then
				as_zstring (extra).append_to_string_32 (str)
			else
				str.append_string_general (extra)
			end
		end

	set_upper (str: STRING_32; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

feature -- Conversion

	to_code_array (s: STRING_32): ARRAY [NATURAL_32]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i)
				i := i + 1
			end
		end

feature -- Factory

	character_string (uc: CHARACTER_32): STRING_32
		-- shared instance of string with `uc' character
		do
			Result := Character_string_32_table.item (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): STRING_32
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_32_table.item (uc, n)
		end

	new_list (comma_separated: STRING_32): EL_STRING_32_LIST
		do
			create Result.make_comma_split (comma_separated)
		end

	shared_substring (s: STRING_32; new_count: INTEGER): STRING_32
		-- `s.substring (1, new_count)' with shared area
		do
			create Result.make (0)
			Result.share (s)
			Result.set_count (new_count)
		end

feature -- Adjust

	pruned (str: STRING_32; c: CHARACTER_32): STRING_32
		do
			create Result.make_from_string (str)
			Result.prune_all (c)
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	append_utf_8_to (utf_8: READABLE_STRING_8; output: STRING_32)
		local
			u8: EL_UTF_8_CONVERTER
		do
			u8.string_8_into_string_general (utf_8, output)
		end

	as_canonically_spaced (s: READABLE_STRING_32): STRING_32
		-- copy of `s' with each substring of whitespace consisting of one space character (ASCII 32)
		do
			create Result.make (s.count)
			Result.append (s)
		end

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_32; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string_32 (target, pattern, 0)
		end

	index_of (str: READABLE_STRING_32; uc: CHARACTER_32; start_index: INTEGER): INTEGER
		do
			Result := str.index_of (uc, start_index)
		end

	last_index_of (str: READABLE_STRING_32; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c, start_index_from_end)
		end

	new_shared_substring (s: READABLE_STRING_32; start_index, end_index: INTEGER): READABLE_STRING_32
		do
			Result := Immutable_32.shared_substring (s, start_index, end_index)
		end

	replace_substring (str: STRING_32; insert: READABLE_STRING_32; start_index, end_index: INTEGER)
		do
			str.replace_substring (insert, start_index, end_index)
		end

	split_on_character (str: READABLE_STRING_32; separator: CHARACTER_32): EL_SPLIT_ON_CHARACTER [READABLE_STRING_32]
		do
			if str.is_immutable then
				Result := Split_immutable_string_32
			else
				Result := Split_string_32
			end
			Result.set_target (str); Result.set_separator (separator)
		end

feature {NONE} -- Constants

	Asterisk: CHARACTER_32 = '*'

	Split_string_32: EL_SPLIT_ON_CHARACTER_32 [STRING_32]
		once
			create Result.make (Empty_string_32, '_')
		end

	Split_immutable_string_32: EL_SPLIT_IMMUTABLE_STRING_32_ON_CHARACTER
		once
			create Result.make (Empty_string_32, '_')
		end

	String_searcher: STRING_32_SEARCHER
		once
			Result := EL_string_32.string_searcher
		end

end