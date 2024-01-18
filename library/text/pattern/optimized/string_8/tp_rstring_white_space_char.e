note
	description: "[
		${TP_WHITE_SPACE_CHAR} optimized fro source text conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:44:22 GMT (Saturday 3rd December 2022)"
	revision: "4"

class
	TP_RSTRING_WHITE_SPACE_CHAR

inherit
	TP_WHITE_SPACE_CHAR
		undefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8
		rename
			i_th_is_space as i_th_matches
		end

end
