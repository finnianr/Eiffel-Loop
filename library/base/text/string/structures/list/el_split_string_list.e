note
	description: "[
		List of split items of a string conforming to `STRING_GENERAL' delimited by `delimiter'
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
	date: "2021-01-07 14:24:24 GMT (Thursday 7th January 2021)"
	revision: "21"

class
	EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_OCCURRENCE_INTERVALS [S]
		rename
			has as has_interval,
			do_all as do_all_intervals,
			for_all as for_all_intervals,
			fill as set_string,
			i_th as i_th_interval,
			item as interval_item,
			item_lower as item_start_index,
			item_upper as item_end_index,
			joined as joined_intervals,
			new_cursor as new_interval_cursor,
			there_exists as there_exists_interval
		redefine
			is_equal, make_empty, make_from_sub_list,
			extend_buffer, set_string
		end

	EL_JOINED_STRINGS [S]
		rename
			item as join_item
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
	make, make_empty, make_from_sub_list

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			create string.make_empty
			create internal_item.make_empty
			left_adjusted := False
			right_adjusted := False
		end

	make_from_sub_list (list: like Current; a_start_index, a_end_index: INTEGER)
		do
			string := list.string
			Precursor (list, a_start_index, a_end_index)
		end

feature -- Basic operations

	append_item_to (str: like string)
		do
			str.append_substring (string, item_start_index, item_end_index)
		end

	do_all (action: PROCEDURE [like item])
		-- apply `action' for all delimited substrings
		do
			push_cursor
			from start until after loop
				update_internal_item
				action (internal_item)
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

feature -- Access

	as_list: EL_STRING_LIST [S]
		do
			create Result.make (count)
			push_cursor
			from start until after loop
				Result.extend (string.substring (item_start_index, item_end_index))
				forth
			end
			pop_cursor
		end

	double_item: DOUBLE
		do
			Result := join_item.to_double
		end

	first_item (keep_ref: BOOLEAN): S
		-- split item
		do
			push_cursor
			start
			if before then
				create Result.make_empty
			else
				Result := item (keep_ref)
			end
			pop_cursor
		end

	i_th (i: INTEGER): S
		local
			interval: INTEGER_64
		do
			interval := i_th_interval (i)
			Result := string.substring (lower_integer (interval), upper_integer (interval))
			if left_adjusted then
				Result.left_adjust
			end
			if right_adjusted then
				Result.right_adjust
			end
		end

	integer_item: INTEGER
		do
			Result := join_item.to_integer
		end

	item (keep_ref: BOOLEAN): S
		-- split item
		do
			Result := join_item
			if keep_ref then
				Result := Result.twin
			end
		end

	last_item (keep_ref: BOOLEAN): S
		-- split item
		do
			push_cursor
			finish
			if after then
				create Result.make_empty
			else
				Result := item (keep_ref)
			end
			pop_cursor
		end

	natural_item: NATURAL
		do
			Result := join_item.to_natural
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

	set_string (a_string: like item; delimiter: READABLE_STRING_GENERAL)
		do
			string := a_string
			Precursor (a_string, delimiter)
		ensure then
			reversible: as_list.joined_with_string (delimiter).same_string (a_string)
		end

feature -- Status change

	disable_left_adjust
		do
			left_adjusted := True
		end

	disable_right_adjust
		do
			right_adjusted := True
		end

	enable_left_adjust
		do
			left_adjusted := True
		end

	enable_right_adjust
		do
			right_adjusted := True
		end

feature -- Status query

	for_all (predicate: PREDICATE [like item]): BOOLEAN
		-- `True' if all split items match `predicate'
		do
			push_cursor
			Result := True
			from start until not Result or after loop
				update_internal_item
				Result := predicate (internal_item)
				forth
			end
			pop_cursor
		end

	has (str: like item): BOOLEAN
		do
			push_cursor
			from start until Result or after loop
				Result := join_item ~ str
				forth
			end
			pop_cursor
		end

	has_general (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached {like item} str as zstr then
				Result := has (zstr)
			else
				push_cursor
				from start until Result or after loop
					Result := same_item_as (str)
					forth
				end
				pop_cursor
			end
		end

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

	same_item_as (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := join_item.same_string (str)
		end

	there_exists (predicate: PREDICATE [like item]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		do
			push_cursor
			from start until Result or after loop
				update_internal_item
				Result := predicate (internal_item)
				forth
			end
			pop_cursor
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := string ~ other.string and then Precursor {EL_OCCURRENCE_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	extend_buffer (buffer: like Intervals_buffer; search_index, search_string_count: INTEGER; final: BOOLEAN)
		do
			if final then
				if search_index = 0 then
					buffer.extend (new_item (1, string.count))
				else
					buffer.extend (new_item (search_index + search_string_count, string.count))
				end
			else
				if buffer.is_empty then
					buffer.extend (new_item (1, search_index - 1))
				else
					buffer.extend (new_item (upper_integer (buffer.last) + search_string_count + 1, search_index - 1))
				end
			end
		end

	join_item: S
		-- split item
		do
			update_internal_item
			Result := internal_item
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
				i_code := string.item (i).natural_32_code
				j_code := string.item (j).natural_32_code
				if i_code /= j_code then
					Result := (i_code - j_code).to_integer_32
					done := True
				end
				i := i + 1; j := j + 1
			end
		end

	update_internal_item
		local
			start_index: INTEGER; internal: like internal_item
			c: EL_CHARACTER_32_ROUTINES
		do
			internal := internal_item
			internal.keep_head (0)
			start_index := item_start_index
			if left_adjusted then
				from until start_index > item_end_index or else not c.is_space (string [start_index]) loop
					start_index := start_index + 1
				end
			end
			internal.append_substring (string, start_index, item_end_index)
			if right_adjusted then
				internal.right_adjust
			end
		end

feature {EL_SPLIT_STRING_LIST} -- Internal attributes

	internal_item: S

	string: S

end