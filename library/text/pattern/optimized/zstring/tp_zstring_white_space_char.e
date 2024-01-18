note
	description: "Matches white space character in ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:59 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_ZSTRING_WHITE_SPACE_CHAR

inherit
	TP_WHITE_SPACE_CHAR
		undefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_space as i_th_matches
		end

end

