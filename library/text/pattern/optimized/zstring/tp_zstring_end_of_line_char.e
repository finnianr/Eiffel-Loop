note
	description: "${TP_END_OF_LINE_CHAR} optimized for ${ZSTRING} text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 5:29:56 GMT (Monday 28th November 2022)"
	revision: "4"

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
