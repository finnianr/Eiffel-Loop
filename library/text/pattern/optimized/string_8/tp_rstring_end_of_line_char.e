note
	description: "[
		[$source TP_END_OF_LINE_CHAR] optimized for string conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-28 5:28:49 GMT (Monday 28th November 2022)"
	revision: "5"

class
	TP_RSTRING_END_OF_LINE_CHAR

inherit
	TP_END_OF_LINE_CHAR
		redefine
			i_th_is_newline
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

feature {NONE} -- Implementation

	i_th_is_newline (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i] = '%N'
		end

end
