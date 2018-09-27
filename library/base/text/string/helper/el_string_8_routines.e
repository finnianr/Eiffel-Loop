note
	description: "String 8 routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_STRING_8_ROUTINES

inherit
	EL_STRING_X_ROUTINES [STRING_8]

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

feature -- Measurement

	latin_1_count (s: READABLE_STRING_GENERAL): INTEGER
		-- count of latin-1 characters
		do
			Result := s.count
		end

feature -- Transformation

	prune_all_leading (str: STRING_8; c: CHARACTER_32)
		do
			str.prune_all_leading (c.to_character_8)
		end
end
