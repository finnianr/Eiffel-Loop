note
	description: "Match numeric character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:54 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_NUMERIC_CHAR

inherit
	TP_CHARACTER_PROPERTY
		rename
			name_inserts as Empty_inserts
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i].is_digit
		ensure then
			definition: Result = text [i].is_digit
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "digit"
		end
end
