note
	description: "[
		List of split items of a string conforming to `STRING_GENERAL' delimited by `delimiter'
		
		This is a more efficient way to process split strings as it doesn't create a new string
		instance for each split part.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-24 15:55:16 GMT (Friday 24th January 2020)"
	revision: "13"

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
			there_exists as there_exists_interval
		redefine
			is_equal, make_empty, make_from_sub_list, new_cursor,
			extend_buffer, extend_buffer_final, set_string
		end

	EL_JOINED_STRINGS [S]
		rename
			item as join_item
		undefine
			is_equal, copy, out
		redefine
			character_count
		end

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
		end

	integer_item: INTEGER
		do
			Result := join_item.to_integer
		end

	natural_item: NATURAL
		do
			Result := join_item.to_natural
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
			reversible: as_list.joined_with_string (delimiter) ~ a_string
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

	same_item_as (str: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := join_item.same_string (str)
		end

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

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

	extend_buffer (buffer: like Intervals_buffer; a_index, search_string_count: INTEGER)
		do
			if buffer.is_empty then
				buffer.extend (new_item (1, a_index - 1))
			else
				buffer.extend (new_item (upper_integer (buffer.last) + search_string_count + 1, a_index - 1))
			end
		end

	extend_buffer_final (buffer: like Intervals_buffer; string_count, search_string_count: INTEGER)
		local
			l_index: INTEGER
		do
			if buffer.is_empty then
				buffer.extend (new_item (1 , string_count))
			else
				l_index := upper_integer (buffer.last) + search_string_count + 1
				if l_index <= string_count then
					buffer.extend (new_item (l_index , string_count))
				end
			end
		end

	join_item: S
		-- split item
		do
			update_internal_item
			Result := internal_item
		end

	update_internal_item
		local
			start_index: INTEGER; internal: like internal_item
		do
			internal := internal_item
			internal.keep_head (0)
			start_index := item_start_index
			if left_adjusted then
				from until start_index > item_end_index or else not string.item (start_index).is_space loop
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
