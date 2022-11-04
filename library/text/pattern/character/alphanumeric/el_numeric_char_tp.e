note
	description: "Match numeric character"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-02 7:51:50 GMT (Wednesday 2nd November 2022)"
	revision: "3"

class
	EL_NUMERIC_CHAR_TP

inherit
	EL_CHARACTER_PROPERTY_TP
		rename
			make_default as make
		end

create
	make

feature -- Access

	name: STRING
		do
			Result := "digit"
		end

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := text [i].is_digit
		ensure then
			definition: Result = text [i].is_digit
		end

end