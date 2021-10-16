note
	description: "[
		Parses a non-recursive JSON list into name value pairs assuming each field ends with a new line character. 
		Iterate using `from start until after loop'.
		Decoded name-value pairs accessible as: `item', `name_item' or  `value_item'.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-16 10:44:46 GMT (Saturday 16th October 2021)"
	revision: "10"

class
	EL_JSON_NAME_VALUE_LIST

inherit
	LINEAR [TUPLE [name, value: ZSTRING]]
		redefine
			off
		end

create
	make

feature {NONE} -- Initialization

	make (utf_8: STRING)
		require
			new_line_delimited: utf_8.has ('%N')
		local
			pos_colon: INTEGER
		do
			create split_list.make_with_character (create {ZSTRING}.make_from_utf_8 (utf_8), '%N')
			from split_list.start until split_list.after loop
				if attached split_list.item (False) as line then
					pos_colon := line.index_of (':', 1)
					if pos_colon > 0 and then line.last_index_of ('"', pos_colon) > 0 then
						split_list.forth
					else
						split_list.remove
					end
				end
			end
			count := split_list.count
		end

feature -- Access

	count: INTEGER

	index: INTEGER

feature -- Iteration items

	item: like item_for_iteration
		do
			Result := [name_item (False), value_item]
		end

	name_item (keep_ref: BOOLEAN): ZSTRING
		local
			line: ZSTRING; pos_colon, pos_quote_end, pos_quote_start: INTEGER
		do
			Result := Buffer.empty
			split_list.go_i_th (index)
			line := split_list.item (False)
			pos_colon := line.index_of (':', 1)
			if pos_colon > 0 then
				pos_quote_end := line.last_index_of ('"', pos_colon)
				pos_quote_start := line.index_of ('"', 1)
				if pos_quote_start > 0 and then pos_quote_start < pos_quote_end then
					Result.append_substring (line, pos_quote_start + 1, pos_quote_end - 1)
					Result.unescape (Unescaper)
				end
			end
			if keep_ref then
				Result := Result.twin
			end
		end

	name_item_8 (keep_ref: BOOLEAN): STRING
		do
			Result := Buffer_latin_1.copied_general (name_item (False))
			if keep_ref then
				Result := Result.twin
			end
		end

	value_item: ZSTRING
		local
			line: ZSTRING; pos_colon, pos_quote: INTEGER
		do
			split_list.go_i_th (index)
			line := split_list.item (False)
			pos_colon := line.index_of (':', 1)
			if pos_colon > 0 then
				pos_quote := line.index_of ('"', pos_colon + 1)
				if pos_quote > 0 then
					Result := line.substring (pos_quote + 1, line.last_index_of ('"', line.count) - 1)

				elseif line.valid_index (pos_colon + 1) and then line.is_space_item (pos_colon + 1) then
					Result := line.substring_end (pos_colon + 2)
					Result.prune_all_trailing (',')
				else
					Result := line.substring_end (pos_colon + 1)
					Result.prune_all_trailing (',')
				end
				Result.unescape (Unescaper)
			else
				create Result.make_empty
			end
		end

feature -- Cursor movement

	finish
		do
			index := count
		end

	forth
		do
			index := index + 1
		end

	start
		do
			index := 1
		end

feature -- Status query

	after: BOOLEAN
		do
			Result := index > count
		end

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	off: BOOLEAN
			-- Is there no current item?
		do
			Result := (index = 0) or (index = count + 1)
		end

feature {NONE} -- Internal attributes

	split_list: EL_SPLIT_ZSTRING_LIST

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

	Buffer_latin_1: EL_STRING_8_BUFFER
		once
			create Result
		end

	Unescaper: EL_JSON_UNESCAPER
		once
			create Result.make
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