note
	description: "${TP_ALPHANUMERIC_CHAR} optimized for strings conforming to ${READABLE_STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:44:38 GMT (Saturday 3rd December 2022)"
	revision: "3"

class
	TP_RSTRING_ALPHANUMERIC_CHAR

inherit
	TP_ALPHANUMERIC_CHAR
		redefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i].is_alpha_numeric
		end

end
