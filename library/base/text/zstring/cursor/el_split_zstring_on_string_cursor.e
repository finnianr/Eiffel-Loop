note
	description: "[
		Implementation of ${EL_SPLIT_STRING_32_ON_STRING_CURSOR} optimized for ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-17 12:50:53 GMT (Thursday 17th April 2025)"
	revision: "11"

class
	EL_SPLIT_ZSTRING_ON_STRING_CURSOR

inherit
	EL_SPLIT_ON_STRING_CURSOR [ZSTRING, CHARACTER_32]
		redefine
			is_i_th_white_space, item, initialize, internal_item
		end

create
	make_adjusted

feature {NONE} -- Initialization

	initialize
		do
			create internal_item.make_empty
			forth
		end

feature -- Access

	item: like target
		-- dynamic singular substring of `target' at current split position if the
		-- `target' conforms to `STRING_GENERAL' else the value of `item_copy'
		-- use `item_copy' if you intend to keep a reference to `item' beyond the scope of the
		-- client routine
		do
			Result := internal_item
			Result.wipe_out
			Result.append_substring (target, item_lower, item_upper)
		end

feature {NONE} -- Implementation

	i_th_character (a_target: like target; i: INTEGER): CHARACTER_32
		-- i'th character of `a_target'
		do
			Result := a_target [i]
		end

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

feature {NONE} -- Internal attributes

	internal_item: detachable ZSTRING

end