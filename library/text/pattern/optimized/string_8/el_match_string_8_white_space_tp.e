note
	description: "[$source EL_MATCH_WHITE_SPACE_TP] optimized for string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_STRING_8_WHITE_SPACE_TP

inherit
	EL_MATCH_WHITE_SPACE_TP
		undefine
			i_th_has
		redefine
			i_th_type
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8
		rename
			i_th_is_space as i_th_has
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

end