note
	description: "Match alphanumeric character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 7:23:32 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ALPHANUMERIC_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP
		rename
			name_inserts as Empty_inserts
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i].is_alpha_numeric
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "alphanumeric"
		end

end