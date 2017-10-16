note
	description: "Summary description for {EL_TEXT_COMPONENT_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_UNDOABLE_TEXT_COMPONENT_IMP

inherit
	WEL_EM_CONSTANTS
		export
			{NONE} all
		end

	WEL_DATA_TYPE
		export
			{NONE} all
		end

feature {NONE} -- Implementation

	ignore_character_code (a_character_code: INTEGER): BOOLEAN
			 -- Needed to make EL_UNDOABLE_TEXT work
		do
			inspect a_character_code
				when Ctrl_y, Ctrl_z then
					Result := True

			else end
		end

	empty_undo_buffer
		do
			{WEL_API}.send_message (wel_item, Em_emptyundobuffer, to_wparam (0), to_lparam (0))
		end

	wel_item: POINTER
		deferred
		end

feature {NONE} -- Constants

	Ctrl_y: INTEGER = 25

	Ctrl_z: INTEGER = 26

end