note
	description: "Summary description for {EL_LINKED_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-30 8:25:30 GMT (Sunday 30th June 2013)"
	revision: "2"

class
	EL_LINKED_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_GENERAL_CHAIN [S]
		undefine
			is_equal, copy, is_inserted, prune_all, readable, prune, new_cursor, first, last,
			start, finish, move, go_i_th, isfirst, islast, off, remove
		end

	LINKED_LIST [S]
		rename
			make as make_empty
		end

create
	make_empty, make_with_separator, make_with_lines, make_with_words

feature {NONE} -- Unused

	grow (i: INTEGER)
			-- Change the capacity to at least `i'.
		do
		end

end
