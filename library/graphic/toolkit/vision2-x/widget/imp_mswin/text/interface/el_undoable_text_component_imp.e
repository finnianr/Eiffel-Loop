note
	description: "Undoable text component imp"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-19 10:20:25 GMT (Friday 19th July 2024)"
	revision: "9"

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
				when {ASCII}.Ctrl_y, {ASCII}.Ctrl_z then
					Result := True
			else end
		end

	interface: EL_UNDOABLE_TEXT_COMPONENT
		deferred
		end

	empty_undo_buffer
		do
			{WEL_API}.send_message (wel_item, Em_emptyundobuffer, to_wparam (0), to_lparam (0))
		end

	wel_item: POINTER
		deferred
		end

end