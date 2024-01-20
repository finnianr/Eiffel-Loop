note
	description: "${TP_END_OF_LINE_CHAR} optimized for ${ZSTRING} text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	TP_ZSTRING_END_OF_LINE_CHAR

inherit
	TP_END_OF_LINE_CHAR
		redefine
			i_th_is_newline
		end

	TP_OPTIMIZED_FOR_ZSTRING

feature {NONE} -- Implementation

	i_th_is_newline (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.z_code (i) = 10
		end

end