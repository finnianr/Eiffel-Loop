note
	description: "Abstraction for undoable text input"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-05 12:09:02 GMT (Saturday 5th April 2025)"
	revision: "16"

deferred class
	EL_UNDOABLE_TEXT_COMPONENT_I

inherit
	EV_TEXT_COMPONENT_I
		export
			{EL_TEXT_EDITION_HISTORY} delete_selection, paste, select_all, select_region
		end

	EL_READABLE_STRING_GENERAL_ROUTINES_I
		export
			{NONE} all
		end

	EL_OS_DEPENDENT

	EL_STRING_32_CONSTANTS

feature {NONE} -- Initialization

	make
		do
			create edit_history.make (Current, 100)
		end

feature {EL_UNDOABLE_TEXT_COMPONENT, EL_UNDOABLE_TEXT_COMPONENT_I} -- Access

	caret_position: INTEGER
		deferred
		end

	edit_history: EL_TEXT_EDITION_HISTORY

	text: STRING_32
		deferred
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Element change

	set_edit_history_from_other (other: EL_UNDOABLE_TEXT_COMPONENT_I)
		do
			edit_history := other.edit_history
		end

	set_initial_text (a_text: READABLE_STRING_GENERAL)
		do
			state := Redoing
			edit_history.set_string_from_general (a_text)
			set_text (to_unicode_general (a_text))
			state := Normal
		end

feature {EL_TEXT_EDITION_HISTORY} -- Deferred

	set_caret_position (a_caret_position: INTEGER)
		deferred
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Status query

	has_redo_items: BOOLEAN
		do
			Result := edit_history.has_redo_items
		end

	has_undo_items: BOOLEAN
		do
			Result := not edit_history.is_empty
		end

	is_undo_enabled: BOOLEAN

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Status setting

	set_undo (enabled: BOOLEAN)
		do
			is_undo_enabled := enabled
			if not enabled then
				edit_history.wipe_out
			end
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Basic operations

	redo
		do
			if is_undo_enabled and then has_redo_items then
				state := Redoing
				edit_history.redo
				set_caret_position (edit_history.caret_position)
				state := Normal
			end
		end

	undo
		do
			if is_undo_enabled and then has_undo_items then
				state := Undoing
				edit_history.undo
				set_caret_position (edit_history.caret_position)
				state := Normal
			end
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Event handling

	on_change_actions
		do
			if is_undo_enabled and then state = Normal then
				if edit_history.is_in_default_state then
					edit_history.set_string_from_general (Empty_string_32)
				end
				if not edit_history.string.same_string (text) then
					edit_history.extend_from_general (text)
				end
			end
		end

feature {EL_UNDOABLE_TEXT_COMPONENT_I, EL_TEXT_EDITION_HISTORY} -- Implementation

	state: NATURAL_8

feature {NONE} -- Constants

	Normal: NATURAL_8 = 0

	Redoing: NATURAL_8 = 1

	Undoing: NATURAL_8 = 2

end