note
	description: "[
		${EL_SPLIT_ON_STRING_CURSOR} implemented for strings conforming to  ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 8:42:32 GMT (Thursday 17th April 2025)"
	revision: "3"

class
	EL_SPLIT_STRING_8_ON_STRING_CURSOR [RSTRING -> READABLE_STRING_8]

inherit
	EL_SPLIT_ON_STRING_CURSOR [RSTRING, CHARACTER_8]
		redefine
			is_i_th_white_space, internal_item
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
		do
			Result := a_target [i].is_space
		end

	i_th_character (a_target: like target; i: INTEGER): CHARACTER_8
		-- i'th character of `a_target'
		do
			Result := a_target [i]
		end

feature {NONE} -- Internal attributes

	internal_item: detachable STRING_8

end