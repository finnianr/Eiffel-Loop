note
	description: "${TP_WHITE_SPACE} optimized for ${ZSTRING} source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	TP_ZSTRING_WHITE_SPACE

inherit
	TP_WHITE_SPACE
		undefine
			i_th_has
		redefine
			i_th_is_white_space
		end

	TP_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_space as i_th_has
		end

create
	make

feature {NONE} -- Implementation

	i_th_is_white_space (i: INTEGER_32; text: ZSTRING; a_nonbreaking: BOOLEAN): BOOLEAN
		local
			c: CHARACTER_8
		do
			Result := text.is_space_item (i)
			if Result and a_nonbreaking then
				c := text.item_8 (i)
				Result := not (c = '%N' or c = '%R')
			end
		end

end
