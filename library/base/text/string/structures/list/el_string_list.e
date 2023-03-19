note
	description: "List of strings conforming to [$source STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-19 9:05:36 GMT (Sunday 19th March 2023)"
	revision: "27"

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

	make_from_general (list: ITERABLE [READABLE_STRING_GENERAL])
		do
			make (Iterable.count (list))
			append_general (list)
		end

	make_from_tuple (tuple: TUPLE)
		do
			make (tuple.count)
			append_tuple (tuple)
		end

feature -- Access

	subchain (index_from, index_to: INTEGER ): EL_STRING_LIST [S]
		do
			if attached {EL_ARRAYED_LIST [S]} array_subchain (index_from, index_to) as l_list then
				create Result.make_from_array (l_list.to_array)
			end
		end

feature -- Removal

	curtail (maximum_count, leading_percent: INTEGER)
		-- curtail list to `maximum_count' characters keeping `leading_percent' of `maximum_count'
		-- at the head and leaving `100 - leading_percent' at the tail
		-- and inserting two ellipsis (..) at the head and tail boundary mark
		local
			line_list: like Current; dots: like item
		do
			if maximum_count < character_count then
				dots := new_string (Ellipsis_dots)
				line_list := twin
				keep_character_head ((maximum_count * leading_percent / 100).rounded)
				last.append (dots)

				line_list.keep_character_tail ((maximum_count * (100 - leading_percent) / 100).rounded)
				line_list.first.prepend (dots)
				append (line_list)
			end
		end

	keep_character_head (n: INTEGER)
		-- remove `character_count - n' characters from end of list
		local
			new_count: INTEGER; last_line: detachable like item
			head_count: INTEGER
		do
			new_count := n.min (character_count)

			from until count = 0 or else character_count < new_count loop
				last_line := last
				remove_last
			end
			if attached last_line as line then
				head_count := new_count - character_count
				if head_count > 0 then
					extend (line.substring (1, head_count))
				end
			end
		ensure
			definition: old joined_strings.substring (1, n.min (character_count)) ~ joined_strings
		end

	keep_character_tail (n: INTEGER)
		-- remove `character_count - n' characters from end of list
		local
			new_count: INTEGER; first_line: detachable like item
			tail_count: INTEGER
		do
			new_count := n.min (character_count)

			from until count = 0 or else character_count < new_count loop
				first_line := first
				remove_head (1)
			end
			if attached first_line as line then
				tail_count := new_count - character_count
				if tail_count > 0 then
					put_front (line.substring (line.count - tail_count + 1, line.count))
				end
			end
		ensure
			definition: joined_strings ~ old joined_tail (n.min (character_count))
		end

feature -- Contract Support

	joined_tail (n: INTEGER): like item
		local
			l_count: INTEGER
		do
			l_count := character_count
			Result := joined_strings.substring (l_count - n + 1, l_count)
		end

feature {NONE} -- Constants

	Ellipsis_dots: STRING
		once
			create Result.make_filled ('.', 2)
		end

end