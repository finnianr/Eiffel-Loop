note
	description: "${EL_STRING_X_ROUTINES} implemented for ${READABLE_STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-30 10:16:25 GMT (Tuesday 30th January 2024)"
	revision: "48"

class
	EL_STRING_32_ROUTINES_IMP

inherit
	EL_STRING_X_ROUTINES [STRING_32, READABLE_STRING_32, CHARACTER_32]
		rename
			shared_cursor_32 as cursor
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [READABLE_STRING_32]

	EL_STRING_32_CONSTANTS

feature -- Status query

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

	has_only (str: READABLE_STRING_32; set: EL_SET [CHARACTER_32]): BOOLEAN
		-- `True' if `str' only has characters in `set'
		local
			r: EL_CHARACTER_32_ROUTINES
		do
			if attached cursor (str) as c then
				Result := r.has_only (set, c.area, c.area_first_index, c.area_last_index)
			end
		end

	is_identifier_character (str: READABLE_STRING_32; i: INTEGER): BOOLEAN
		local
			c: CHARACTER_32
		do
			c := str [i]
			Result := c.is_alpha_numeric or c = '_'
		end

feature -- Comparison

	occurs_at (big, small: READABLE_STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index'
		do
			Result := big.same_characters (small, 1, small.count, index)
		end

	occurs_caseless_at (big, small: READABLE_STRING_32; index: INTEGER): BOOLEAN
		-- `True' if `small' string occurs in `big' string at `index' regardless of case
		do
			Result := big.same_caseless_characters (small, 1, small.count, index)
		end

	same_strings (a, b: READABLE_STRING_32): BOOLEAN
		do
			Result := EL_string_32.same_strings (a, b)
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
			inspect Class_id.character_bytes (extra)
				when 'X' then
					if attached {ZSTRING} extra as zstr then
						zstr.append_to_string_32 (str)
					end
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

	to_utf_8 (str: READABLE_STRING_32): STRING
		do
			if attached cursor (str) as c then
				create Result.make (c.utf_8_byte_count)
				c.append_to_utf_8 (Result)
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

	new_list (n: INTEGER): EL_STRING_32_LIST
		do
			create Result.make (n)
		end

	shared_substring (s: STRING_32; new_count: INTEGER): STRING_32
		-- `s.substring (1, new_count)' with shared area
		do
			create Result.make (0)
			Result.share (s)
			Result.set_count (new_count)
		end

feature -- Adjust

	left_adjust (str: STRING_32)
		do
			str.left_adjust
		end

	pruned (str: STRING_32; c: CHARACTER_32): STRING_32
		do
			create Result.make_from_string (str)
			Result.prune_all (c)
		end

	prune_all_leading (str: STRING_32; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	right_adjust (str: STRING_32)
		do
			str.right_adjust
		end

	wipe_out (str: STRING_32)
		do
			str.wipe_out
		end

feature {NONE} -- Implementation

	last_index_of (str: READABLE_STRING_32; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c, start_index_from_end)
		end

	replace_substring (str: STRING_32; insert: READABLE_STRING_32; start_index, end_index: INTEGER)
		do
			str.replace_substring (insert, start_index, end_index)
		end

feature {NONE} -- Constants

	Split_on_character: EL_SPLIT_ON_CHARACTER_32 [STRING_32]
		once
			create Result.make (Empty_string_32, '_')
		end

	String_searcher: STRING_32_SEARCHER
		once
			Result := EL_string_32.string_searcher
		end

end