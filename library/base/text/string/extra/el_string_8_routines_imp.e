note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-03 7:34:42 GMT (Monday 3rd June 2024)"
	revision: "24"

class
	EL_STRING_8_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [STRING_8, READABLE_STRING_8, CHARACTER_8]
		rename
			shared_cursor_8 as cursor,
			replace_character as replace_character_32,
			character_string as character_32_string,
			n_character_string as n_character_32_string
		undefine
			bit_count
		redefine
			replace_character_32, is_character
		end

	EL_STRING_8_BIT_COUNTABLE [READABLE_STRING_8]

	EL_SHARED_IMMUTABLE_8_MANAGER

	EL_STRING_8_CONSTANTS

feature -- Basic operations

	append_area_32 (str: STRING_8; area_32: SPECIAL [CHARACTER_32])
		local
			i, i_final, offset, new_count: INTEGER; area: SPECIAL [CHARACTER_8]
			uc: CHARACTER_32
		do
			new_count := str.count + area_32.count
			offset := str.count
			str.grow (new_count)
			area := str.area
			i_final := area_32.count
			from i := 0 until i = i_final loop
				uc := area_32 [i]
				if uc.is_character_8 then
					area [i + offset] := uc.to_character_8
				else
					area [i + offset] := '%/26/'
				end
				i := i + 1
			end
			area [new_count] := '%U'
			str.set_count (new_count)
		end

	append_to (str: STRING_8; extra: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} extra as zstr then
				zstr.append_to_string_8 (str)
			else
				str.append_string_general (extra)
			end
		end

	set_upper (str: STRING_8; i: INTEGER)
		do
			str.put (str [i].upper, i)
		end

feature -- Status query

	ends_with_character (s: READABLE_STRING_8; c: CHARACTER): BOOLEAN
		local
			i: INTEGER
		do
			i := s.count
			Result := i > 0 and then s [i] = c
		end

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

	is_character (str: STRING; uc: CHARACTER_32): BOOLEAN
		-- `True' if `str.same_string (uc.out)' is true
		do
			Result := str.count = 1 and then str [1] = uc
		end

	is_identifier_character (str: READABLE_STRING_8; i: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			c := str [i]
			Result := c.is_alpha_numeric or else c = '_'
		end

	is_subset_of (str: READABLE_STRING_8; set: EL_SET [CHARACTER_8]): BOOLEAN
		-- `True' if set of all characters in `str' is a subset of `set'
		local
			r: EL_CHARACTER_8_ROUTINES
		do
			if attached cursor (str) as c then
				Result := r.is_subset_of (set, c.area, c.area_first_index, c.area_last_index)
			end
		end

	matches_wildcard (s, wildcard: READABLE_STRING_8): BOOLEAN
		local
			any_ending, any_start: BOOLEAN; start_index, end_index: INTEGER
			search_string: IMMUTABLE_STRING_8
		do
			start_index := 1; end_index := wildcard.count
			if ends_with_character (wildcard, '*')  then
				end_index := end_index - 1
				any_ending := True
			end
			if starts_with_character (wildcard, '*') then
				start_index := start_index + 1
				any_start := True
			end
			search_string := Immutable_8.shared_substring (wildcard, start_index, end_index)

			if any_ending and any_start then
				Result := s.has_substring (search_string)

			elseif any_ending then
				Result := s.starts_with (search_string)

			elseif any_start then
				Result := s.ends_with (search_string)
			else
				Result := s.same_string (wildcard)
			end
		end

	starts_with_character (s: READABLE_STRING_8; c: CHARACTER): BOOLEAN
		do
			Result := s.count > 0 and then s [1] = c
		end

feature -- Comparison

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

	same_strings (a, b: READABLE_STRING_8): BOOLEAN
		do
			Result := EL_string_8.same_strings (a, b)
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

	replace_character (target: STRING_8; a_old, a_new: CHARACTER)
		local
			i, i_final: INTEGER; area: SPECIAL [CHARACTER]
		do
			area := target.area; i_final := target.count
			from i := 0 until i = i_final loop
				if area [i] = a_old then
					area [i] := a_new
				end
				i := i + 1
			end
		end

	replace_character_32 (target: STRING_8; a_old, a_new: CHARACTER_32)
		require else
			are_character_8: a_old.is_character_8 and a_new.is_character_8
		do
			if a_old.is_character_8 and a_new.is_character_8 then
				replace_character (target, a_old.to_character_8, a_new.to_character_8)
			end
		end

feature -- Adjust

	left_adjust (str: STRING_8)
		do
			str.left_adjust
		end

	prune_all_leading (str: STRING_8; c: CHARACTER_32)
		do
			str.prune_all_leading (c.to_character_8)
		end

	pruned (str: STRING_8; c: CHARACTER_32): STRING_8
		do
			create Result.make_from_string (str)
			if c.is_character_8 then
				Result.prune_all (c.to_character_8)
			end
		end

	right_adjust (str: STRING_8)
		do
			str.right_adjust
		end

	wipe_out (str: STRING_8)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	fill_intervals (intervals: EL_OCCURRENCE_INTERVALS; target: READABLE_STRING_8; pattern: READABLE_STRING_GENERAL)
		do
			intervals.fill_by_string_8 (target, pattern, 0)
		end

	last_index_of (str: READABLE_STRING_8; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c.to_character_8, start_index_from_end)
		end

	replace_substring (str: STRING_8; insert: READABLE_STRING_8; start_index, end_index: INTEGER)
		do
			str.replace_substring (insert, start_index, end_index)
		end

feature {NONE} -- Constants

	Split_on_character: EL_SPLIT_ON_CHARACTER_8 [STRING_8]
		once
			create Result.make (Empty_string_8, '_')
		end

	String_searcher: STRING_8_SEARCHER
		once
			Result := EL_string_8.string_searcher
		end

end