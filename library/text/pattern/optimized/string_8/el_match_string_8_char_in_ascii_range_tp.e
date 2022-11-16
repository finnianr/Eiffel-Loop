note
	description: "[
		[$source EL_MATCH_CHAR_IN_ASCII_RANGE_TP] optimized fro source text conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_MATCH_STRING_8_CHAR_IN_ASCII_RANGE_TP

inherit
	EL_MATCH_CHAR_IN_ASCII_RANGE_TP
		redefine
			i_th_in_range
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

create
	make

feature {NONE} -- Implementation

	i_th_in_range (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		local
			c: CHARACTER
		do
			c := text [i]
			Result := lower <= c and then c <= upper
		end

end