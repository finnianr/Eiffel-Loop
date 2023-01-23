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
	date: "2023-01-23 10:21:46 GMT (Monday 23rd January 2023)"
	revision: "8"

class
	EL_SPLIT_READABLE_STRING_LIST [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_SPLIT_INTERVALS
		rename
			circular_i_th as circular_i_th_interval,
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
				wipe_out, fill, fill_by_string, start, forth, after, valid_adjustments
		redefine
			is_equal, make_empty, make_by_string, make, fill, fill_by_string
		end

	ITERABLE [S]
		undefine
			is_equal, copy, out
		select
			new_cursor
		end

	PART_COMPARATOR [INTEGER_64] undefine is_equal, copy, out end

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

	item_same_as (str: READABLE_STRING_GENERAL): BOOLEAN
		local
			interval: INTEGER_64; item_upper, item_lower: INTEGER
		do
			interval := interval_item
			item_lower := lower_integer (interval); item_upper := upper_integer (interval)
			if item_upper - item_lower + 1 = str.count then
				if str.count = 0 then
					Result := item_upper + 1 = item_lower
				else
					Result := target.same_characters (str, 1, str.count, item_lower)
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

	prune_enclosing (left, right: CHARACTER)
		-- Remove pair of characters on `first_item [1]' and `last_item [last.count]' if they match
		-- `left' and `right' characters
		local
			first_index, last_index: INTEGER
		do
			if count > 0 then
				first_index := first_lower; last_index := last_upper
				if target.valid_index (first_index) and then target.valid_index (last_index)
					and then target [first_index] = left and then target [last_index] = right
				then
					put_i_th_interval (new_interval (first_index + 1, first_upper), 1)
					put_i_th_interval (new_interval (last_lower, last_index - 1), count)
				end
			end
		end

feature -- Items

	circular_i_th (i: INTEGER): S
		do
			Result := target_substring (circular_i_th_interval (i))
		end

	first_item: S
		do
			if count = 0 then
				create Result.make (0)
			else
				Result := target_substring (first_interval)
			end
		end

	i_th (i: INTEGER): S
		do
			Result := target_substring (i_th_interval (i))
		end

	item: S
		do
			if off then
				create Result.make (0)
			else
				Result := target_substring (interval_item)
			end
		end

	last_item: S
		do
			if count = 0 then
				create Result.make (0)
			else
				Result := target_substring (last_interval)
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
			quick: QUICK_SORTER [INTEGER_64]
		do
			create quick.make (Current)
			if ascending then
				quick.sort (Current)
			else
				quick.reverse_sort (Current)
			end
		end

feature {NONE} -- Implementation

	less_than (left, right: INTEGER_64): BOOLEAN
		local
			left_index, right_index, left_count, right_count: INTEGER
		do
			left_index := lower_integer (left)
			left_count := upper_integer (right) - left_index + 1
			right_index := lower_integer (right)
			right_count := upper_integer (right) - right_index + 1

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

	target_substring (interval: INTEGER_64): S
		do
			Result := target.substring (lower_integer (interval), upper_integer (interval))
		end

feature {EL_SPLIT_READABLE_STRING_LIST} -- Internal attributes

	adjustments: INTEGER

	target: S

end