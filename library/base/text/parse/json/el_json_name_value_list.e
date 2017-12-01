note
	description: "[
		Parses a non-recursive JSON list into name value pairs. Iterate using `from start until after loop'.
		Decoded name-value pairs accessible as: `item', `name_item' or  `value_item'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-28 11:45:04 GMT (Tuesday 28th November 2017)"
	revision: "1"

class
	EL_JSON_NAME_VALUE_LIST

inherit
	LINEAR [TUPLE [name, value: ZSTRING]]

	EL_JSON_ROUTINES
		undefine
			is_equal, copy, out
		end

create
	make

feature {NONE} -- Initialization

	make (a_string: STRING)
		do
			create split_list.make (a_string, Quotation_mark)
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

	name_item: ZSTRING
		do
			split_list.go_i_th (list_index)
			Result := decoded (split_list.item)
		end

	name_item_8: STRING
		-- `twin' this if keeping a copy
		do
			split_list.go_i_th (list_index)
			Result := split_list.item
		end

	value_item: ZSTRING
		do
			split_list.go_i_th (list_index + 2)
			Result := decoded (split_list.item)
		end

	value_item_8: STRING
		-- `twin' this if keeping a copy
		do
			split_list.go_i_th (list_index + 2)
			Result := split_list.item
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

feature {NONE} -- Implementation

	list_index: INTEGER
		do
			Result := 2 + (index - 1) * 4
		end

feature {NONE} -- Internal attributes

	split_list: EL_SPLIT_STRING_LIST [STRING]

end
