note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_CHARACTER_CURSOR [READABLE_STRING_32]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 8:42:55 GMT (Thursday 17th April 2025)"
	revision: "10"

class
	EL_SPLIT_ON_CHARACTER_32_CURSOR [S -> READABLE_STRING_32]

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [S, CHARACTER_32]
		redefine
			internal_item, same_caseless_characters, same_characters
		end

create
	make_adjusted

feature {NONE} -- Implementation

	fill_item (a_item: like internal_item)
		do
			a_item.wipe_out
			a_item.append_substring (target, item_lower, item_upper)
		end

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
		local
			c32: EL_CHARACTER_32_ROUTINES
		do
			Result := c32.is_space (a_target [i])
		end

	i_th_character (a_target: like target; i: INTEGER): CHARACTER_32
		-- i'th character of `a_target'
		do
			Result := a_target [i]
		end

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

feature {NONE} -- Internal attributes

	internal_item: detachable STRING_32

end