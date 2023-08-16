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
	date: "2023-08-08 9:31:40 GMT (Tuesday 8th August 2023)"
	revision: "47"

class
	EL_SPLIT_STRING_LIST [S -> STRING_GENERAL create make end]

inherit
	EL_SPLIT_READABLE_STRING_LIST [S]
		rename
			circular_i_th as circular_i_th_copy,
			first_item as first_item_copy,
			i_th as i_th_copy,
			item as item_copy,
			joined as joined_list,
			last_item as last_item_copy
		undefine
			do_all, do_if, find_first_equal, find_next_item, for_all, to_array, there_exists, search
		redefine
			make_empty, new_cursor
		end

	EL_LINEAR_STRINGS [S]
		rename
			item as item_copy
		undefine
			copy, character_count, do_meeting, has, is_equal, off, out, occurrences, push_cursor, pop_cursor
		redefine
			character_count
		end

create
	make_by_string, make_adjusted, make_adjusted_by_string, make_empty, make

feature {NONE} -- Initialization

	make_empty
		do
			Precursor
			create internal_item.make (0)
		end

feature -- Access

	new_cursor: EL_SPLIT_STRING_ITERATION_CURSOR [S]
		do
			create Result.make (Current)
		end

feature -- Basic operations

	append_i_th_to (a_i: INTEGER; str: like target_string)
		require
			valid_index: valid_index (a_i)
		local
			i: INTEGER
		do
			i := (a_i - 1) * 2
			if attached area as a then
				str.append_substring (target_string, a [i], a [i + 1])
			end
		end

	append_item_to (str: like target_string)
		require
			valid_index: not off
		do
			append_i_th_to (index, str)
		end

feature -- Shared items

	circular_i_th (i: INTEGER): S
		local
			j: INTEGER
		do
			Result := empty_item
			j := modulo (i, count) * 2
			if count > 0 and then attached area as a then
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

feature -- Element change

	append_string (str: S)
		do
			if attached area.aliased_resized_area (area.count + 2) as intervals then
				if target_string = default_target then
					target_string := str.twin
					intervals.extend (1); intervals.extend (str.count)
				else
					target_string.append (str)
					intervals.extend (last_upper + 1); intervals.extend (target_string.count)
				end
				area := intervals
			end
		end

	trim_string
		do
		end

feature -- Conversion

	as_list: EL_STRING_LIST [S]
		local
			i: INTEGER
		do
			create Result.make (count)
			push_cursor
			if attached area as a then
				from start until after loop
					i := (index - 1) * 2
					Result.extend (target_string.substring (a [i], a [i + 1]))
					forth
				end
			end
			pop_cursor
		end

feature {NONE} -- Implementation

	append_substring (str: S; lower, upper: INTEGER)
		do
			str.append_substring (target_string, lower, upper)
		end

	empty_item: S
		do
			Result := internal_item
			Result.keep_head (0)
		end

feature {NONE} -- Internal attributes

	internal_item: S

end