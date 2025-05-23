note
	description: "[
		A virtual split-list of strings conforming to ${READABLE_STRING_GENERAL} represented
		as a 2-dimensional array of substring intervals
	]"
	notes: "[
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part. The split intervals are stored using class ${EL_SEQUENTIAL_INTERVALS}
		inherited by ${EL_OCCURRENCE_INTERVALS}.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 6:38:34 GMT (Sunday 4th May 2025)"
	revision: "52"

class
	EL_SPLIT_READABLE_STRING_LIST [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_ARRAYED_LIST [S]
		rename
			do_all as index_do_all,
			do_if as index_do_if,
			for_all as index_for_all,
			there_exists as index_there_exists,
			make as make_sized,
			area_v2 as empty_area_v2,
			area as empty_area,
			fill as fill_list,
			lower as lower_index,
			upper as upper_index,
			replace as replace_item,
			remove_head as remove_list_head,
			remove_tail as remove_list_tail
		export
			{NONE} all
			{ANY} before, back, forth, after, go_i_th, index, is_sortable, off, prunable,
				query, query_if, query_not_in, query_in, query_is_equal,
				readable, start, valid_index, writable,
				Lower_index
			{ARRAYED_LIST_ITERATION_CURSOR} empty_area
		undefine
			count, make_empty, is_equal, upper_index, sort
		redefine
			at, do_for_all, do_meeting, has, i_th, item, new_cursor, remove, wipe_out
		end

	EL_STRING_SPLIT_CONTAINER [S]
		rename
			target as target_string
		export
			{ARRAYED_LIST_ITERATION_CURSOR, EL_STRING_SPLIT_CONTAINER, STRING_HANDLER} target_string
		redefine
			make_empty
		end

	EL_SORTABLE_STRING_LIST [S]
		rename
			item as i_th alias "[]",
			lower as lower_index,
			upper as count
		undefine
			copy, is_equal, new_cursor
		end

	EL_INTERVAL_LIST
		rename
			count_sum as character_count
		end

	PART_COMPARATOR [INTEGER] undefine is_equal, copy, out end

	EL_SHAREABLE_CACHE_TABLE [SPECIAL [READABLE_STRING_GENERAL], INTEGER]
		rename
			once_cache_table as Empty_area_table,
			new_shared_item as new_empty_area,
			shared_item as empty_area_for_type
		end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make

feature {NONE} -- Initialization

	make_empty
		do
			if attached {like empty_area} empty_area_for_type (target_type_id) as l_area then
				empty_area_v2 := l_area
			else
				empty_area_v2 := new_empty_area (target_type_id)
			end
			area := Default_area
			create area_intervals.make_empty
			Precursor {EL_STRING_SPLIT_CONTAINER}
		end

feature -- Measurement

	item_leading_occurrences (uc: CHARACTER_32): INTEGER
		local
			i, end_index: INTEGER; c: CHARACTER_8; done: BOOLEAN
		do
			if is_valid_character (uc) and then attached target_string as l_target then
				c := uc.to_character_8
				i := (index - 1) * 2
				if attached area as a then
					end_index := a [i + 1]
					from i := a [i] until done or i > end_index loop
						if same_i_th_character (l_target, i, uc) then
							Result := Result + 1
						else
							done := True
						end
						i := i + 1
					end
				end
			end
		end

	item_trailing_occurrences (uc: CHARACTER_32): INTEGER
		local
			i, start_index: INTEGER; done: BOOLEAN
		do
			if is_valid_character (uc) and then attached target_string as l_target then
				i := (index - 1) * 2
				if attached area as a then
					start_index := a [i]
					from i := a [i + 1] until done or i < start_index loop
						if same_i_th_character (l_target, i, uc) then
							Result := Result + 1
						else
							done := True
						end
						i := i - 1
					end
				end
			end
		end

	unicode_count: INTEGER
		do
			Result := character_count
		end

feature -- Item strings

	first_item: S
		do
			if count = 0 then
				create Result.make (0)
			elseif attached area as a then
				Result := target_substring (a [0], a [1])
			end
		end

	i_th alias "[]", at alias "@" (a_i: INTEGER): like item assign put_i_th
		local
			i: INTEGER
		do
			i := (a_i - 1) * 2
			if attached area as a then
				Result := target_substring (a [i], a [i + 1])
			end
		end

	item: S
			-- Current item
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				Result := target_substring (a [i], a [i + 1])
			end
		end

	last_item: S
		local
			i: INTEGER
		do
			if count = 0 then
				create Result.make (0)
			elseif attached area as a then
				i := (count - 1) * 2
				Result := target_substring (a [i], a [i + 1])
			end
		end

feature -- Access

	new_cursor: EL_SPLIT_READABLE_STRING_ITERATION_CURSOR [S]
		do
			create Result.make (Current)
		end

feature -- Conversion

	to_intervals: EL_SPLIT_INTERVALS
		do
			create Result.make_from_special (area)
		end

feature -- Status query

	has (str: like item): BOOLEAN
		do
			push_cursor
			from start until Result or after loop
				Result := item_same_as (str)
				forth
			end
			pop_cursor
		end

	item_has (uc: CHARACTER_32): BOOLEAN
		require
			valid_item: not off
		local
			i: INTEGER
		do
			if attached area as a then
				i := (index - 1) * 2
				Result := extended_string (target_string).has_in_bounds (uc, a [i], a [i + 1])
			end
		ensure
			same_result: Result = item.has (uc)
		end

	item_has_substring (str: READABLE_STRING_GENERAL): BOOLEAN
		require
			valid_item: not off
		local
			i, start_index, end_index: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				start_index := a [i]; end_index := a [i + 1]
			end
			if str.count <= end_index - start_index + 1 then
				Result := target_string.substring_index_in_bounds (str, start_index, end_index).to_boolean
			end
		end

	item_is_number: BOOLEAN
		require
			valid_item: not off
		local
			i, start_index, end_index: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				start_index := a [i]; end_index := a [i + 1]
			end
			Result := True
			from i := start_index until i > end_index or not Result loop
				Result := target_string [i].is_digit
				i := i + 1
			end
		end

	item_same_as (str: READABLE_STRING_GENERAL): BOOLEAN
		require
			valid_item: not off
		local
			i, end_index, start_index: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				start_index := a [i]; end_index := a [i + 1]
			end
			if end_index - start_index + 1 = str.count then
				if str.count = 0 then
					Result := end_index + 1 = start_index
				else
					Result := target_string.same_characters (str, 1, str.count, start_index)
				end
			end
		end

feature -- Basic operations

	do_for_all (action: EL_CONTAINER_ACTION [S])
		do
			do_meeting (action, any_item)
		end

	do_meeting (action: EL_CONTAINER_ACTION [S]; condition: EL_QUERY_CONDITION [S])
		-- perform `action' for each item meeting `condition'
		local
			i: INTEGER
		do
			if attached area as a then
				from until i = a.count loop
					action.do_if (target_substring (a [i], a [i + 1]), condition)
					i := i + 2
				end
			end
		end

	sort (in_ascending_order: BOOLEAN)
		local
			quick: QUICK_SORTER [INTEGER]; lower_index_array: ARRAY [INTEGER]; index_area: like area
			i, j, l_count: INTEGER; sorted_area: like area
		do
			l_count := count
			create index_area.make_empty (l_count)
--			fill with indices of each lower
			from i := 0 until i = l_count loop
				index_area.extend (i * 2)
				i := i + 1
			end
			create quick.make (Current)
--			sort indices

			create lower_index_array.make_from_special (index_area)
			if in_ascending_order then
				quick.sort (lower_index_array)
			else
				quick.reverse_sort (lower_index_array)
			end
--			copy to new positions
			create sorted_area.make_empty (l_count * 2)
			if attached area as a then
				from i := 0 until i = l_count loop
					j := index_area [i]
					sorted_area.extend (a [j]); sorted_area.extend (a [j + 1])
					i := i + 1
				end
			end
			area := sorted_area
		end

feature -- Removal

	for_all_remove_up_to (uc: CHARACTER_32)
		-- remove all characters up to `uc' for all items
		-- except those in which `uc' does not occur
		local
			uc_index: INTEGER
		do
			push_cursor
			from start until after loop
				uc_index := item_index_of (uc)
				if uc_index > 0 then
					remove_item_head (uc_index)
				end
				forth
			end
			pop_cursor
		end

	prune_enclosing (left, right: CHARACTER)
		-- Remove pair of characters on `first_item [1]' and `last_item [last.count]' if they match
		-- `left' and `right' characters
		local
			first_index, last_index: INTEGER
		do
			if count > 0 and then attached area as a then
				first_index := a [0]; last_index := a [a.count - 1]
				if attached target_string as target
					and then target.valid_index (first_index) and then target.valid_index (last_index)
					and then target [first_index] = left and then target [last_index] = right
				then
					a [0] := first_index + 1
					a [a.count - 1] := last_index - 1
				end
			end
		end

	unindent
		-- remove leading tab from all non-empty items
		local
			start_index, end_index, i, i_upper: INTEGER
		do
			if attached area as a and then a.count > 0 then
				i_upper := a.count - 1
				from i := 0 until i > i_upper loop
					start_index := a [i]; end_index := a [i + 1]
					if start_index <= end_index and then attached target_string as target
						and then target.valid_index (start_index) and then target.valid_index (end_index)
						and then target [start_index] = '%T'
					then
						a [i] := start_index + 1
					end
					i := i + 2
				end
			end
		end

	wipe_out
		do
			make_empty
			index := 0
		end

feature -- Removal

	remove
		do
			if attached to_intervals as l_intervals then
				l_intervals.go_i_th (index)
				l_intervals.remove
				area := l_intervals.area
			end
		end

	remove_head (n: INTEGER)
		do
			if attached to_intervals as l_intervals then
				l_intervals.remove_head (n)
				area := l_intervals.area
			end
		end

	remove_tail (n: INTEGER)
			--
		do
			if attached to_intervals as l_intervals then
				l_intervals.remove_tail (n)
				area := l_intervals.area
			end
		end

feature {NONE} -- Implementation

	fill_intervals (
		a_target, a_pattern: READABLE_STRING_GENERAL; searcher: STRING_SEARCHER
		uc: CHARACTER_32; a_adjustments: INTEGER
	)
		do
			area_intervals.fill (a_target, uc, adjustments)
			area := area_intervals.area
		end

	fill_intervals_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			area_intervals.fill_by_string_general (a_target, delimiter, a_adjustments)
			area := area_intervals.area
		end

	is_valid_character (uc: CHARACTER_32): BOOLEAN
		-- `True' if `uc' is valid for target type
		do
			Result := attached {READABLE_STRING_8} target_string implies uc.is_character_8
		end

	less_than (i, j: INTEGER): BOOLEAN
		local
			left_index, right_index, left_count, right_count: INTEGER
		do
			if attached area as a then
				left_index := a [i]; left_count := a [i + 1] - left_index + 1
				right_index := a [j]; right_count := a [j + 1] - right_index + 1
			end
			if right_count = left_count then
				Result := string_strict_cmp (right_index, left_index, right_count) > 0
			else
				if left_count < right_count then
					Result := string_strict_cmp (right_index, left_index, left_count) >= 0
				else
					Result := string_strict_cmp (right_index, left_index, right_count) > 0
				end
			end
		end

	new_empty_area (type_id: INTEGER): SPECIAL [S]
		do
			create Result.make_empty (0)
		end

	target_type_id: INTEGER
		do
			Result := {ISE_RUNTIME}.dynamic_type (default_target)
		end

feature {ARRAYED_LIST_ITERATION_CURSOR, EL_STRING_SPLIT_CONTAINER} -- Internal attributes

	area: SPECIAL [INTEGER]

	area_intervals: EL_SPLIT_INTERVALS

feature {NONE} -- Constants

	Default_area: SPECIAL [INTEGER]
		once
			create Result.make_empty (0)
		end

	Empty_area_table: EL_HASH_TABLE [SPECIAL [READABLE_STRING_GENERAL], INTEGER]
		once
			create Result.make (7)
		end

note
	descendants: "[
			EL_SPLIT_READABLE_STRING_LIST [S -> ${READABLE_STRING_GENERAL} create make end]
				${EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]}
					${EL_SPLIT_STRING_8_LIST}
					${EL_SPLIT_STRING_32_LIST}
					${EL_SPLIT_ZSTRING_LIST}
				${EL_COMPACT_ZSTRING_LIST}
				${EL_IMMUTABLE_STRING_GRID* [GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end]}
					${EL_IMMUTABLE_STRING_8_GRID}
					${EL_IMMUTABLE_STRING_32_GRID}
				${EL_SPLIT_IMMUTABLE_STRING_LIST* [GENERAL -> STRING_GENERAL, IMMUTABLE -> IMMUTABLE_STRING_GENERAL create make end]}
					${EL_SPLIT_IMMUTABLE_STRING_8_LIST}
						${EL_SPLIT_IMMUTABLE_UTF_8_LIST}
					${EL_SPLIT_IMMUTABLE_STRING_32_LIST}
	]"
end