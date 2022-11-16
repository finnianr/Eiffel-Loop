note
	description: "Matches white space character in [$source ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:01:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_WHITE_SPACE_CHAR_TP

inherit
	EL_WHITE_SPACE_CHAR_TP
		undefine
			i_th_matches
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_space as i_th_matches
		end

end