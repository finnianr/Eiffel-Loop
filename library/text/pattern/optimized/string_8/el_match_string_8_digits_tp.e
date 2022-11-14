note
	description: "[$source EL_MATCH_DIGITS_TP] optimized for strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:19:52 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_STRING_8_DIGITS_TP

inherit
	EL_MATCH_DIGITS_TP
		redefine
			is_i_th_digit
		end

create
	make

feature {NONE} -- Implementation

	is_i_th_digit (i: INTEGER_32; text: READABLE_STRING_8): BOOLEAN
			-- `True' if i'th character is digit
		do
			Result := text [i].is_digit
		end

end