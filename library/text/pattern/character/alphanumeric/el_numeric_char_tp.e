note
	description: "Match numeric character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:14:24 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_NUMERIC_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP
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