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
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "16"

class
	JSON_NAME_VALUE_LIST

inherit
	JSON_FIELD_NAME_INTERVALS
		export
			{NONE} all
			{ANY} go_i_th, start, forth, after, off, count, index, valid_index
		end

	JSON_CONSTANTS

create
	make

feature -- Iteration items

	name_item (keep_ref: BOOLEAN): STRING
		require
			valid_item: not off
		do
			Result := item_name
			if keep_ref then
				Result := Result.twin
			end
		end

	value_item (keep_ref: BOOLEAN): ZSTRING
		require
			valid_item: not off
		do
			Result := Buffer.empty
			Result.append_utf_8 (value_item_8 (False))
			Result.unescape (Unescaper)
			if keep_ref then
				Result := Result.twin
			end
		end

	value_item_8 (keep_ref: BOOLEAN): STRING
		require
			valid_item: not off
		do
			Result := item_utf_8_value
			if keep_ref then
				Result := Result.twin
			end
		end

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

note
	notes: "[
		This parser assumes that JSON fields are delimited by the newline character as for example:

			{
				"name": "John Smith",
				"city": "New York",
				"gender": "♂",
				"age": 45
			}

	]"

end