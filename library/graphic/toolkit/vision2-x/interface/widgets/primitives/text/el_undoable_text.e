note
	description: "Undoable text facility"

	notes: "[
		There were problems to make this work in Windows requiring overriding of on_en_change
		in WEL implementation to suppress default Ctrl-z action by emptying Windows undo buffer
		
		Also had to set ignore_character_code to true for Ctrl-y and Ctrl-z to stop annoying system ping.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-20 13:44:27 GMT (Saturday 20th December 2014)"
	revision: "4"

deferred class
	EL_UNDOABLE_TEXT

feature -- Access

	clipboard_content: STRING_32
			-- `Result' is current clipboard content.
		deferred
		end

	caret_position: INTEGER
		deferred
		end

	text: STRING_32
		deferred
		end

feature -- Element change

	set_edit_history_from_other (other: like Current)
		do
			implementation.set_edit_history_from_other (other.implementation)
		end

feature -- Status query

	has_focus: BOOLEAN
		deferred
		end

	has_selection: BOOLEAN
		deferred
		end

	has_undo_items: BOOLEAN
		do
			Result := implementation.has_undo_items
		end

	has_redo_items: BOOLEAN
		do
			Result := implementation.has_redo_items
		end

feature -- Status setting

	enable_undo
		do
			implementation.enable_undo
		end

	disable_undo
		do
			implementation.disable_undo
		end

feature -- Basic operations

	cut_selection
		deferred
		end

	copy_selection
		deferred
		end

	paste (a_position: INTEGER)
		deferred
		end

	select_all
		deferred
		end

	undo
		do
			implementation.undo
		end

	redo
		do
			implementation.redo
		end

feature {EL_UNDOABLE_TEXT} -- Implementation

	implementation: EL_UNDOABLE_TEXT_COMPONENT_I
		deferred
		end

	pointer_button_release_actions: EV_POINTER_BUTTON_ACTION_SEQUENCE
		deferred
		end

	focus_in_actions: EV_NOTIFY_ACTION_SEQUENCE
		deferred
		end

end
