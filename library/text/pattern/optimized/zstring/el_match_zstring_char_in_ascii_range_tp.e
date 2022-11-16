note
	description: "[
		[$source EL_MATCH_CHAR_IN_ASCII_RANGE_TP] optimized for [$source ZSTRING] source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:14:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EL_MATCH_ZSTRING_CHAR_IN_ASCII_RANGE_TP

inherit
	EL_MATCH_CHAR_IN_ASCII_RANGE_TP
		redefine
			i_th_in_range
		end
		
	EL_MATCH_OPTIMIZED_FOR_ZSTRING

create
	make

feature {NONE} -- Implementation

	i_th_in_range (i: INTEGER; text: ZSTRING): BOOLEAN
		local
			c: CHARACTER
		do
			c := text.item_8 (i)
			Result := lower <= c and then c <= upper
		end

end