note
	description: "Undoable text component i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-05 17:15:17 GMT (Tuesday 5th February 2019)"
	revision: "7"

deferred class
	EL_UNDOABLE_TEXT_COMPONENT_I

inherit
	EV_TEXT_COMPONENT_I

feature {NONE} -- Initialization

	make
		do
			create edit_history.make (100)
		end

feature {EL_UNDOABLE_TEXT_COMPONENT, EL_UNDOABLE_TEXT_COMPONENT_I} -- Access

	edit_history: EL_ZSTRING_EDITION_HISTORY

	text: STRING_32
		deferred
		end

	caret_position: INTEGER
		deferred
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Element change

	set_initial_text (a_text: READABLE_STRING_GENERAL)
		do
			is_restoring := True
			edit_history.set_string_from_general (a_text)
			set_text (a_text.to_string_32)
			is_restoring := False
		end

	set_edit_history_from_other (other: EL_UNDOABLE_TEXT_COMPONENT_I)
		do
			edit_history := other.edit_history
		end

	set_caret_position (a_caret_position: INTEGER)
		deferred
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Status query

	has_undo_items: BOOLEAN
		do
			Result := not edit_history.is_empty
		end

	has_redo_items: BOOLEAN
		do
			Result := edit_history.has_redo_items
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

	undo
		do
			if is_undo_enabled and then has_undo_items then
				edit_history.undo; restore
			end
		end

	redo
		do
			if is_undo_enabled and then has_redo_items then
				edit_history.redo; restore
			end
		end

feature {EL_UNDOABLE_TEXT_COMPONENT} -- Event handling

	on_change_actions
		do
			if is_undo_enabled and then not is_restoring then
				if edit_history.is_in_default_state then
					edit_history.set_string_from_general (text)
				elseif not edit_history.string.same_string (text) then
					edit_history.extend_from_general (text)
				end
			end
		end

feature {EL_UNDOABLE_TEXT_COMPONENT_I} -- Implementation

	restore
			-- restore result of redo or undo
		do
			is_restoring := True
			set_text (edit_history.string.to_unicode)
			set_caret_position (edit_history.caret_position)
			is_restoring := False
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		deferred
		end

	is_restoring: BOOLEAN

end
