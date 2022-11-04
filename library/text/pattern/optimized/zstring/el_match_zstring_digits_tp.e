note
	description: "[
		[$source EL_MATCH_DIGITS_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 9:05:32 GMT (Tuesday 1st November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_DIGITS_TP

inherit
	EL_MATCH_DIGITS_TP
		redefine
			is_i_th_digit
		end

create
	make

feature {NONE} -- Implementation

	is_i_th_digit (i: INTEGER_32; text: ZSTRING): BOOLEAN
			-- `True' if i'th character is digit
		do
			Result := text.is_numeric_item (i)
		end

end