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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 16:03:04 GMT (Monday 5th December 2022)"
	revision: "36"

class
	EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]

inherit
	EL_SPLIT_READABLE_STRING_LIST [S]
		rename
			circular_i_th as circular_i_th_copy,
			first_item as first_item_copy,
			i_th as i_th_copy,
			item as item_copy,
			last_item as last_item_copy
		redefine
			make_empty
		end

	EL_LINEAR_STRINGS [S]
		undefine
			copy, is_equal, off, out
		redefine
			character_count, has
		select
			index_of, occurrences, to_array, do_if, search, inverse_query_if,
			query_if, query_not_in, query_in, intersection,
			current_linear, find_first_equal, find_next_item, do_all, for_all, has, item,
			there_exists
		end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make

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
		do
			Result := empty_item
			append_substring (Result, circular_i_th_interval (i))
		end

	first_item: S
		do
			Result := empty_item
			if count > 0 then
				append_substring (Result, first_interval)
			end
		end

	i_th (i: INTEGER): S
		do
			Result := empty_item
			append_substring (Result, i_th_interval (i))
		end

	item: S
		-- current iteration split item
		-- (DO NOT KEEP REFERENCES)
		do
			Result := empty_item
			if not off then
				append_substring (Result, interval_item)
			end
		end

	last_item: S
		-- last split item
		-- (DO NOT KEEP REFERENCES)
		do
			Result := empty_item
			if count > 0 then
				append_substring (Result, last_interval)
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

	append_substring (str: S; interval: INTEGER_64)
		do
			str.append_substring (target, lower_integer (interval), upper_integer (interval))
		end

	empty_item: S
		do
			Result := internal_item
			Result.keep_head (0)
		end

feature {NONE} -- Internal attributes

	internal_item: S

end