note
	description: "[
		[$source EL_MATCH_CHARACTER_IN_SET_TP] optimized for strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_STRING_8_CHARACTER_IN_SET_TP

inherit
	EL_MATCH_CHARACTER_IN_SET_TP
		redefine
			i_th_in_set
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

create
	make

feature {NONE} -- Implementation

	i_th_in_set (i: INTEGER; text: READABLE_STRING_8): BOOLEAN
		-- `True' if i'th character is in `set'
		do
			Result := set.has (text [i])
		end

end