note
	description: "Match consecutive digits"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-09 16:12:06 GMT (Thursday 9th February 2023)"
	revision: "4"

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
			-- `True' if i'th character is a digit
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