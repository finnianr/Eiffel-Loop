note
	description: "[
		Optimized implementation of ${EL_SPLIT_ON_CHARACTER_CURSOR [READABLE_STRING_8]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-15 12:15:13 GMT (Saturday 15th March 2025)"
	revision: "6"

class
	EL_SPLIT_ON_CHARACTER_8_CURSOR [S -> READABLE_STRING_8]

inherit
	EL_SPLIT_ON_CHARACTER_CURSOR [S]
		redefine
			is_i_th_white_space, is_i_th_character, same_caseless_characters, same_characters, set_separator_start
		end

create
	make

feature {NONE} -- Implementation

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
		-- `True' if i'th character of `a_target' is white space
		do
			Result := a_target [i].is_space
		end

	is_i_th_character (a_target: like target; i: INTEGER; uc: CHARACTER_32): BOOLEAN
		-- `True' if i'th character of `a_target' is equal to `uc'
		do
			if uc.is_character_8 then
				Result := a_target [i] = uc
			end
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
			if separator.is_character_8 then
				separator_start := target.index_of (separator.to_character_8, separator_end + 1)
			else
				separator_start := 0
			end
		end

end