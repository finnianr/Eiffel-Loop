note
	description: "Matches white space character in string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 15:47:24 GMT (Saturday 29th October 2022)"
	revision: "8"

class
	EL_STRING_8_WHITE_SPACE_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		redefine
			i_th_matches
		end

create
	make

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		-- `True' if i'th character matches pattern
		do
			Result := text [i].is_space
		end
end