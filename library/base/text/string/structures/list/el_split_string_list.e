note
	description: "[
		A virtual split-list of strings conforming to [$source STRING_GENERAL] represented
		as an array of substring intervals
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
	date: "2023-03-29 10:53:26 GMT (Wednesday 29th March 2023)"
	revision: "42"

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
		rename
			has as has_item
		undefine
			copy, character_count, is_equal, off, out
		redefine
			character_count, has_item
		select
			index_of, occurrences, to_array, do_if, search, inverse_query_if,
			query_if, query_not_in, query_in, intersection, has_item,
			current_linear, find_first_equal, find_next_item, do_all, for_all, item,
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
		require
			valid_index: not off
		do
			append_i_th_to (index, str)
		end

	append_i_th_to (i: INTEGER; str: like target)
		require
			valid_index: valid_index (i)
		local
			lower, upper: INTEGER
		do
			lower := i_th_lower_upper (i, $upper)
			str.append_substring (target, lower, upper)
		end

feature -- Shared items

	circular_i_th (i: INTEGER): S
		local
			j: INTEGER
		do
			Result := empty_item
			j := modulo (i, count) * 2
			if count > 0 and then attached area_v2 as a then
				append_substring (Result, a [j], a [j + 1])
			end
		end

	first_item: S
		do
			Result := empty_item
			if count > 0 then
				append_i_th_to (1, Result)
			end
		end

	i_th (i: INTEGER): S
		do
			Result := empty_item
			append_i_th_to (i, Result)
		end

	item: S
		-- current iteration split item
		-- (DO NOT KEEP REFERENCES)
		do
			Result := empty_item
			append_item_to (Result)
		end

	last_item: S
		-- last split item
		-- (DO NOT KEEP REFERENCES)
		do
			Result := empty_item
			if count > 0 then
				append_i_th_to (count, Result)
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

feature -- Status query

	has_item (str: like item): BOOLEAN
		do
			Result := has (str)
		end

feature {NONE} -- Implementation

	append_substring (str: S; lower, upper: INTEGER)
		do
			str.append_substring (target, lower, upper)
		end

	empty_item: S
		do
			Result := internal_item
			Result.keep_head (0)
		end

feature {NONE} -- Internal attributes

	internal_item: S

end