note
	description: "${ARRAYED_LIST [G]} with extra features"
	notes: "[
		All initialization routines call `make_from_special', so redefine this routine to assign
		default attribute values in descendants.
	]"
	tests: "[
		1. ${ARRAYED_LIST_TEST_SET}
		2. ${CONTAINER_STRUCTURE_TEST_SET}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 17:03:09 GMT (Saturday 5th October 2024)"
	revision: "77"

class
	EL_ARRAYED_LIST [G]

inherit
	ARRAYED_LIST [G]
		rename
			make_filled as make_default_filled,
			append as append_sequence
		export
			{EL_CONTAINER_HANDLER} set_area
		undefine
			index_of
		redefine
			make, make_from_array, make_default_filled
		end

	EL_CHAIN [G]
		rename
			accommodate as grow
		export
			{NONE} do_for_all
		undefine
			do_all, do_if, for_all, search, copy, order_by, occurrences, to_array,
		-- Query
			has, is_inserted, is_equal, off, valid_index, there_exists,
		-- item query
			i_th, at, last, first, put_i_th,
		-- cursor movement
			start, finish, go_i_th, new_cursor, move,
		-- Element change
			force, append_sequence, prune, prune_all, remove, swap
		redefine
			find_next_item, item_area, joined,
			push_cursor, pop_cursor
		end

create
	make, make_empty, make_default_filled, make_filled,
	make_from_for, make_from, make_from_list, make_from_if,
	make_joined, make_from_special, make_from_array,
	make_from_sub_list, make_from_tuple

convert
	make_from_array ({ARRAY [G]}), to_array: {ARRAY [G]}

feature {NONE} -- Initialization

	make (n: INTEGER)
			-- Allocate list with `n' items.
			-- (`n' may be zero for empty list.)
		do
			make_from_special (create {like area}.make_empty (n))
		end

	make_default_filled (n: INTEGER)
		-- Allocate list with `n' items.
		-- (`n' may be zero for empty list.)
		-- This list will be full.
		do
			make_from_special (create {like area}.make_filled (({G}).default, n))
		end

	make_from_array (a: ARRAY [G])
		-- Create list from array `a'.
		do
			make_from_special (a.area)
		end

	make_empty
		do
			make (0)
		end

	make_filled (n: INTEGER; new_item: FUNCTION [INTEGER, G])
		do
			make (n)
			from until full loop
				extend (new_item (count + 1))
			end
		end

	make_from (container: CONTAINER [G])
		-- initialize from `container' items
		do
			if attached as_structure (container) as structure then
				make_from_special (structure.to_special)
			else
				make_empty
			end
		ensure
			copied_area: attached {EL_ARRAYED_LIST [G]} container as list implies area /= list.area
		end

	make_from_for (container: CONTAINER [G]; condition: EL_QUERY_CONDITION [G])
		-- initialize from `container' of items for all items meeting `condition'
		do
			if attached as_structure (container) as structure
				and then attached structure.query (condition) as result_list
			then
				make_from_special (result_list.area)
				object_comparison := container.object_comparison
			else
				make_empty
			end
		end

	make_from_if (container: CONTAINER [G]; condition: PREDICATE [G])
		-- initialize from `container' of items if `condition (item)' is true
		do
			make_from_for (container, create {EL_PREDICATE_QUERY_CONDITION [G]}.make (condition))
		end

	make_from_list (list: ITERABLE [G])
		do
			if attached {ARRAYED_LIST [G]} list as arrayed_list then
				make_from_special (arrayed_list.area_v2.twin)
			else
				make (Iterable.count (list))
				across list as l_path loop
					extend (l_path.item)
				end
			end
		end

	make_from_special (a_area: like area)
		do
			area_v2 := a_area
			initialize
		end

	make_from_sub_list (list: READABLE_INDEXABLE [G]; start_index, end_index: INTEGER)
		require
			valid_range: start_index <= end_index implies list.lower <= start_index and end_index <= list.upper
		local
			i: INTEGER
		do
			if end_index < start_index then
				make_empty
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

	make_joined (array_1, array_2: ARRAY [G])
		do
			make (array_1.count + array_2.count)
			append (array_1); append (array_2)
		end

	initialize
		-- initialize default attribute values
		do
			index := 0
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

	emptied: like Current
		do
			wipe_out
			Result := Current
		ensure
			empty: Result.is_empty
		end

	joined (list: ITERABLE [G]): like Current
		do
			create Result.make (count + Iterable.count (list))
			Result.append_sequence (Current)
			Result.append (list)
		end

	sub_list (start_index, end_index: INTEGER): like Current
		do
			create Result.make_from_sub_list (Current, start_index, end_index)
			if object_comparison then
				Result.compare_objects
			end
		end

	tail (a_count: INTEGER): like Current
		require
			valid_count: a_count <= count
		local
			i: INTEGER
		do
			create Result.make (a_count)
			from i := count - a_count + 1 until i > count loop
				Result.extend (i_th (i))
				i := i + 1
			end
		end

	to_tuple: TUPLE
		require
			maximum_5_args: count <= 5
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

	trimmed_area: like area
		do
			trim
			Result := area_v2
		end

feature -- Status query

	is_sortable: BOOLEAN
		do
			Result := Eiffel.is_comparable_type (({like item}).type_id)
		end

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

feature -- Removal

	keep_head (n: INTEGER)
		require
			small_enough: n <= count
		do
			remove_tail (count - n.min (count))
		end

	remove_head (n: INTEGER)
		local
			is_index_moveable: BOOLEAN
		do
			if n <= count then
				is_index_moveable := index > n and n <= count
				area.move_data (n, 0, count - n)
				area.remove_tail (n)
				if is_index_moveable then
					index := index - n
				end
			end
		ensure
			items_removed: to_array ~ old tail_array (count - n)
			same_item: old (index > n and index <= count) implies index - (old index - n) = 0
		end

	remove_tail (n: INTEGER)
			--
		do
			if n <= count then
				area.remove_tail (n)
			end
			if index > count + 1 then
				index := count + 1
			end
		ensure
			items_removed: to_array ~ old head_array (count - n)
		end

feature -- Reorder items

	ascending_sort
		do
			sort (True)
		end

	order_by (sort_value: FUNCTION [G, COMPARABLE]; in_ascending_order: BOOLEAN)
		local
			i: INTEGER; result_array: SPECIAL [COMPARABLE]
			sorted: EL_SORTED_INDEX_LIST
		do
			if attached area_v2 as a and then a.count > 0 then
				create result_array.make_empty (a.count)
				from until i = a.count loop
					result_array.extend (sort_value (a [i]))
					i := i + 1
				end
				create sorted.make (result_array, in_ascending_order)
				reorder (sorted)
			end
		end

	reverse_order
		-- reverse order of items
		local
			reversed_area: like area; i: INTEGER
		do
			if attached area_v2 as a then
				create reversed_area.make_empty (a.count)
				from i := a.count - 1 until i < 0 loop
					reversed_area.extend (a [i])
					i := i - 1
				end
				area_v2 := reversed_area
			end
		end

	reverse_sort
		do
			sort (False)
		end

	shift (offset: INTEGER)
		-- shift item by `offset' positions to the right
		-- or to the left if `offset' negative
		-- Cursor position is unchanged
		require
			valid_shift: valid_shift (index, offset)
		local
			l_item: like item
		do
			if offset /= 0 then
				l_item := item
				remove
				if offset < 0 then
					go_i_th (index + offset - 1)
				else
					go_i_th (index + offset - 1)
				end
				put_right (l_item)
			end
		end

	shift_i_th (i, offset: INTEGER)
		-- shift `i'th item by `offset' positions to the right
		-- or to the left if `offset' negative
		require
			valid_shift: valid_shift (i, offset)
		do
			if offset /= 0 then
				push_cursor
				go_i_th (i)
				shift (offset)
				pop_cursor
			end
		ensure
			shifted_by_offset: old i_th (i) = i_th (i + offset)
		end

	sort (in_ascending_order: BOOLEAN)
		require
			sortable_items: is_sortable
		local
			sorted: EL_SORTED_INDEX_LIST
		do
			if attached {SPECIAL [COMPARABLE]} area_v2 as comparables then
				create sorted.make (comparables, in_ascending_order)
				reorder (sorted)
			end
		end

feature -- Contract Support

	item_cell: detachable CELL [like item]
		do
			if not off then
				create Result.put (item)
			end
		end

	head_array (n: INTEGER): ARRAY [G]
		do
			if n > 0 then
				Result := to_array.subarray (1, n)
				Result.rebase (1)
			else
				create Result.make_empty
			end
		end

	tail_array (n: INTEGER): ARRAY [G]
		do
			if n > 0 then
				Result := to_array.subarray (count - n + 1, count)
				Result.rebase (1)
			else
				create Result.make_empty
			end
		end

	valid_shift (i, offset: INTEGER): BOOLEAN
		-- `True' if `i_th (i)' item can be shifted `offset' positions to right
		-- (to left if negative)
		do
			if valid_index (i) then
				if offset > 0 then
					Result := offset <= (count - i)
				elseif offset < 0 then
					Result := offset.abs <= i - 1
				else
					Result := True
				end
			end
		end

feature {EL_ARRAYED_LIST} -- Implementation

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

	item_area: SPECIAL [G]
		do
			Result := area_v2
		end

	reorder (sorted: EL_SORTED_INDEX_LIST)
		-- reorder `Current' based on a sort of `comparables'
		require
			same_number: count = sorted.count
		local
			index_item: detachable like item; sorted_area: like area
			i: INTEGER
		do
			if count > 0 then
				if valid_index (index) then
					index_item := item
				end
				create sorted_area.make_empty (count)
				if attached area_v2 as l_area and then attached sorted.area as index_area then
					from until i = index_area.count loop
						if attached l_area [index_area [i]] as l_item then
							sorted_area.extend (l_item)
							if index_item = l_item then
								index := sorted_area.count
							end
						end
						i := i + 1
					end
				end
				area_v2 := sorted_area
			end
		ensure
			same_item: attached old item_cell as old_item implies old_item.item = item
		end

note
	descendants: "[
			EL_ARRAYED_LIST [G]
				${EL_NAMEABLES_LIST [G -> EL_NAMEABLE [READABLE_STRING_GENERAL]]}
				${EL_UNIQUE_ARRAYED_LIST [G -> HASHABLE]}
				${EL_ARRAYED_COMPACT_INTERVAL_LIST}
				${EL_CALL_SEQUENCE [CALL_ARGS -> TUPLE create default_create end]}
				${EL_DISCARDING_ARRAYED_LIST [G]}
				${EL_DIRECTORY_LIST}
				${EL_SORTABLE_ARRAYED_LIST [G -> COMPARABLE]}
				${EL_COMMA_SEPARATED_WORDS_LIST}
				${CSV_IMPORTABLE_ARRAYED_LIST [G -> EL_REFLECTIVELY_SETTABLE create make_default end]}
				${EL_NETWORK_DEVICE_LIST_I*}
					${EL_NETWORK_DEVICE_LIST_IMP}
				${EL_ARRAYED_RESULT_LIST [G, R]}
				${EL_TRANSLATION_ITEMS_LIST}
				${TB_EMAIL_LIST}
				${TP_ALL_IN_LIST}
					${TP_FIRST_MATCH_IN_LIST}
				${JOBS_RESULT_SET}
				${EL_FIELD_LIST}
				${EL_ARRAYED_REPRESENTATION_LIST* [R, N]}
					${DATE_LIST}
				${EL_REFLECTED_REFERENCE_LIST}
				${EL_QUERYABLE_ARRAYED_LIST [G]}
				${EL_PATH_STEP_TABLE}
				${EL_HTTP_PARAMETER_LIST}
				${EL_EVENT_LISTENER_LIST}
					${EL_EVENT_BROADCASTER}
				${EL_XDG_DESKTOP_ENTRY_STEPS}
				${EL_OPF_MANIFEST_LIST}
				${EL_APPLICATION_LIST}
				${EL_TUPLE_TYPE_LIST [T]}
				${EL_ARRAYED_MAP_LIST [K, G]}
				${EL_ARRAYED_INTERVAL_LIST}
				${EL_SPLIT_READABLE_STRING_LIST [S -> READABLE_STRING_GENERAL create make end]}
	]"
end