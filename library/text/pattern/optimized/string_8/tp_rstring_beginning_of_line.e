note
	description: "[
		[$source TP_BEGINNING_OF_LINE] optimized for string conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:58 GMT (Monday 21st November 2022)"
	revision: "2"

class
	TP_RSTRING_BEGINNING_OF_LINE

inherit
	TP_BEGINNING_OF_LINE
		redefine
			i_th_is_new_line
		end

feature {NONE} -- Implementation

	i_th_is_new_line (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i] = '%N'
		end

end
