note
	description: "[
		${TP_BEGINNING_OF_LINE} optimized for ${ZSTRING} source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	TP_ZSTRING_BEGINNING_OF_LINE

inherit
	TP_BEGINNING_OF_LINE
		redefine
			i_th_is_new_line
		end

feature {NONE} -- Implementation

	i_th_is_new_line (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.item_8 (i) = '%N'
		end

end