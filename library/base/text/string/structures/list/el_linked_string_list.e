note
	description: "Linked string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_CHAIN [S]
		rename
			accommodate as grow
		undefine
			is_equal, copy, is_inserted, prune_all, readable, prune, new_cursor, first, last,
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
	make_empty, make_split, make_with_lines, make_word_split, make_adjusted_split

feature {NONE} -- Unimplemented

	make, grow (n: INTEGER)
		-- do nothing
		do
		end

end