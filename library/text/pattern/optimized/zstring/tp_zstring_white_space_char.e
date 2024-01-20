note
	description: "Matches white space character in ${ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

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
