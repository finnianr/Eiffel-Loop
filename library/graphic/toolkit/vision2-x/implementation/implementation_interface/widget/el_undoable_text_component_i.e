note
	description: "Summary description for {EL_UNDOABLE_TEXT_COMPONENT_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-21 12:41:56 GMT (Sunday 21st December 2014)"
	revision: "3"

deferred class
	EL_UNDOABLE_TEXT_COMPONENT_I

feature {NONE} -- Initialization

	make
		do
			create edit_history.make (100)
		end

feature {EL_UNDOABLE_TEXT_COMPONENT_I} -- Access

	edit_history: EL_STRING_32_EDITION_HISTORY

	text: STRING_32
		deferred
		end

	caret_position: INTEGER
		deferred
		end

feature {EL_UNDOABLE_TEXT} -- Element change

	set_edit_history_from_other (other: EL_UNDOABLE_TEXT_COMPONENT_I)
		do
			edit_history := other.edit_history
		end

	set_caret_position (a_caret_position: INTEGER)
		deferred
		end

feature {EL_UNDOABLE_TEXT} -- Status query

	has_undo_items: BOOLEAN
		do
			Result := not edit_history.is_empty
		end

	has_redo_items: BOOLEAN
		do
			Result := edit_history.has_redo_items
		end

	is_undo_enabled: BOOLEAN

feature {EL_UNDOABLE_TEXT} -- Status setting

	enable_undo
		do
			if not is_undo_enabled then
				is_undo_enabled := True
			end
		end

	disable_undo
		do
			if is_undo_enabled then
				is_undo_enabled := False
				edit_history.wipe_out
			end
		end

feature {EL_UNDOABLE_TEXT} -- Basic operations

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

feature {EL_UNDOABLE_TEXT} -- Event handling

	on_change_actions
		do
			if is_undo_enabled and then not is_restoring then
				if edit_history.is_in_default_state then
					edit_history.set_string (text)

				elseif text /~ edit_history.string then
					edit_history.extend (text)
				end
			end
		end

feature {EL_UNDOABLE_TEXT_COMPONENT_I} -- Implementation

	restore
			-- restore result of redo or undo
		do
			is_restoring := True
			set_text (edit_history.string)
			set_caret_position (edit_history.caret_position)
			is_restoring := False
		end

	set_text (a_text: READABLE_STRING_GENERAL)
		deferred
		end

	interface: EV_TEXT_COMPONENT
		deferred
		end

	is_restoring: BOOLEAN

end
