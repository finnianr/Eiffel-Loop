note
	description: "Match numeric character in a string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-09 16:25:16 GMT (Wednesday 9th November 2022)"
	revision: "3"

class
	EL_STRING_8_NUMERIC_CHAR_TP

inherit
	EL_NUMERIC_CHAR_TP
		redefine
			i_th_matches
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i].is_digit
		end

end