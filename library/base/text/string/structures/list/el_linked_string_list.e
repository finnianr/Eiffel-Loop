note
	description: "Linked string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-10 10:32:02 GMT (Wednesday 10th November 2021)"
	revision: "8"

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
			index_of
		end

create
	make_empty, make_with_separator, make_with_lines, make_with_words

feature {NONE} -- Unimplemented

	make, grow (n: INTEGER)
		-- do nothing
		do
		end

end