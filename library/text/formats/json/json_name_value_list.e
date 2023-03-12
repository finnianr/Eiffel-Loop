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
	date: "2023-03-12 10:55:27 GMT (Sunday 12th March 2023)"
	revision: "17"

class
	JSON_NAME_VALUE_LIST

inherit
	JSON_PARSED_INTERVALS
		rename
			remove as remove_interval
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
	make

feature {NONE} -- Initialization

	make (a_utf_8_json: READABLE_STRING_8)
		do
			utf_8_json := a_utf_8_json
			create internal_utf_8_item.make (50)
			create internal_name.make (20)

			Precursor (a_utf_8_json)
		end

feature -- Basic operations

	find_field (name: READABLE_STRING_8)
		do
			from start until after or else item_same_as (name) loop
				forth
			end
		end

feature -- Status query

	item_same_as (name: READABLE_STRING_8): BOOLEAN
		require
			valid_item: not off
		local
			i: INTEGER
		do
			if attached area_v2 as a then
				i := (index - 1) * 2
				Result := utf_8_json.same_characters (name, 1, name.count, a [i])
			end
		end

feature -- Numeric Iteration items

	item_integer: INTEGER
		do
			Result := item_value_utf_8 (False).to_integer
		end

	item_natural_64: NATURAL_64
		do
			Result := item_value_utf_8 (False).to_natural_64
		end

feature -- Iteration items

	item_name (keep_ref: BOOLEAN): STRING
		require
			valid_item: not off
		local
			i, lower, upper: INTEGER
		do
			if attached area_v2 as a then
				i := (index - 1) * 2; lower := a [i]; upper := a [i + 1]
				if keep_ref then
					create Result.make (upper - lower + 1)
				else
					Result := internal_name
					Result.wipe_out
				end
				Result.append_substring (utf_8_json, a [i], a [i + 1])
			end
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

	item_immutable_value: IMMUTABLE_STRING_8
		-- item value encoded as UTF-8
		require
			valid_item: not off
		local
			i, lower, upper: INTEGER
		do
			if attached data_intervals_area as a and then attached cursor_8 (utf_8_json) as json then
				i := (index - 1) * 2; lower := a [i]; upper := a [i + 1]
				Result := Immutable_8.new_substring (json.area, json.area_first_index + lower - 1, upper - lower + 1)
			end
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

	internal_name: STRING

	internal_utf_8_item: STRING

	utf_8_json: STRING

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end