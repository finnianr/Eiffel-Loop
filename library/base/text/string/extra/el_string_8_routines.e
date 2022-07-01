note
	description: "String 8 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-01 10:02:58 GMT (Friday 1st July 2022)"
	revision: "34"

expanded class
	EL_STRING_8_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_X_ROUTINES [STRING_8, READABLE_STRING_8]
		rename
			replace_character as replace_character_32
		redefine
			replace_character_32
		end

	EL_SHARED_STRING_8_CURSOR
		rename
			cursor_8 as cursor
		end

feature -- Basic operations

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

	is_identifier_character (str: READABLE_STRING_8; i: INTEGER): BOOLEAN
		local
			c: CHARACTER
		do
			c := str [i]
			Result := c.is_alpha_numeric or else c = '_'
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

feature -- Character strings

	character_string (c: CHARACTER): STRING
		-- shared instance of string with `uc' character
		do
			Result := n_character_string (c, 1)
		end

	n_character_string (c: CHARACTER; n: INTEGER): STRING
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_table.item (c, n)
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

feature -- Transformation

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

	right_adjust (str: STRING_8)
		do
			str.right_adjust
		end

feature {NONE} -- Implementation

	last_index_of (str: READABLE_STRING_8; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c.to_character_8, start_index_from_end)
		end

feature {NONE} -- Constants

	Character_string_table: EL_FILLED_STRING_8_TABLE
		once
			create Result.make
		end

end