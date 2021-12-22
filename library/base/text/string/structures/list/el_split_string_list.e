note
	description: "[
		List of split items of a string conforming to [$source STRING_GENERAL] delimited by `delimiter'
	]"
	notes: "[
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part. The split intervals are stored using class [$source EL_SEQUENTIAL_INTERVALS]
		inherited by [$source EL_OCCURRENCE_INTERVALS].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-20 19:16:12 GMT (Monday 20th December 2021)"
	revision: "27"

class
	EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]

inherit
	EL_OCCURRENCE_INTERVALS [S]
		rename
			circular_i_th as circular_i_th_interval,
			has as has_interval,
			do_all as do_all_intervals,
			for_all as for_all_intervals,
			i_th as i_th_interval,
			item as interval_item,
			item_lower as item_start_index,
			item_upper as item_end_index,
			joined as joined_intervals,
			new_cursor as new_interval_cursor,
			there_exists as there_exists_interval
		redefine
			is_equal, make_empty, make_from_sub_list, make_by_string, make,
			extend_buffer
		end

	EL_JOINABLE_STRINGS [S]
		undefine
			is_equal, copy, out
		redefine
			character_count
		end

	ITERABLE [S]
		undefine
			is_equal, copy, out
		select
			new_cursor
		end

	PART_COMPARATOR [INTEGER_64] undefine is_equal, copy, out end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make_from_sub_list, make

feature {NONE} -- Initialization

	make (a_target: S; delimiter: CHARACTER_32)
		do
			target := a_target
			make_empty
			fill (a_target, delimiter, 0)
		end

	make_adjusted (a_target: S; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			target := a_target; adjustments := a_adjustments
			make_empty
			fill (a_target, delimiter, a_adjustments)
		end

	make_adjusted_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		require
			valid_adjustments: valid_adjustments (a_adjustments)
		do
			target := a_target; adjustments := a_adjustments
			make_empty
			fill_by_string (a_target, delimiter, a_adjustments)
		end

	make_by_string (a_target: S; delimiter: READABLE_STRING_GENERAL)
		do
			target := a_target
			make_empty
			fill_by_string (a_target, delimiter, 0)
		end

	make_empty
		do
			Precursor
			if not attached target then
				create target.make (0)
			end
			create internal_item.make (0)
		end

	make_from_sub_list (list: like Current; a_start_index, a_end_index: INTEGER)
		do
			target := list.target
			Precursor (list, a_start_index, a_end_index)
		end

feature -- Basic operations

	append_item_to (str: like target)
		do
			str.append_substring (target, item_start_index, item_end_index)
		end

	do_all (action: PROCEDURE [like item])
		-- apply `action' for all delimited substrings
		do
			push_cursor
			from start until after loop
				action (item)
				forth
			end
			pop_cursor
		end

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

feature -- Shared items

	first_item: S
		-- first split item
		-- (DO NOT KEEP REFERENCES)
		do
			if count = 0 then
				Result := empty_item
			else
				Result := i_th (1)
			end
		end

	circular_i_th (i: INTEGER): S
		local
			interval: INTEGER_64
		do
			interval := circular_i_th_interval (i)
			Result := empty_item
			Result.append_substring (target, lower_integer (interval), upper_integer (interval))
		end

	i_th (i: INTEGER): S
		local
			interval: INTEGER_64
		do
			interval := i_th_interval (i)
			Result := empty_item
			Result.append_substring (target, lower_integer (interval), upper_integer (interval))
		end

	item: S
		-- current iteration split item
		-- (DO NOT KEEP REFERENCES)
		local
			interval: INTEGER_64
		do
			interval := interval_item
			Result := empty_item
			if not off then
				Result.append_substring (target, lower_integer (interval), upper_integer (interval))
			end
		end

	last_item: S
		-- last split item
		-- (DO NOT KEEP REFERENCES)
		do
			if count = 0 then
				Result := empty_item
			else
				Result := i_th (count)
			end
		end

