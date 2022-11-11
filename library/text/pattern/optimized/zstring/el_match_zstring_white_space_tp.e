note
	description: "[$source EL_MATCH_WHITE_SPACE_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 9:16:16 GMT (Friday 11th November 2022)"
	revision: "4"

class
	EL_MATCH_ZSTRING_WHITE_SPACE_TP

inherit
	EL_MATCH_WHITE_SPACE_TP
		redefine
			i_th_has, i_th_type
		end

	EL_ZCODE_CONVERSION
		export
			{NONE} all
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

	i_th_has (i: INTEGER_32; text: ZSTRING): BOOLEAN
			-- `True' if i'th character is white space
		do
			Result := text.is_space_item (i)
		end

end