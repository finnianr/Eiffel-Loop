note
	description: "[
		A virtual split-list of strings conforming to [$source STRING_GENERAL] represented
		as an array of [$INTEGER_64] substring intervals
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
	date: "2022-10-17 12:38:28 GMT (Monday 17th October 2022)"
	revision: "32"

class
	EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]

inherit
	EL_SPLIT_READABLE_STRING_LIST [S]
		redefine
			i_th, item, make_empty
		end

	EL_LINEAR_STRINGS [S]
		undefine
			copy, is_equal, off, out
		redefine
			character_count, has
		select
			index_of, occurrences, to_array, do_if, search, inverse_query_if, query_if,
			current_linear, find_first_equal, find_next_item, do_all, for_all, has, item,
			there_exists
		end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make_from_sub_list, make

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			create internal_item.make (0)
		end

feature -- Basic operations

	append_item_to (str: like target)
		do
			str.append_substring (target, item_start_index, item_end_index)
		end

feature -- Shared items

	circular_i_th (i: INTEGER): S
		local
			interval: INTEGER_64
		do
			interval := circular_i_th_interval (i)
			Result := empty_item
			Result.append_substring (target, lower_integer (interval), upper_integer (interval))
		end

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
			Result := empty_item
			if not off then
				interval := interval_item
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

	first_item_copy: S
		do
			if count = 0 then
				Result := empty_item
			else
				Result := i_th (1)
			end
		end

	last_item_copy: S
		do
			if count = 0 then
				Result := empty_item
			else
				Result := i_th_copy (count)
			end
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

	set_target (a_target: like item; delimiter: CHARACTER_32; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
			fill (a_target, delimiter, a_adjustments)
		ensure then
			reversible: a_adjustments = 0 implies as_list.joined (delimiter).same_string (a_target)
		end

	set_target_by_string (a_target: like item; delimiter: READABLE_STRING_GENERAL; a_adjustments: INTEGER)
		do
			target := a_target; adjustments := a_adjustments
			fill_by_string (a_target, delimiter, a_adjustments)
		ensure then
			reversible: a_adjustments = 0 implies as_list.joined_with_string (delimiter).same_string (a_target)
		end

feature -- Status query

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

feature {NONE} -- Implementation

	empty_item: S
		do
			Result := internal_item
			Result.keep_head (0)
		end

feature {NONE} -- Internal attributes

	internal_item: S

end