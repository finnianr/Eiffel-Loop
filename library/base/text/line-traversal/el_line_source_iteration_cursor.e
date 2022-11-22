note
	description: "Line source iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 7:08:59 GMT (Tuesday 22nd November 2022)"
	revision: "8"

class
	EL_LINE_SOURCE_ITERATION_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]

create
	make

feature {NONE} -- Initialization

	make (a_lines: like lines)
		do
			lines := a_lines
		end

feature -- Access

	item: S
			-- item at current cursor position.
		do
			Result := lines.item
		end

	cursor_index: INTEGER
		do
			Result := lines.index
		end

feature -- Status report	

	after: BOOLEAN
		do
			Result := lines.after
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			lines.start
		end

	forth
			--
		do
			lines.forth
		end

feature {NONE} -- Implementation

	lines: LINEAR [S]

end