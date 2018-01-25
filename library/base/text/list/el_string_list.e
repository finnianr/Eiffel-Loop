note
	description: "List of strings conforming to `STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-11 16:30:38 GMT (Monday 11th December 2017)"
	revision: "4"

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
			start, finish, move, go_i_th, remove, find_next_function_value,
			is_inserted, has, there_exists, isfirst, islast, off, valid_index,
			do_all, for_all, do_if, search,
			force, put_i_th, append, swap, make_from_array,
			pop_cursor, push_cursor
		end

	EL_SORTABLE_ARRAYED_LIST [S]
		rename
			subchain as array_subchain
		export
			{NONE} array_subchain
		redefine
			make, make_from_array
		end

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array, make_from_tuple

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
		local
			i: INTEGER
		do
			make (tuple.count)
			from i := 1 until i > tuple.count loop
				if attached {S} tuple.reference_item (i) as str then
					extend (str)
				end
				i := i + 1
			end
		end

feature -- Access

	subchain (index_from, index_to: INTEGER ): EL_STRING_LIST [S]
		do
			if attached {EL_ARRAYED_LIST [S]} array_subchain (index_from, index_to) as l_list then
				create Result.make_from_array (l_list.to_array)
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
