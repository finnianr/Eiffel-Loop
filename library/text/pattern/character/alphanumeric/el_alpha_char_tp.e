note
	description: "Match alphabetical character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ALPHA_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP
		rename
			name_inserts as Empty_inserts
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i].is_alpha
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "letter"
		end

end