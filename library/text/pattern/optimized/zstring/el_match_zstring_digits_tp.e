note
	description: "[
		[$source EL_MATCH_DIGITS_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:04:14 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_DIGITS_TP

inherit
	EL_MATCH_DIGITS_TP
		undefine
			i_th_is_digit
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_numeric as i_th_is_digit
		end

create
	make

end