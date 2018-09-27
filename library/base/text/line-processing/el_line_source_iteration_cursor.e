note
	description: "Line source iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_LINE_SOURCE_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [ZSTRING]

create
	make

feature {NONE} -- Initialization

	make (a_lines: like lines)
		do
			lines := a_lines
		end

feature -- Access

	item: ZSTRING
			-- Item at current cursor position.
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

	lines: LINEAR [ZSTRING]

end