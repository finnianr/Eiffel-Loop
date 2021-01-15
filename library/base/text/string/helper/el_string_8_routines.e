note
	description: "String 8 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-15 16:08:27 GMT (Friday 15th January 2021)"
	revision: "18"

expanded class
	EL_STRING_8_ROUTINES

inherit
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

feature -- Status query

	is_convertible (s: STRING_8; basic_type: TYPE [ANY]): BOOLEAN
		-- `True' if `str' is convertible to type `basic_type'
		local
			convertible: PREDICATE [STRING_8]
		do
			if Conversion_table.has_key (basic_type) then
				convertible := Conversion_table.found_item.is_convertible
				Result := convertible (s)
			end
		end

	is_eiffel_identifier (s: STRING_8): BOOLEAN
		local
			i: INTEGER
		do
			Result := True
			from i := 1 until i > s.count or not Result loop
				inspect s [i]
					when 'a' .. 'z', 'A' .. 'Z', '0' .. '9', '_' then
						Result := i = 1 implies s.item (1).is_alpha
				else
					Result := False
				end
				i := i + 1
			end
		end

	is_character_32 (str: STRING_8): BOOLEAN
		do
			Result := str.count = 1
		end

	is_character_8 (str: STRING_8): BOOLEAN
		do
			Result := str.count = 1 and then str.item (1) <= '%/0xFF/'
		end

feature -- Conversion

	cursor (s: READABLE_STRING_8): EL_STRING_8_ITERATION_CURSOR
		do
			Result := Once_cursor
			Result.make (s)
		end

	to_character_32 (str: STRING_8): CHARACTER_32
		do
			if is_character_32 (str) then
				Result := str.item (1)
			end
		end

	to_character_8 (str: STRING_8): CHARACTER_8
		do
			if is_character_8 (str) then
				Result := str.item (1).to_character_8
			end
		end

	to_code_array (s: STRING_8): ARRAY [NATURAL_8]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

	to_type (str: STRING_8; basic_type: TYPE [ANY]): ANY
		-- `str' converted to type `basic_type'
		local
			to_basic_type: FUNCTION [STRING_8, ANY]
		do
			if Conversion_table.has_key (basic_type) then
				to_basic_type := Conversion_table.found_item.to_type
				Result := to_basic_type (str)
			else
				create Result
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
			Result := Character_string_table.item (n.to_natural_32 |<< 8 | c.natural_32_code)
		end

feature {NONE} -- Implemenation

	new_filled_string (key: NATURAL): STRING
		do
			create Result.make_filled (key.to_character_8, (key |>> 8).to_integer_32)
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

feature {NONE} -- Constants

	Character_string_table: EL_CACHE_TABLE [STRING, NATURAL]
		once
			create Result.make_equal (7, agent new_filled_string)
		end

	Once_cursor: EL_STRING_8_ITERATION_CURSOR
		once
			create Result.make_empty
		end

feature {NONE} -- Constants

	Conversion_table: EL_HASH_TABLE [
		TUPLE [is_convertible: PREDICATE [STRING_8]; to_type: FUNCTION [STRING_8, ANY]],
		TYPE [ANY] -- basic type lookup key
	]
		-- string conversion predicates and conversion function
		once
			create Result.make (<<
				[{BOOLEAN},			[agent {STRING_8}.is_boolean, agent {STRING_8}.to_boolean]],

				[{CHARACTER_8},	[agent is_character_8, agent to_character_8]],
				[{CHARACTER_32},	[agent is_character_32, agent to_character_32]],

				[{INTEGER_8},		[agent {STRING_8}.is_integer_8, agent {STRING_8}.to_integer_8]],
				[{INTEGER_16}, 	[agent {STRING_8}.is_integer_16, agent {STRING_8}.to_integer_16]],
				[{INTEGER_32},		[agent {STRING_8}.is_integer_32, agent {STRING_8}.to_integer_32]],
				[{INTEGER_64},		[agent {STRING_8}.is_integer_64, agent {STRING_8}.to_integer_64]],

				[{NATURAL_8},		[agent {STRING_8}.is_natural_8, agent {STRING_8}.to_natural_8]],
				[{NATURAL_16},		[agent {STRING_8}.is_natural_16, agent {STRING_8}.to_natural_16]],
				[{NATURAL_32},		[agent {STRING_8}.is_natural_32, agent {STRING_8}.to_natural_32]],
				[{NATURAL_64},		[agent {STRING_8}.is_natural_64, agent {STRING_8}.to_natural_64]],

				[{DOUBLE},			[agent {STRING_8}.is_double, agent {STRING_8}.to_double]],
				[{REAL},				[agent {STRING_8}.is_real, agent {STRING_8}.to_real]]
			>>)
		end

end