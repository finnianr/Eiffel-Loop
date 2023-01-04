note
	description: "Match alphabetical character for [$source ZSTRING] text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:59 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_ZSTRING_ALPHA_CHAR

inherit
	TP_ALPHA_CHAR
		redefine
			i_th_matches
		end

	TP_OPTIMIZED_FOR_ZSTRING

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.is_alpha_item (i)
		end

end
