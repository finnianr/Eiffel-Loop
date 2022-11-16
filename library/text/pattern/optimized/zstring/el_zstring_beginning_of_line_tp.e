note
	description: "[
		[$source EL_BEGINNING_OF_LINE_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 15:42:35 GMT (Wednesday 16th November 2022)"
	revision: "1"

class
	EL_ZSTRING_BEGINNING_OF_LINE_TP

inherit
	EL_BEGINNING_OF_LINE_TP
		redefine
			i_th_is_new_line
		end

feature {NONE} -- Implementation

	i_th_is_new_line (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.item_8 (i) = '%N'
		end

end