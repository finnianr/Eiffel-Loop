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
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

class
	EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make, make_empty end]

inherit
	EL_SEQUENTIAL_INTERVALS
		rename
			has as has_interval,
			do_all as do_all_intervals,
			for_all as for_all_intervals,
			make as make_intervals,
			item as interval_item,
			item_lower as start_index,
			item_upper as end_index,
			there_exists as there_exists_interval
		redefine
			is_equal, make_empty, make_from_sub_list
		end

	EL_JOINED_STRINGS [S]
		undefine
			is_equal, copy, out
		redefine
			character_count
		end

create
	make, make_empty, make_from_sub_list

feature {NONE} -- Initialization

	make (a_string: like item; delimiter: READABLE_STRING_GENERAL)
			--
		local
			l_occurrences: EL_OCCURRENCE_INTERVALS [S]
			last_interval: INTEGER_64
		do
			string := a_string
			create internal_item.make_empty
			create l_occurrences.make (a_string, delimiter)
			last_interval := new_item (1, 0)
			make_intervals (l_occurrences.count + 1)
			if l_occurrences.is_empty then
				extend (1, a_string.count)
			else
				from l_occurrences.start until l_occurrences.after loop
					extend (upper_integer (last_interval) + 1, l_occurrences.item_lower - 1)
					last_interval := l_occurrences.item
					l_occurrences.forth
				end
				extend (upper_integer (last_interval)  + 1, a_string.count)
			end
		end

	make_empty
		do
			create string.make_empty
			create internal_item.make_empty
			Precursor
		end

	make_from_sub_list (list: like Current; a_start_index, a_end_index: INTEGER)
		do
			string := list.string
			create internal_item.make_empty
			Precursor (list, a_start_index, a_end_index)
		end

feature -- Basic operations

	append_item_to (str: like string)
		do
			str.append_substring (string, start_index, end_index)
		end

	do_all (action: PROCEDURE [like item])
		-- apply `action' for all delimited substrings
		do
			push_cursor
			set_operands (action)
			from start until after loop
				update_internal_item
				action.apply
				forth
			end
			pop_cursor
		end

feature -- Access

	first_item: S
		-- split item
		do
			push_cursor
			start
			if before then
				create Result.make_empty
			else
				Result := item
			end
			pop_cursor
		end

	item: S
		-- split item
		do
			update_internal_item
			Result := internal_item
		end

	last_item: S
		-- split item
		do
			push_cursor
			finish
			if after then
				create Result.make_empty
			else
				Result := item
			end
			pop_cursor
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
			set_operands (predicate)
			from start until not Result or after loop
				update_internal_item; predicate.apply
				Result := predicate.last_result
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
			if attached {like item} str as zstr then
				Result := has (zstr)
			else
				push_cursor
				from start until Result or after loop
					Result := item.same_string (str)
					forth
				end
				pop_cursor
			end
		end

	left_adjusted: BOOLEAN

	right_adjusted: BOOLEAN

	there_exists (predicate: PREDICATE [like item]): BOOLEAN
		-- `True' if one split substring matches `predicate'
		do
			push_cursor
			set_operands (predicate)
			from start until Result or after loop
				update_internal_item; predicate.apply
				Result := predicate.last_result
				forth
			end
			pop_cursor
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := string ~ other.string and then Precursor {EL_SEQUENTIAL_INTERVALS} (other)
		end

feature {NONE} -- Implementation

	set_operands (routine: ROUTINE [like item])
		do
			routine.set_operands ([internal_item])
		end

	update_internal_item
		local
			from_index: INTEGER; internal: like internal_item
		do
			internal := internal_item
			if attached {BAG [COMPARABLE]} internal as bag then
				bag.wipe_out
			end
			from_index := start_index
			if left_adjusted then
				from until from_index > end_index or else not string.item (from_index).is_space loop
					from_index := from_index + 1
				end
			end
			internal.append_substring (string, from_index, end_index)
			if right_adjusted then
				internal.right_adjust
			end
		end

feature {EL_SPLIT_STRING_LIST} -- Internal attributes

	internal_item: S

	string: S
end