feature -- Items

	circular_i_th_copy (i: INTEGER): S
		local
			interval: INTEGER_64
		do
			interval := circular_i_th_interval (i)
			Result := target.substring (lower_integer (interval), upper_integer (interval))
		end

	double_item: DOUBLE
		do
			Result := item.to_double
		end

	first_item_copy: S
		do
			if count = 0 then
				Result := empty_item
			else
				Result := i_th (1)
			end
		end

	i_th_copy (i: INTEGER): S
		local
			interval: INTEGER_64
		do
			interval := i_th_interval (i)
			Result := target.substring (lower_integer (interval), upper_integer (interval))
		end

	integer_item: INTEGER
		do
			Result := item.to_integer
		end

	item_copy: S
		local
			interval: INTEGER_64
		do
			interval := interval_item
			Result := target.substring (lower_integer (interval), upper_integer (interval))
		end

	last_item_copy: S
		do
			if count = 0 then
				Result := empty_item
			else
				Result := i_th_copy (count)
			end
		end

	natural_item: NATURAL
		do
			Result := item.to_natural
		end

feature -- Conversion

	as_list: EL_STRING_LIST [S]
		do
			create Result.make (count)
			push_cursor
			from start until after loop
				Result.extend (target.substring (item_start_index, item_end_index))
				forth
			end
			pop_cursor
		end

	new_cursor: EL_SPLIT_STRING_LIST_ITERATION_CURSOR [S]
		do
			create Result.make (Current)
		end

feature -- Measurement

	character_count: INTEGER
			--
		do
			push_cursor
			from start until after loop
				Result := Result + item_count
				forth
			end
			pop_cursor
		end

feature -- Element change

	set_target (a_target: like item; delimiter: like new_target.item; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
			fill (a_target, delimiter, a_adjustments)
		ensure then
			reversible: as_list.joined (delimiter).same_string (a_target)
		end

	set_target_by_string (a_target: like item; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
			fill_by_string (a_target, delimiter, a_adjustments)
		ensure then
			reversible: as_list.joined_with_string (delimiter).same_string (a_target)
		end

feature -- Status query

	for_all (predicate: PREDICATE [like item]): BOOLEAN
		-- `True' if all split items match `predicate'
		do
			push_cursor
			Result := True
			from start until not Result or after loop
				Result := predicate (item)
				forth
			end
			pop_cursor
		end

	has (str: like item): BOOLEAN
		do
			push_cursor
			from start until Result or after loop
				Result := item ~ str
				forth
			end
			pop_cursor
		end

	has_general (str: READABLE_STRING_GENERAL): BOOLEAN
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
			item_lower := lower_integer (interval)
			item_upper := upper_integer (interval)
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

	there_exists (predicate: PREDICATE [like item]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		do
			push_cursor
			from start until Result or after loop
				Result := predicate (item)
				forth
			end
			pop_cursor
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := target ~ other.target and then Precursor {EL_OCCURRENCE_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	empty_item: S
		do
			Result := internal_item
			Result.keep_head (0)
		end

	extend_buffer (
		a_target: S; buffer: like Intervals_buffer; search_index, search_string_count, a_adjustments: INTEGER
		final: BOOLEAN
	)
		local
			start_index, end_index: INTEGER
			found_first: BOOLEAN
		do
			if final then
				if search_index = 0 then
					start_index := 1; end_index := target.count
				else
					start_index := search_index + search_string_count; end_index := target.count
				end
			else
				if buffer.is_empty then
					start_index := 1; end_index := search_index - 1
				else
					start_index := upper_integer (buffer.last) + search_string_count + 1
					end_index := search_index - 1
				end
			end
			if (a_adjustments & {EL_STRING_ADJUST}.Left).to_boolean then
				from until found_first or else start_index > end_index loop
					if is_white_space (a_target, start_index) then
						start_index := start_index + 1
					else
						found_first := True
					end
				end
			end
			if (a_adjustments & {EL_STRING_ADJUST}.Right).to_boolean then
				found_first := False
				from until found_first or else end_index < start_index  loop
					if is_white_space (a_target, end_index) then
						end_index := end_index - 1
					else
						found_first := True
					end
				end
			end
			buffer.extend (new_interval (start_index, end_index))
		end

	is_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := Unicode_property.is_space (a_target [i])
		end

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

feature {EL_SPLIT_STRING_LIST} -- Internal attributes

	adjustments: INTEGER

	internal_item: S

	target: S

feature {NONE} -- Constants

	Unicode_property: CHARACTER_PROPERTY
			-- Property for Unicode characters.
		once
			create Result.make
		end
end