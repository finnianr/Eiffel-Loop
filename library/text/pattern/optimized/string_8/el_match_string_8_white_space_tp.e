note
	description: "[$source EL_MATCH_WHITE_SPACE_TP] optimized for string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 11:44:13 GMT (Tuesday 1st November 2022)"
	revision: "3"

class
	EL_MATCH_STRING_8_WHITE_SPACE_TP

inherit
	EL_MATCH_WHITE_SPACE_TP
		redefine
			i_th_has, i_th_type
		end

create
	make

feature {NONE} -- Implementation

	i_th_type (i: INTEGER_32; text: READABLE_STRING_8): INTEGER
		local
			c: CHARACTER_8
		do
			c := text [i]
			if c.is_space then
				if c = '%N' or c = '%R' then
					Result := Breaking_space
				else
					Result := Nonbreaking_space
				end
			end
		end

	i_th_has (i: INTEGER_32; text: READABLE_STRING_8): BOOLEAN
			-- `True' if i'th character is white space
		do
			Result := text [i].is_space
		end

end