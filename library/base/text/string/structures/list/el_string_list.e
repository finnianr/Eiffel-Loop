note
	description: "List of strings conforming to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 15:38:07 GMT (Saturday 18th March 2023)"
	revision: "26"

class
	EL_STRING_LIST [S -> STRING_GENERAL create make end]

inherit
	EL_STRING_CHAIN [S]
		rename
			subchain as array_subchain,
			accommodate as grow
		export
			{NONE} array_subchain
		undefine
			make_from, joined_chain,
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
			{ANY} insert
			{NONE} array_subchain
		redefine
			make, make_from_array, make_from_tuple
		end

create
	make, make_empty, make_split, make_with_lines,
	make_word_split, make_from_array, make_from, make_from_tuple, make_from_general

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

feature -- Removal

	curtail (maximum_count: INTEGER)
		-- curtail list to `maximum_count' characters inserting an ellipsis at the 80% mark
		local
			line_list: like Current
			leading_80_percent, trailing_20_percent, line_count, start_index, end_index: INTEGER
			last_line, first_line: like item; dots: like item
		do
			dots := new_string (Ellipsis_dots)
			leading_80_percent := (maximum_count * 8 / 10).rounded
			trailing_20_percent := (maximum_count * 2 / 10).rounded
			line_list := twin
			from until character_count < leading_80_percent loop
				last_line := last
				remove_last
			end
			line_count := leading_80_percent - character_count
			extend (last_line.substring (1, line_count) + dots)

			from until line_list.character_count < trailing_20_percent loop
				first_line := line_list.first
				line_list.remove_head (1)
			end
			line_count := trailing_20_percent - line_list.character_count
			start_index := first_line.count - line_count + 1
			end_index := first_line.count
			line_list.put_front (dots + first_line.substring (start_index, end_index))

			append (line_list)
		end

feature {NONE} -- Constants

	Ellipsis_dots: STRING
		once
			create Result.make_filled ('.', 2)
		end

end