note
	description: "Match alphabetical character in a string conforming to [$source READABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-28 17:33:17 GMT (Friday 28th October 2022)"
	revision: "1"

class
	EL_STRING_8_ALPHA_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			i_th_matches
		end

create
	make

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		do
			Result := text [i].is_alpha
		end

end
