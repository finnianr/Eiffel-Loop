note
	description: "Summary description for {EL_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-07 8:44:10 GMT (Sunday 7th July 2013)"
	revision: "2"

class
	EL_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_GENERAL_CHAIN [S]
		rename
			subchain as array_subchain
		export
			{NONE} array_subchain
		undefine
			is_equal, copy, prune_all, readable, prune, new_cursor,
			first, last, i_th, at,
			start, finish, move, go_i_th, remove, find_next,
			is_inserted, has, there_exists, isfirst, islast, off, valid_index,
			do_all, for_all, do_if, search,
			force, put_i_th, append, swap, make_from_array
		end

	EL_ARRAYED_LIST [S]
		rename
			subchain as array_subchain
		export
			{NONE} array_subchain
		end

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array

feature {NONE} -- Initialization

	make_empty
		do
			make (0)
		end

feature -- Access

	subchain (index_from, index_to: INTEGER ): EL_STRING_LIST [S]
		do
			if attached {EL_ARRAYED_LIST [S]} array_subchain (index_from, index_to) as l_list then
				create Result.make_from_array (l_list.to_array)
			end
		end

end
