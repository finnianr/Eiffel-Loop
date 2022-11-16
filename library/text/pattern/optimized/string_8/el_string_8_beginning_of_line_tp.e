note
	description: "[
		[$source EL_BEGINNING_OF_LINE_TP] optimized for string conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 15:39:45 GMT (Wednesday 16th November 2022)"
	revision: "1"

class
	EL_STRING_8_BEGINNING_OF_LINE_TP

inherit
	EL_BEGINNING_OF_LINE_TP
		redefine
			i_th_is_new_line
		end

feature {NONE} -- Implementation

	i_th_is_new_line (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i] = '%N'
		end

end