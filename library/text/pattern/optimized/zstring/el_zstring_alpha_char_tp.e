note
	description: "Match alphabetical character for [$source ZSTRING] text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-29 15:47:03 GMT (Saturday 29th October 2022)"
	revision: "2"

class
	EL_ZSTRING_ALPHA_CHAR_TP

inherit
	EL_ALPHA_CHAR_TP
		redefine
			i_th_matches
		end

create
	make

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.is_alpha_item (i)
		end

end