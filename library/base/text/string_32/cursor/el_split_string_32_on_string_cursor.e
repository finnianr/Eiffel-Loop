note
	description: "[
		${EL_SPLIT_ON_STRING_CURSOR} implemented for strings conforming to  ${READABLE_STRING_32}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 12:46:19 GMT (Thursday 17th April 2025)"
	revision: "4"

class
	EL_SPLIT_STRING_32_ON_STRING_CURSOR [RSTRING -> READABLE_STRING_32]

inherit
	EL_SPLIT_ON_STRING_CURSOR [RSTRING, CHARACTER_32]
		redefine
			fill_item, internal_item, is_i_th_white_space
		end

create
	make_adjusted

feature {NONE} -- Implementation

	fill_item (a_item: STRING_32)
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

feature {NONE} -- Internal attributes

	internal_item: detachable STRING_32

end