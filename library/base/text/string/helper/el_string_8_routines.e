note
	description: "String 8 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-31 9:51:54 GMT (Thursday 31st December 2020)"
	revision: "11"

frozen class
	EL_STRING_8_ROUTINES

inherit
	EL_STRING_X_ROUTINES [STRING_8]
		rename
			replace_character as replace_character_32
		redefine
			is_eiffel_identifier, replace_character_32
		end

feature -- Status query

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

feature -- Conversion

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

feature -- Measurement

	latin_1_count (s: STRING_8): INTEGER
		-- count of latin-1 characters
		do
			Result := s.count
		end

	left_white_count (s: STRING_8): INTEGER
		local
			i, l_count: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			l_count := s.count; l_area := s.area
			from until i = l_count or else not l_area.item (i).is_space loop
				i := i + 1
			end
			Result := i
		end

	right_white_count (s: STRING_8): INTEGER
		local
			i, nb: INTEGER; l_area: SPECIAL [CHARACTER_8]
		do
			from
				nb := s.count - 1
				i := nb
				l_area := s.area
			until
				i < 0 or else not l_area.item (i).is_space
			loop
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
			i, n: INTEGER; area: SPECIAL [CHARACTER]
		do
			area := target.area; n := target.count
			from i := 0 until i = n loop
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

end