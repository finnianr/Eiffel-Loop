note
	description: "Undoable text facility"
	notes: "[
		There were problems to make this work in Windows requiring overriding of on_en_change
		in WEL implementation to suppress default Ctrl-z action by emptying Windows undo buffer
		
		Also had to set ignore_character_code to true for Ctrl-y and Ctrl-z to stop annoying system ping.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-21 8:48:37 GMT (Friday 21st December 2018)"
	revision: "4"

deferred class
	EL_UNDOABLE_TEXT

inherit
	EV_TEXT_COMPONENT
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

	enable_undo
		do
			implementation.enable_undo
		end

	disable_undo
		do
			implementation.disable_undo
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

feature {EL_UNDOABLE_TEXT} -- Implementation

	implementation: EL_UNDOABLE_TEXT_COMPONENT_I

end
