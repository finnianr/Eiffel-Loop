note
	description: "Summary description for {EL_FILE_STRING_LIST_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 13:48:40 GMT (Monday 16th May 2016)"
	revision: "6"

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