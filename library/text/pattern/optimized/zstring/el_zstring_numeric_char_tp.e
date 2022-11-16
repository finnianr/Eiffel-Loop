note
	description: "Match numeric character optimized for [$source ZSTRING] text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:03:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_NUMERIC_CHAR_TP

inherit
	EL_NUMERIC_CHAR_TP
		undefine
			i_th_matches
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_numeric as i_th_matches
		end

end