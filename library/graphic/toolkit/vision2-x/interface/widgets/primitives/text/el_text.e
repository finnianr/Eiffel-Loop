note
	description: "Summary description for {EL_TEXT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TEXT

inherit
	EV_TEXT
		redefine
			initialize, paste
		end

	EL_UNDOABLE_TEXT
		rename
			make as make_undoable
		undefine
			default_create, copy
		end

create
	default_create

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			make_undoable
		end

feature -- Basic operations

	paste (a_position: INTEGER)
			-- Insert text from `clipboard' at `a_position'.
			-- No effect if clipboard is empty.
		local
			old_caret_position: INTEGER
		do
			old_caret_position := caret_position
			implementation.paste (a_position)
			if old_caret_position = a_position then
				set_caret_position (old_caret_position)
			end
		end

end
