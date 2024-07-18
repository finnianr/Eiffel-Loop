note
	description: "Undoable text facility"
	notes: "[
		There were problems to make this work in Windows requiring overriding of on_en_change
		in WEL implementation to suppress default Ctrl-z action by emptying Windows undo buffer
		
		Also had to set ignore_character_code to true for Ctrl-y and Ctrl-z to stop annoying system ping.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 15:39:07 GMT (Thursday 18th July 2024)"
	revision: "8"

deferred class
	EL_UNDOABLE_TEXT_COMPONENT

inherit
	EL_TEXT_COMPONENT
		redefine
			implementation
		end

feature -- Element change

	set_edit_history_from_other (other: like Current)
		do
			implementation.set_edit_history_from_other (other.implementation)
		end

feature -- Status query

	has_clipboard_content: BOOLEAN
		do
			Result := not clipboard_content.is_empty
		end

	has_redo_items: BOOLEAN
		do
			Result := implementation.has_redo_items
		end

	has_undo_items: BOOLEAN
		do
			Result := implementation.has_undo_items
		end

feature -- Status setting

	disable_undo
		do
			set_undo (False)
		end

	enable_undo
		do
			set_undo (True)
		end

	set_undo (enabled: BOOLEAN)
		do
			implementation.set_undo (enabled)
		end

feature -- Basic operations

	redo
		do
			implementation.redo
			if has_word_wrapping then
				scroll_to_line (line_number_from_position (caret_position))
			end
		end

	undo
		do
			implementation.undo
			if has_word_wrapping then
				scroll_to_line (line_number_from_position (caret_position))
			end
		end

feature -- Element change

	set_initial_text (a_text: READABLE_STRING_GENERAL)
		-- set text without triggering `change_actions'
		do
			change_actions.block
			implementation.set_initial_text (a_text)
			change_actions.resume
		end

feature {NONE} -- Deferred

	has_word_wrapping: BOOLEAN
		deferred
		end

	line_number_from_position (i: INTEGER): INTEGER
		deferred
		end

	scroll_to_line (i: INTEGER)
		deferred
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Internal attributes

	implementation: EL_UNDOABLE_TEXT_COMPONENT_I

end