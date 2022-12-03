note
	description: "[$source TP_WHITE_SPACE] optimized for string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:44:32 GMT (Saturday 3rd December 2022)"
	revision: "5"

class
	TP_RSTRING_WHITE_SPACE

inherit
	TP_WHITE_SPACE
		undefine
			i_th_has
		redefine
			i_th_is_white_space
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8
		rename
			i_th_is_space as i_th_has
		end

create
	make

feature {NONE} -- Implementation

	i_th_is_white_space (i: INTEGER_32; text: READABLE_STRING_8; a_nonbreaking: BOOLEAN): BOOLEAN
		local
			c: CHARACTER_8
		do
			c := text [i]
			if a_nonbreaking and then c = '%N' or c = '%R' then
				Result := False
			else
				Result := c.is_space
			end
		end
end
