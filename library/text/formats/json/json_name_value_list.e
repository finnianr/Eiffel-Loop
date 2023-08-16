note
	description: "[
		Parses a non-recursive JSON list into name value pairs assuming each field ends with a new line character. 
		Iterate using `from start until after loop'.
		Decoded name-value pairs accessible as: `item', `name_item' or  `value_item'.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 18:08:05 GMT (Monday 14th August 2023)"
	revision: "22"

class
	JSON_NAME_VALUE_LIST

inherit
	JSON_PARSED_INTERVALS
		rename
			remove as remove_interval,
			find_next as find_next_interval
		redefine
			make
		end

	JSON_CONSTANTS
		rename
			JSON as JSON_string
		end

	EL_SHARED_STRING_8_CURSOR

	EL_SHARED_IMMUTABLE_8_MANAGER

create
	make, make_grouped, make_parsed

feature {NONE} -- Initialization

	make (a_utf_8_json: READABLE_STRING_8)
		do
			if attached cursor_8 (a_utf_8_json) as json then
				utf_8_json := Immutable_8.new_substring (json.area, json.area_first_index, a_utf_8_json.count)
			end
			create internal_utf_8_item.make (50)
			create internal_name.make (20)

			Precursor (a_utf_8_json)
		end

feature -- Cursor movement

	find_field (name: READABLE_STRING_8)
		-- find first occurrence of `name' field starting from start
		do
			start; field_search (name)
		end

	field_search (name: READABLE_STRING_8)
		do
			from until after or else item_same_as (name) loop
				forth
			end
			if after then
				found_index := 0
			else
				found_index := index
			end
		end

	find_next
		-- find next occurrence of previous `find_field' search
		do
			if valid_index (found_index) then
				go_i_th (found_index)
				if attached item_immutable_name as name then
					forth; field_search (name)
				end
			end
		end

feature -- Status query

	item_same_as (name: READABLE_STRING_8): BOOLEAN
		require
			valid_item: not off
		local
			i, start_index, end_index: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				start_index := a [i]; end_index := a [i + 1]
			end
			if name.count = end_index - start_index + 1 then
				Result := utf_8_json.same_characters (name, 1, name.count, start_index)
			end
		end

feature -- Numeric Iteration items

	item_2D_double_array: JSON_2D_ARRAY [DOUBLE]
		-- 2 dimensional DOUBLE array
		do
			create Result.make (item_immutable_value)
		end

	item_2D_integer_array: JSON_2D_ARRAY [INTEGER]
		-- 2 dimensional INTEGER array of `width' columns
		do
			create Result.make (item_immutable_value)
		end

	item_integer: INTEGER
		do
			Result := item_value_utf_8 (False).to_integer
		end

	item_natural_64: NATURAL_64
		do
			Result := item_value_utf_8 (False).to_natural_64
		end

feature -- Iteration items

	compact_data_interval: INTEGER_64
		local
			ir: EL_INTERVAL_ROUTINES; i: INTEGER
		do
			if attached data_intervals_area as a then
				i := (index - 1) * 2
				Result := ir.compact (a [i], a [i + 1])
			end
		end

	item_immutable_name: IMMUTABLE_STRING_8
		require
			valid_item: not off
		local
			i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				Result := utf_8_json.shared_substring (a [i], a [i + 1])
			end
		end

	item_immutable_value: IMMUTABLE_STRING_8
		-- item value encoded as UTF-8
		require
			valid_item: not off
		local
			i: INTEGER
		do
			if attached data_intervals_area as a then
				i := (index - 1) * 2
				Result := utf_8_json.shared_substring (a [i], a [i + 1])
			end
		end

	item_name (keep_ref: BOOLEAN): STRING
		require
			valid_item: not off
		local
			start_index, end_index, i: INTEGER
		do
			i := (index - 1) * 2
			if attached area as a then
				start_index := a [i]; end_index := a [i + 1]
			end

			if keep_ref then
				create Result.make (end_index - start_index + 1)
			else
				Result := internal_name
				Result.wipe_out
			end
			Result.append_substring (utf_8_json, start_index, end_index)
		end

	item_boolean: BOOLEAN
		do
			Result := item_immutable_value.to_boolean
		end

	item_value (keep_ref: BOOLEAN): ZSTRING
		require
			valid_item: not off
		do
			if keep_ref then
				create Result.make_from_utf_8 (item_immutable_value)
			else
				Result := Buffer.empty
				Result.append_utf_8 (item_immutable_value)
			end
			Result.unescape (Unescaper)
		end

	item_value_utf_8 (keep_ref: BOOLEAN): STRING
		-- item value encoded as UTF-8
		require
			valid_item: not off
		local
			i, lower, upper: INTEGER
		do
			if attached data_intervals_area as a then
				i := (index - 1) * 2; lower := a [i]; upper := a [i + 1]
				if keep_ref then
					create Result.make (upper - lower + 1)
				else
					Result := internal_utf_8_item; Result.wipe_out
					Result.append_substring (utf_8_json, lower, upper)
				end
			end
		end

feature -- Removal

	remove
		-- Remove current item.
		-- Move cursor to right neighbor
		-- (or `after' if no right neighbor)
		require
			valid_item: not off
		do
			-- Remove data item
			if attached area_v2 as l_area then
				area_v2 := data_intervals_area
				remove_interval
				area_v2 := l_area
			end

			-- Remove name item
			remove_interval
		end

feature {NONE} -- Internal attributes

	found_index: INTEGER

	internal_name: STRING

	internal_utf_8_item: STRING

	utf_8_json: IMMUTABLE_STRING_8

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end