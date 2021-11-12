note
	description: "List of strings conforming to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-29 14:17:25 GMT (Sunday 29th August 2021)"
	revision: "19"

class
	EL_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_STRING_CHAIN [S]
		rename
			subchain as array_subchain,
			accommodate as grow
		export
			{NONE} array_subchain
		undefine
			make_from_list, joined_chain,
			is_equal, copy, prune_all, readable, prune, new_cursor, to_array,
			first, last, i_th, at,
			start, finish, move, go_i_th, remove, find_next_item,
			is_inserted, has, there_exists, isfirst, islast, off, valid_index,
			do_all, for_all, do_if, search,
			force, put_i_th, append_sequence, swap,
			pop_cursor, push_cursor, order_by
		end

	EL_SORTABLE_ARRAYED_LIST [S]
		rename
			joined as joined_chain,
			subchain as array_subchain
		export
			{NONE} array_subchain
		redefine
			make, make_from_array, make_from_tuple
		end

create
	make, make_empty, make_with_separator, make_with_lines,
	make_with_words, make_from_array, make_from_list, make_from_tuple, make_from_general

convert
	make_from_array ({ARRAY [S]})

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			Precursor (n); compare_objects
		end

	make_from_array (array: ARRAY [S])
		do
			Precursor {EL_SORTABLE_ARRAYED_LIST} (array); compare_objects
		end

	make_from_tuple (tuple: TUPLE)
		do
			make (tuple.count)
			append_tuple (tuple)
		end

	make_from_general (list: ITERABLE [READABLE_STRING_GENERAL])
		do
			make (Iterable.count (list))
			append_general (list)
		end

feature -- Access

	subchain (index_from, index_to: INTEGER ): EL_STRING_LIST [S]
		do
			if attached {EL_ARRAYED_LIST [S]} array_subchain (index_from, index_to) as l_list then
				create Result.make_from_array (l_list.to_array)
			end
		end

feature -- Element change

	set_first_and_last (a_first, a_last: S)
		do
			if not is_empty then
				put_i_th (a_first, 1); put_i_th (a_last, count)
			end
		end

feature -- Removal

	prune_all_empty
			-- Remove empty items
		do
			from start until after loop
				if item.is_empty then
					remove
				else
					forth
				end
			end
		end

end
