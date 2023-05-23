note
	description: "[
		Optimized implementation of [$source EL_SPLIT_ON_CHARACTER_CURSOR [READABLE_STRING_32]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-23 10:19:14 GMT (Tuesday 23rd May 2023)"
	revision: "3"

class
	EL_SPLIT_ON_CHARACTER_32_CURSOR [S -> READABLE_STRING_32]

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [S]
		redefine
			same_caseless_characters, same_characters, set_separator_start
		end

create
	make

feature {NONE} -- Implementation

 	same_caseless_characters (a_target, other: like target; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- caseless identical to characters of current string starting at index `index_pos'.
		do
			Result := a_target.same_caseless_characters (other, start_pos, end_pos, index_pos)
		end

 	same_characters (a_target, other: like target; start_pos, end_pos, index_pos: INTEGER): BOOLEAN
			-- Are characters of `other' within bounds `start_pos' and `end_pos'
			-- identical to characters of current string starting at index `index_pos'.
		do
			Result := a_target.same_characters (other, start_pos, end_pos, index_pos)
		end

	set_separator_start
		do
			separator_start := target.index_of (separator, separator_end + 1)
		end

end