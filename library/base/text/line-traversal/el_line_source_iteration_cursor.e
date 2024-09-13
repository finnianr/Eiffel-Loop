note
	description: "Line source iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-13 14:20:17 GMT (Friday 13th September 2024)"
	revision: "9"

class
	EL_LINE_SOURCE_ITERATION_CURSOR [S -> STRING_GENERAL create make end]

inherit
	ITERATION_CURSOR [S]
		rename
			item as shared_item
		end

create
	make

feature {NONE} -- Initialization

	make (a_lines: like lines)
		do
			lines := a_lines
		end

feature -- Access

	item_copy: S
		do
			Result := lines.item.twin
		end

	shared_item: S
			-- item at current cursor position.
		do
			Result := lines.item
		end

feature -- Measurement

	cursor_index: INTEGER
		do
			Result := lines.index
		end

	item_count: INTEGER
		do
			Result := lines.item.count
		end

feature -- Status report	

	after: BOOLEAN
		do
			Result := lines.after
		end

feature -- Cursor movement

	forth
			--
		do
			lines.forth
		end

	start
			-- Move to first position if any.
		do
			lines.start
		end

feature {NONE} -- Implementation

	lines: LINEAR [S]

end