note
	description: "String 8 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-23 13:04:37 GMT (Monday 23rd November 2020)"
	revision: "9"

frozen class
	EL_STRING_8_ROUTINES

inherit
	EL_STRING_X_ROUTINES [STRING_8]
		rename
			replace_character as replace_character_32
		redefine
			replace_character_32
		end

feature -- Conversion

	to_code_array (s: STRING): ARRAY [NATURAL_8]
		local
			i: INTEGER
		do
			create Result.make_filled (0, 1, s.count)
			from i := 1 until i > s.count loop
				Result [i] := s.code (i).to_natural_8
				i := i + 1
			end
		end

	filtered (str: STRING; included: PREDICATE [CHARACTER]): STRING
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

	latin_1_count (s: READABLE_STRING_GENERAL): INTEGER
		-- count of latin-1 characters
		do
			Result := s.count
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