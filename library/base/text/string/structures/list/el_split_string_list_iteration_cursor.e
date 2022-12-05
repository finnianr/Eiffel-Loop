note
	description: "[
		Iteration cursor for objects conforming to [$source EL_SPLIT_READABLE_STRING_LIST]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:48:09 GMT (Monday 5th December 2022)"
	revision: "5"

class
	EL_SPLIT_STRING_LIST_ITERATION_CURSOR [S -> READABLE_STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

create
	make

feature {NONE} -- Initialization

	make (a_target: like target)
		do
			target:= a_target
			if not target.is_empty then
				cursor_index := 1
			end
		end

feature -- Access

	item: S
		do
			Result := target.i_th (cursor_index)
		end

	item_copy: S
		do
			Result := item.twin
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

	target: EL_SPLIT_READABLE_STRING_LIST [S]

end