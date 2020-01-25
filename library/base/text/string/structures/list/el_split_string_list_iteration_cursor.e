note
	description: "Split string list iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 12:27:26 GMT (Saturday 25th January 2020)"
	revision: "1"

class
	EL_SPLIT_STRING_LIST_ITERATION_CURSOR [S -> STRING_GENERAL create make, make_empty end]

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

	target: EL_SPLIT_STRING_LIST [S]

end
