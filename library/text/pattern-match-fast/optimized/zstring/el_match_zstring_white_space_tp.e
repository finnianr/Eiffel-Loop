note
	description: "[$source EL_MATCH_WHITE_SPACE_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 16:08:22 GMT (Saturday 29th October 2022)"
	revision: "1"

class
	EL_MATCH_ZSTRING_WHITE_SPACE_TP

inherit
	EL_MATCH_WHITE_SPACE_TP
		redefine
			is_i_th_space
		end

create
	make

feature {NONE} -- Implementation

	is_i_th_space (i: INTEGER_32; text: ZSTRING): BOOLEAN
			-- `True' if i'th character is white space
		do
			Result := text.is_space_item (i)
		end

end