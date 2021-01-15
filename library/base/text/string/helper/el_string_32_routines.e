note
	description: "String 32 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-15 16:08:16 GMT (Friday 15th January 2021)"
	revision: "19"

expanded class
	EL_STRING_32_ROUTINES

inherit
	EL_STRING_X_ROUTINES [STRING_32]

feature -- Status query

	is_convertible (s: STRING_32; basic_type: TYPE [ANY]): BOOLEAN
		-- `True' if `str' is convertible to type `basic_type'
		local
			convertible: PREDICATE [STRING_32]
		do
			if Conversion_table.has_key (basic_type) then
				convertible := Conversion_table.found_item.is_convertible
				Result := convertible (s)
			end
		end

	is_character_32 (str: STRING_32): BOOLEAN
		do
			Result := str.count = 1
		end

	is_character_8 (str: STRING_32): BOOLEAN
		do
			Result := str.count = 1 and then str.code (1) <= 0xFF
		end

feature -- Basic operations

	append_to (str: STRING_32; extra: READABLE_STRING_GENERAL)
		do
			if attached {ZSTRING} extra as zstr then
				zstr.append_to_string_32 (str)
			else
				str.append_string_general (extra)
			end
		end

feature -- Conversion

	cursor (s: READABLE_STRING_32): EL_STRING_32_ITERATION_CURSOR
		do
			Result := Once_cursor
			Result.make (s)
		end

	from_general (str: READABLE_STRING_GENERAL; keep_ref: BOOLEAN): STRING_32
		local
			buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			if attached {STRING_32} str as str_32 then
				Result := str_32
			else
				Result := buffer.copied_general (str)
				if keep_ref then
					Result := Result.twin
				end
			end
		end

	to_character_32 (str: STRING_32): CHARACTER_32
		do
			if is_character_32 (str) then
				Result := str.item (1)
			end
		end

	to_character_8 (str: STRING_32): CHARACTER_8
		do
			if is_character_8 (str) then
				Result := str.item (1).to_character_8
			end
		end

	to_code_array (s: STRING_32): ARRAY [NATURAL_32]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

	to_type (str: STRING_32; basic_type: TYPE [ANY]): ANY
		-- `str' converted to type `basic_type'
		local
			to_basic_type: FUNCTION [STRING_32, ANY]
		do
			if Conversion_table.has_key (basic_type) then
				to_basic_type := Conversion_table.found_item.to_type
				Result := to_basic_type (str)
			else
				create Result
			end
		end

	to_utf_8 (str: READABLE_STRING_32; keep_ref: BOOLEAN): STRING
		local
			c: EL_UTF_CONVERTER; buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			Result := buffer.empty
			c.utf_32_string_into_utf_8_string_8 (str, Result)
			if keep_ref then
				Result := Result.twin
			end
		end

feature -- Measurement

	latin_1_count (s: STRING_32): INTEGER
		-- count of latin-1 characters
		local
			i, count: INTEGER; area: SPECIAL [CHARACTER_32]
		do
			area := s.area; count := s.count
			from i := 0 until i = count loop
				if area.item (i).natural_32_code <= 0xFF then
					Result := Result + 1
				end
				i := i + 1
			end
		end

	leading_occurences (s: READABLE_STRING_32; uc: CHARACTER_32): INTEGER
		local
			i, l_count, offset: INTEGER; l_area: SPECIAL [CHARACTER_32]
		do
			l_count := s.count
			if attached cursor (s) as c then
				l_area := c.area
				offset := c.area_first_index
			end
			from until i = l_count or else l_area.item (i + offset) /= uc loop
				i := i + 1
			end
			Result := i
		end

	leading_white_count (s: STRING_32): INTEGER
		local
			i, l_count: INTEGER; l_area: SPECIAL [CHARACTER_32]
			p: like Character_properties
		do
			p := Character_properties; l_count := s.count; l_area := s.area
			from until i = l_count or else not p.is_space (l_area.item (i)) loop
				i := i + 1
			end
			Result := i
		end

	trailing_white_count (s: STRING_32): INTEGER
		local
			i, nb: INTEGER; l_area: SPECIAL [CHARACTER_32]
			p: like Character_properties
		do
			p := Character_properties; l_area := s.area
			from
				nb := s.count - 1; i := nb
			until
				i < 0 or else not p.is_space (l_area.item (i))
			loop
				Result := Result + 1
				i := i - 1
			end
		end

feature -- Character strings

	character_string (uc: CHARACTER_32): STRING_32
		-- shared instance of string with `uc' character
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): STRING_32
		-- shared instance of string with `n' times `uc' character
		do
			Result := Character_string_table.item (n.to_natural_64 |<< 32 | uc.natural_32_code)
		end

feature {NONE} -- Implementation

	new_filled_string (key: NATURAL_64): STRING_32
		do
			create Result.make_filled (key.to_character_32, (key |>> 32).to_integer_32)
		end

feature -- Transformation

	left_adjust (str: STRING_32)
		do
			str.left_adjust
		end

	prune_all_leading (str: STRING_32; c: CHARACTER_32)
		do
			str.prune_all_leading (c)
		end

	right_adjust (str: STRING_32)
		do
			str.right_adjust
		end

feature {NONE} -- Constants

	Character_properties: CHARACTER_PROPERTY
			-- Access to Unicode character properties
		once
			create Result.make
		end

feature {NONE} -- Constants

	Character_string_table: EL_CACHE_TABLE [STRING_32, NATURAL_64]
		once
			create Result.make_equal (7, agent new_filled_string)
		end

	Conversion_table: EL_HASH_TABLE [
		TUPLE [is_convertible: PREDICATE [STRING_32]; to_type: FUNCTION [STRING_32, ANY]],
		TYPE [ANY] -- basic type lookup key
	]
		-- string conversion predicates and conversion function
		once
			create Result.make (<<
				[{BOOLEAN},			[agent {STRING_32}.is_boolean, agent {STRING_32}.to_boolean]],

				[{CHARACTER_8},	[agent is_character_8, agent to_character_8]],
				[{CHARACTER_32},	[agent is_character_32, agent to_character_32]],

				[{INTEGER_8},		[agent {STRING_32}.is_integer_8, agent {STRING_32}.to_integer_8]],
				[{INTEGER_16}, 	[agent {STRING_32}.is_integer_16, agent {STRING_32}.to_integer_16]],
				[{INTEGER_32},		[agent {STRING_32}.is_integer_32, agent {STRING_32}.to_integer_32]],
				[{INTEGER_64},		[agent {STRING_32}.is_integer_64, agent {STRING_32}.to_integer_64]],

				[{NATURAL_8},		[agent {STRING_32}.is_natural_8, agent {STRING_32}.to_natural_8]],
				[{NATURAL_16},		[agent {STRING_32}.is_natural_16, agent {STRING_32}.to_natural_16]],
				[{NATURAL_32},		[agent {STRING_32}.is_natural_32, agent {STRING_32}.to_natural_32]],
				[{NATURAL_64},		[agent {STRING_32}.is_natural_64, agent {STRING_32}.to_natural_64]],

				[{DOUBLE},			[agent {STRING_32}.is_double, agent {STRING_32}.to_double]],
				[{REAL},				[agent {STRING_32}.is_real, agent {STRING_32}.to_real]]
			>>)
		end

	Once_cursor: EL_STRING_32_ITERATION_CURSOR
		once
			create Result.make_empty
		end
end