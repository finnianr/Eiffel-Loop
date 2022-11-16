note
	description: "[
		[$source EL_WHITE_SPACE_CHAR_TP] optimized fro source text conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STRING_8_WHITE_SPACE_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		undefine
			i_th_matches
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8
		rename
			i_th_is_space as i_th_matches
		end

end