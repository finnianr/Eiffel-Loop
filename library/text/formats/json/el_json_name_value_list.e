note
	description: "[
		Parses a non-recursive JSON list into name value pairs. Iterate using `from start until after loop'.
		Decoded name-value pairs accessible as: `item', `name_item' or  `value_item'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-19 13:04:40 GMT (Wednesday 19th September 2018)"
	revision: "4"

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
		local
			l_string: ZSTRING
		do
			create name_8.make (20)
			create l_string.make_from_utf_8 (utf_8)
			l_string.replace_substring_all (Escaped_quotation_mark, Utf_16_quotation_mark)
			create split_list.make (l_string, Quotation_mark)
			count := (split_list.count - 1) // 4
		ensure
			exactly_divisable: (split_list.count - 1) \\ 4 = 0
		end

feature -- Access

	count: INTEGER

	index: INTEGER

feature -- Iteration items

	item: like item_for_iteration
		do
			Result := [name_item, value_item]
		end

	name_item_8: STRING
		do
			Result := name_8
			name_8.wipe_out
			name_item.append_to_string_8 (name_8)
		end

	name_item: ZSTRING
		do
			split_list.go_i_th (list_index)
			create Result.make_unescaped (Unescaper, split_list.item)
		end

	value_item: ZSTRING
		do
			split_list.go_i_th (list_index + 2)
			create Result.make_unescaped (Unescaper, split_list.item)
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

feature {NONE} -- Implementation

	list_index: INTEGER
		do
			Result := 2 + (index - 1) * 4
		end

feature {NONE} -- Internal attributes

	split_list: EL_SPLIT_ZSTRING_LIST

	name_8: STRING

feature {NONE} -- Constants

	Escaped_quotation_mark: ZSTRING
		once
			Result := "\%""
		end

	Utf_16_quotation_mark: ZSTRING
		once
			Result := "\u0022"
		end

	Quotation_mark: ZSTRING
		once
			Result := "%""
		end

	Unescaper: EL_JSON_UNESCAPER
		once
			create Result.make
		end

end
