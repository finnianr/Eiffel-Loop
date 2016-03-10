note
	description: "Summary description for {EL_FILE_STRING_LIST_ITERATION_CURSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_LINE_SOURCE_ITERATION_CURSOR [F -> FILE]

inherit
	ITERATION_CURSOR [EL_ASTRING]

create
	make

feature {NONE} -- Initialization

	make (a_line_source: like line_source)
		do
			line_source := a_line_source
			source := a_line_source.source_copy
			create item.make_empty
		end

feature -- Access

	item: EL_ASTRING
			-- Item at current cursor position.

	cursor_index: INTEGER

feature -- Status report	

	after: BOOLEAN
			--
		do
			Result := source.off
		end

feature -- Cursor movement

	start
			-- Move to first position if any.
		do
			cursor_index := 0
			source.open_read
			forth
		end

	forth
			--
		do
			item := line_source.next_line (source)
			cursor_index := cursor_index + 1
			if after then
				source.close
			end
		end

feature {NONE} -- Implementation

	line_source: EL_LINE_SOURCE [F]

	source: F

end