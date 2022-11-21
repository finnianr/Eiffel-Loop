note
	description: "[
		[$source TP_CHAR_IN_ASCII_RANGE] optimized fro source text conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:57 GMT (Monday 21st November 2022)"
	revision: "7"

class
	TP_RSTRING_CHAR_IN_ASCII_RANGE

inherit
	TP_CHAR_IN_ASCII_RANGE
		redefine
			i_th_in_range
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

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

