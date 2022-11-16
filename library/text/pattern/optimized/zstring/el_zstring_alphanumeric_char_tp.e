note
	description: "[$source EL_ALPHANUMERIC_CHAR_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:55:42 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_ZSTRING_ALPHANUMERIC_CHAR_TP

inherit
	EL_ALPHANUMERIC_CHAR_TP
		redefine
			i_th_matches
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING

feature {NONE} -- Implementation

	i_th_matches (i: INTEGER; text: ZSTRING): BOOLEAN
		do
			Result := text.is_alpha_numeric_item (i)
		end

end