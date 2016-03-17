note
	description: "Summary description for {EL_STRING_8_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 23:24:31 GMT (Friday 18th December 2015)"
	revision: "4"

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

feature -- Transformation

	prune_all_leading (str: STRING_8; c: CHARACTER_32)
		do
			str.prune_all_leading (c.to_character_8)
		end
end
