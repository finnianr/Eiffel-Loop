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
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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

	has_undo_items: BOOLEAN
		do
			Result := implementation.has_undo_items
		end

	has_redo_items: BOOLEAN
		do
			Result := implementation.has_redo_items
		end

	has_clipboard_content: BOOLEAN
		do
			Result := not clipboard_content.is_empty
		end

feature -- Status setting

	set_undo (enabled: BOOLEAN)
		do
			implementation.set_undo (enabled)
		end

	enable_undo
		do
			set_undo (True)
		end

	disable_undo
		do
			set_undo (False)
		end

feature -- Basic operations

	undo
		do
			implementation.undo
		end

	redo
		do
			implementation.redo
		end

feature -- Element change

	set_initial_text (a_text: READABLE_STRING_GENERAL)
		-- set text without triggering `change_actions'
		do
			change_actions.block
			implementation.set_initial_text (a_text)
			change_actions.resume
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Implementation

	implementation: EL_UNDOABLE_TEXT_COMPONENT_I

end