note
	description: "[
		${TP_CHAR_IN_ASCII_RANGE} optimized fro source text conforming to ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "8"

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
