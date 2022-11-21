note
	description: "Match consecutive digits"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_DIGITS

inherit
	TP_CONTINUOUS_PROPERTY
		rename
			i_th_has as i_th_is_digit
		end

create
	make

feature {NONE} -- Implementation

	i_th_is_digit (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character is white space
		do
			Result := text [i].is_digit
		end

	name_inserts: TUPLE
		do
			Result := [spell_minimum]
		end

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "%S digits"
		end
end
