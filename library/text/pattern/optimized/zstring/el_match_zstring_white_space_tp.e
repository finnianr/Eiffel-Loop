note
	description: "[$source EL_MATCH_WHITE_SPACE_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:00:41 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_WHITE_SPACE_TP

inherit
	EL_MATCH_WHITE_SPACE_TP
		undefine
			i_th_has
		redefine
			i_th_type
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_space as i_th_has
		end

create
	make

feature {NONE} -- Implementation

	i_th_type (i: INTEGER_32; text: ZSTRING): INTEGER
		local
			c: CHARACTER_8
		do
			c := text.item_8 (i)
			if c = Substitute then
				Result := Precursor (i, text)

			elseif c.is_space then
				if c = '%N' or c = '%R' then
					Result := Breaking_space
				else
					Result := Nonbreaking_space
				end
			end
		end

end