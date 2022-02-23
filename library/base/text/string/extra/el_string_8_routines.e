note
	description: "String 8 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-23 11:15:46 GMT (Wednesday 23rd February 2022)"
	revision: "29"

expanded class
	EL_STRING_8_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

	EL_STRING_X_ROUTINES [STRING_8]
		rename
			replace_character as replace_character_32
		redefine
			is_eiffel_identifier, replace_character_32
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

	is_eiffel_identifier_lower (s: STRING_8): BOOLEAN
		do
			Result := is_area_eiffel_identifier (s.area, s.count, True)
		end

	is_eiffel_identifier (s: STRING_8): BOOLEAN
		do
			Result := is_area_eiffel_identifier (s.area, s.count, False)
		end

	is_ascii (str: READABLE_STRING_8): BOOLEAN
		-- `True' if all characters in `str' are in the ASCII character set: 0 .. 127
		local
			c_8: EL_CHARACTER_8_ROUTINES
		do
			if attached cursor (str) as c then
				Result := c_8.is_ascii_area (c.area, c.area_first_index, c.area_last_index)
			end
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

	cursor (s: READABLE_STRING_8): EL_STRING_8_ITERATION_CURSOR
		do
			Result := Once_cursor
			Result.make (s)
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

	filtered (str: STRING_8; included: PREDICATE [CHARACTER]): STRING
		local
			i: INTEGER; c: CHARACTER
		do
			create Result.make (str.count)
			from i := 1 until i > str.count loop
				c := str [i]
				if included (c) then
					Result.extend (c)
				end
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

	latin_1_count (s: STRING_8): INTEGER
		-- count of latin-1 characters
		do
			Result := s.count
		end

	leading_occurences (s: READABLE_STRING_8; uc: CHARACTER_32): INTEGER
		local
			i, l_count, offset: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			l_count := s.count
			if attached cursor (s) as c then
				l_area := c.area
				offset := c.area_first_index
			end
			from until i = l_count or else l_area.item (i + offset).to_character_32 /= uc loop
				i := i + 1
			end
			Result := i
		end

	leading_white_count (s: READABLE_STRING_8): INTEGER
		local
			i, l_count, offset: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			l_count := s.count
			if attached cursor (s) as c then
				l_area := c.area
				offset := c.area_first_index
			end
			from until i = l_count or else not l_area.item (i + offset).is_space loop
				i := i + 1
			end
			Result := i
		end

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

	trailing_white_count (s: READABLE_STRING_8): INTEGER
		local
			i, nb, offset: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			nb := s.count - 1
			if attached cursor (s) as c then
				l_area := c.area
				offset := c.area_first_index
			end
			from i := nb until i < 0 or else not l_area.item (i + offset).is_space loop
				Result := Result + 1
				i := i - 1
			end
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

	last_index_of (str: STRING_8; c: CHARACTER_32; start_index_from_end: INTEGER): INTEGER
		do
			Result := str.last_index_of (c.to_character_8, start_index_from_end)
		end

	is_area_eiffel_identifier (area: SPECIAL [CHARACTER]; count: INTEGER; lower_case: BOOLEAN): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := 0 until i = count or not Result loop
				inspect area [i]
					when 'A' .. 'Z' then
						if lower_case then
							Result := False
						else
							Result := i = 0 implies area [0].is_alpha
						end

					when 'a' .. 'z', '0' .. '9', '_' then
						Result := i = 0 implies area [0].is_alpha
				else
					Result := False
				end
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Character_string_table: EL_FILLED_STRING_8_TABLE
		once
			create Result.make
		end

	Once_cursor: EL_STRING_8_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end