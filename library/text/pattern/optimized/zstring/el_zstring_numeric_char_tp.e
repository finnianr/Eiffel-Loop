note
	description: "Match numeric character optimized for [$source ZSTRING] text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 9:04:53 GMT (Tuesday 1st November 2022)"
	revision: "3"

class
	EL_ZSTRING_NUMERIC_CHAR_TP

inherit
	EL_NUMERIC_CHAR_TP
		redefine
			i_th_matches
		end

create
	make

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.is_numeric_item (i)
		end

end