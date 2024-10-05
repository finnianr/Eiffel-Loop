note
	description: "Linked string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 14:39:29 GMT (Saturday 5th October 2024)"
	revision: "13"

class
	EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_CHAIN [S]
		rename
			accommodate as grow
		undefine
			count, copy, is_equal, is_inserted, prune_all, readable, prune, new_cursor, first, last,
			start, finish, move, go_i_th, isfirst, islast, off, remove
		end

	LINKED_LIST [S]
		rename
			append as append_sequence,
			make as make_empty
		undefine
			do_all, for_all, index_of, there_exists
		end

create
	make_empty, make_split, make_with_lines, make_word_split, make_adjusted_split, make_from_special

feature {NONE} -- Initialization

	make_from_special (area: SPECIAL [S])
		do
			make_empty
			area.do_all_in_bounds (agent extend, 0, area.count - 1)
		end

feature {NONE} -- Unimplemented

	make, grow (n: INTEGER)
		-- do nothing
		do
		end

end