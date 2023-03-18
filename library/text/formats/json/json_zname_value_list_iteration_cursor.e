note
	description: "JSON name-value pair iteratation cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-18 7:54:10 GMT (Saturday 18th March 2023)"
	revision: "7"

class
	JSON_ZNAME_VALUE_LIST_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [TUPLE [name, value: ZSTRING]]

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
		do
			target:= a_target
			if target.count > 0 then
				cursor_index := 1
			end
		end

feature -- Access

	item: TUPLE [name, value: ZSTRING]
		do
			target.go_i_th (cursor_index)
			Result := [target.item_name (False), target.item_value (False)]
		end

	item_copy: like item
		do
			target.go_i_th (cursor_index)
			Result := [target.item_name (True), target.item_value (True)]
		end

	cursor_index: INTEGER

feature -- Status report	

	after: BOOLEAN
		-- Are there no more items to iterate over?
		do
			Result := not target.valid_index (cursor_index)
		end

feature -- Cursor movement

	forth
		-- Move to next position.
		do
			cursor_index := cursor_index + 1
		end

feature {TYPED_INDEXABLE_ITERATION_CURSOR} -- Access

	target: JSON_ZNAME_VALUE_LIST

end