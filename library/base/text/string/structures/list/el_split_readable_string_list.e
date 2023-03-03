note
	description: "[
		A virtual split-list of strings conforming to [$source READABLE_STRING_GENERAL] represented
		as an array of [$INTEGER_64] substring intervals
	]"
	notes: "[
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part. The split intervals are stored using class [$source EL_SEQUENTIAL_INTERVALS]
		inherited by [$source EL_OCCURRENCE_INTERVALS].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-03 9:42:53 GMT (Friday 3rd March 2023)"
	revision: "12"

class
	EL_SPLIT_READABLE_STRING_LIST [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_SPLIT_INTERVALS
		rename
			current_linear as current_intervals,
			do_all as do_all_intervals,
			do_if as do_if_intervals,
			find_first_equal as find_first_interval_equal,
			find_next_item as find_next_interval,
			for_all as for_all_intervals,
			has as has_interval,
			i_th as i_th_interval,
			item as interval_item,
			index_of as index_of_interval,
			intersection as interval_intersection,
			item_lower as item_start_index,
			item_upper as item_end_index,
			inverse_query_if as inverse_interval_query_if,
			joined as joined_intervals,
			new_cursor as new_interval_cursor,
			occurrences as interval_occurrences,
			query_if as interval_query_if,
			query_in as interval_query_in,
			query_not_in as interval_query_not_in,
			search as search_for_interval,
			to_array as to_interval_array,
			there_exists as there_exists_interval
		export
			{NONE} all
			{ANY} index, count, item_count, item_start_index, item_end_index, i_th_upper, i_th_lower,
				back, remove, remove_head, remove_tail, go_i_th, is_empty, before, valid_index,
				wipe_out, fill, fill_by_string, start, forth, after, valid_adjustments, off
		redefine
			is_equal, make_empty, make_by_string, make, fill, fill_by_string
		end

	ITERABLE [S]
		undefine
			is_equal, copy, out
		select
			new_cursor
		end

	PART_COMPARATOR [INTEGER] undefine is_equal, copy, out end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make

feature {NONE} -- Initialization

	make (a_target: S; delimiter: CHARACTER_32)
		do
			make_empty
			fill (a_target, delimiter, 0)
		end

	make_adjusted (a_target: S; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			make_empty
			fill (a_target, delimiter, a_adjustments)
		end

	make_adjusted_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			make_empty
			fill_by_string (a_target, delimiter, a_adjustments)
		end

	make_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL)
		do
			make_empty
			fill_by_string (a_target, delimiter, 0)
		end

	make_empty
		do
			Precursor
			if not attached target then
				create target.make (0)
			end
		end

feature -- Access

	new_cursor: EL_SPLIT_STRING_LIST_ITERATION_CURSOR [S]
		do
			create Result.make (Current)
		end

feature -- Status query

	has (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			push_cursor
			from start until Result or after loop
				Result := item_same_as (str)
				forth
			end
			pop_cursor
		end

	item_has_substring (str: READABLE_STRING_GENERAL): BOOLEAN
		require
			valid_item: not off
		local
			i, l_index: INTEGER; item_upper, item_lower: INTEGER
		do
			if attached area_v2 as a then
				i := (index - 1) * 2
				item_lower := a [i]; item_upper := a [i + 1]
				Result := target.substring_index_in_bounds (str, item_lower, item_upper).to_boolean
			end
		end

	item_same_as (str: READABLE_STRING_GENERAL): BOOLEAN
		require
			valid_item: not off
		local
			i: INTEGER; item_upper, item_lower: INTEGER
		do
			if attached area_v2 as a then
				i := (index - 1) * 2
				item_lower := a [i]; item_upper := a [i + 1]
				if item_upper - item_lower + 1 = str.count then
					if str.count = 0 then
						Result := item_upper + 1 = item_lower
					else
						Result := target.same_characters (str, 1, str.count, item_lower)
					end
				end
			end
		end

	left_adjusted: BOOLEAN
		do
			Result := (adjustments & {EL_STRING_ADJUST}.Left).to_boolean
		end

	right_adjusted: BOOLEAN
		do
			Result := (adjustments & {EL_STRING_ADJUST}.Right).to_boolean
		end

feature -- Numeric items

	double_item: DOUBLE
		do
			Result := item.to_double
		end

	integer_item: INTEGER
		do
			Result := item.to_integer
		end

	natural_item: NATURAL
		do
			Result := item.to_natural
		end

feature -- Element change

	fill (a_target: S; search_character: CHARACTER_32; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
			fill_intervals (a_target, Empty_string_8, search_character, a_adjustments)
		end

	fill_by_string (a_target: S; search_string: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
			Precursor (a_target, search_string, a_adjustments)
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
			if count > 0 and then attached area_v2 as a then
				first_index := a [0]; last_index := a [a.count - 1]
				if target.valid_index (first_index) and then target.valid_index (last_index)
					and then target [first_index] = left and then target [last_index] = right
				then
					a [0] := first_index + 1
					a [a.count - 1] := last_index - 1
				end
			end
		end

feature -- Items

	circular_i_th (i: INTEGER): S
		local
			j: INTEGER
		do
			if attached area_v2 as a then
				j := modulo (i, count) * 2
				Result := target_substring (a [j], a [j + 1])
			end
		end

	first_item: S
		do
			if count = 0 then
				create Result.make (0)
			elseif attached area_v2 as a then
				Result := target_substring (a [0], a [1])
			end
		end

	i_th (i: INTEGER): S
		local
			j: INTEGER
		do
			if attached area_v2 as a then
				j := (i - 1) * 2
				Result := target_substring (a [j], a [j + 1])
			end
		end

	item_index_of (c: CHARACTER_32): INTEGER
		-- index of `c' relative to `item_start_index - 1'
		-- 0 if `c' does not occurr within item bounds
		local
			l_index: INTEGER
		do
			l_index := target.index_of ('=', item_start_index)
			if not (l_index = 0 or l_index > item_end_index) then
				Result := l_index - item_start_index + 1
			end
		end

	item: S
		local
			i: INTEGER
		do
			if off then
				create Result.make (0)

			elseif attached area_v2 as a then
				i := (index - 1) * 2
				Result := target_substring (a [i], a [i + 1])
			end
		end

	last_item: S
		local
			i: INTEGER
		do
			if count = 0 then
				create Result.make (0)
			elseif attached area_v2 as a then
				i := (count - 1) * 2
				Result := target_substring (a [i], a [i + 1])
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target and then Precursor {EL_SPLIT_INTERVALS} (other)
		end

feature -- Basic operations

	sort (ascending: BOOLEAN)
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
			if ascending then
				quick.sort (lower_index_array)
			else
				quick.reverse_sort (lower_index_array)
			end
--			copy to new positions
			create sorted_area.make_empty (l_count * 2)
			if attached area_v2 as a then
				from i := 0 until i = l_count loop
					j := index_area [i]
					sorted_area.extend (a [j]); sorted_area.extend (a [j + 1])
					i := i + 1
				end
			end
			area_v2 := sorted_area
		end

feature {NONE} -- Implementation

	less_than (i, j: INTEGER): BOOLEAN
		local
			left_index, right_index, left_count, right_count: INTEGER
		do
			if attached area_v2 as a then
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

	string_strict_cmp (left_index, right_index, n: INTEGER): INTEGER
		local
			i, j, nb: INTEGER; i_code, j_code: NATURAL; done: BOOLEAN
		do
			from
				i := left_index; j := right_index; nb := i + n
			until
				done or else i = nb
			loop
				i_code := target.item (i).natural_32_code
				j_code := target.item (j).natural_32_code
				if i_code /= j_code then
					Result := (i_code - j_code).to_integer_32
					done := True
				end
				i := i + 1; j := j + 1
			end
		end

	target_substring (lower, upper: INTEGER): S
		do
			Result := target.substring (lower, upper)
		end

feature {EL_SPLIT_READABLE_STRING_LIST} -- Internal attributes

	adjustments: INTEGER

	target: S

end