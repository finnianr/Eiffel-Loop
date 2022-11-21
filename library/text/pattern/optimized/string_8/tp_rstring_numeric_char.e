note
	description: "Match numeric character in a string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:58 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_RSTRING_NUMERIC_CHAR

inherit
	TP_NUMERIC_CHAR
		undefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8
		rename
			i_th_is_digit as i_th_matches
		end

end

