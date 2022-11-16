note
	description: "[$source EL_ALPHA_CHAR_TP] optimized for strings conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_STRING_8_ALPHA_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			i_th_matches
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i].is_alpha
		end

end