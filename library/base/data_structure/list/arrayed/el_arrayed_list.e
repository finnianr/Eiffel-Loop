note
	description: "Arrayed list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-13 10:26:15 GMT (Tuesday 13th November 2018)"
	revision: "16"

class
	EL_ARRAYED_LIST [G]

inherit
	ARRAYED_LIST [G]
		rename
			append as append_sequence
		end

	EL_CHAIN [G]
		rename
			accommodate as grow
		undefine
			off, index_of, occurrences, has, do_all, do_if, there_exists, for_all, is_equal, search, copy,
			i_th, at, last, first, valid_index, is_inserted, move, start, finish, go_i_th, put_i_th,
			force, append_sequence, prune, prune_all, remove, swap, new_cursor, to_array
		redefine
			find_next_item, push_cursor, pop_cursor
		end

create
	make, make_filled, make_from_array, make_empty, make_from_sub_list, make_from_tuple

convert
	make_from_array ({ARRAY [G]})

feature {NONE} -- Initialization

	make_empty
		do
			make (0)
		end

	make_from_sub_list (list: EL_ARRAYED_LIST [G]; start_index, end_index: INTEGER)
		require
			valid_start_index: list.valid_index (start_index)
			valid_end_index: list.valid_index (end_index)
		local
			i: INTEGER
		do
			if end_index < start_index then
				make (0)
			else
				make (end_index - start_index + 1)
				from i := start_index until i > end_index loop
					extend (list [i])
					i := i + 1
				end
			end
		end

	make_from_tuple (tuple: TUPLE)
		-- extend Current with items in `tuple' of type conforming to `G'
		local
			i: INTEGER
		do
			make (tuple.count)
			from i := 1 until i > tuple.count loop
				if attached {G} tuple.item (i) as l_item then
					extend (l_item)
				end
				i := i + 1
			end
		end

feature -- Access

	duplicate_array (n: INTEGER): ARRAY [G]
			-- Copy of sub-list beginning at current position
			-- and having min (`n', `count' - `index' + 1) items.
		local
			end_pos: INTEGER
		do
			if after then
				create Result.make_empty
			else
				end_pos := count.min (index + n - 1)
				create Result.make_filled (item, 1, end_pos - index + 1)
				Result.area.copy_data (area_v2, index - 1, 0, end_pos - index + 1)
			end
		end

	sub_list (start_index, end_index: INTEGER): like Current
		do
			create Result.make_from_sub_list (Current, start_index, end_index)
		end

	to_tuple: TUPLE
		require
			maximum_4_args: count <= 5
		local
			l_area: like area
		do
			l_area := area
			inspect count
				when 1 then
					Result := [l_area [0]]
				when 2 then
					Result := [l_area [0], l_area [1]]
				when 3 then
					Result := [l_area [0], l_area [1], l_area [2]]
				when 4 then
					Result := [l_area [0], l_area [1], l_area [2], l_area [3]]
				when 5 then
					Result := [l_area [0], l_area [1], l_area [2], l_area [3], l_area [4]]
			else
				create Result
			end
		end

feature -- Removal

	remove_head (n: INTEGER)
			--
		do
			remove_end (n, agent start)
		end

	remove_tail (n: INTEGER)
			--
		do
			remove_end (n, agent finish)
		end

feature -- Cursor movement

	pop_cursor
		-- restore cursor position from stack
		do
			index := Index_stack.item
			Index_stack.remove
		end

	push_cursor
		-- push cursor position on to stack
		do
			Index_stack.put (index)
		end

feature -- Element change

	shift (offset: INTEGER)
		-- shift item by `offset' positions to the right
		-- or to the left if `offset' negative
		-- Cursor position is unchange
		require
			valid_offset: (1 |..| count).has (index + offset)
		local
			l_item: like item
		do
			if offset /= 0 then
				l_item := item
				remove
				if offset < 0 then
					go_i_th (index + offset - 1)
				else
					go_i_th (index + offset)
				end
				put_right (l_item)
			end
		end

	shift_i_th (i, offset: INTEGER)
		-- shift `i'th item by `offset' positions to the right
		-- or to the left if `offset' negative
		require
			valid_index: valid_index (i)
			valid_offset: (1 |..| count).has (i + offset)
		do
			if offset /= 0 then
				push_cursor
				go_i_th (i)
				shift (offset)
				pop_cursor
			end
		end

feature {NONE} -- Implementation

	find_next_item (condition: EL_QUERY_CONDITION [G])
			-- Find next `item' that meets `condition'
		local
			l_area: like area_v2; i, nb: INTEGER; match_found: BOOLEAN
		do
			l_area := area_v2
			from nb := count - 1; i := index - 1 until i > nb or match_found loop
				if condition.met (l_area [i]) then
					match_found := True
				else
					i := i + 1
				end
			end
			index := i + 1
		end

	remove_end (n: INTEGER; go_to_end: PROCEDURE)
			--
		local
			i: INTEGER
		do
			from i := 1 until i > n or is_empty loop
				go_to_end.apply; remove
				i := i + 1
			end
		end

feature {NONE} -- Constants

	Index_stack: ARRAYED_STACK [INTEGER]
		once
			create Result.make (5)
		end

end
