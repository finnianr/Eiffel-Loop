note
	description: "JSON name-value pair iteratation cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-22 8:28:44 GMT (Wednesday 22nd June 2022)"
	revision: "4"

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
			Result := [target.name_item (False), target.value_item (False)]
		end

	item_copy: like item
		do
			target.go_i_th (cursor_index)
			Result := [target.name_item (True), target.value_item (True)]
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
