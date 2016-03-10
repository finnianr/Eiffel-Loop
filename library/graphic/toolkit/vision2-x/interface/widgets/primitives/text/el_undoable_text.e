note
	description: "Summary description for {EL_TEXT_COMPONENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_UNDOABLE_TEXT

feature {NONE} -- Initialization

	make
		do
			create edit_history.make (100)
		end

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

	change_actions: EV_NOTIFY_ACTION_SEQUENCE
		deferred
		end

feature -- Element change

	set_text (a_text: READABLE_STRING_GENERAL)
		deferred
		end

	set_caret_position (a_caret_position: INTEGER)
		deferred
		end

	set_edit_history_from_other (other: like Current)
		do
			edit_history := other.edit_history
		end

feature -- Status query

	has_undo_items: BOOLEAN
		do
			Result := not edit_history.is_empty
		end

	has_redo_items: BOOLEAN
		do
			Result := edit_history.has_redo_items
		end

	is_undo_enabled: BOOLEAN

	has_focus: BOOLEAN
		deferred
		end

	has_selection: BOOLEAN
		deferred
		end

feature -- Status setting

	enable_undo
		do
			if not is_undo_enabled then
				edit_history.set_string (text)
				edit_history.set_caret_position (caret_position)
				change_actions.put_front (
					agent
						local
							l_string: EL_ASTRING
						do
							l_string := text
							if l_string /~ edit_history.string then
								edit_history.extend (caret_position, l_string)
							end
						end
				)
				is_undo_enabled := True
			end
		end

	disable_undo
		do
			if is_undo_enabled then
				change_actions.start; change_actions.remove
				is_undo_enabled := False
				edit_history.wipe_out
			end
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
			if has_undo_items then
				edit_history.undo; restore_from_history
			end
		end

	redo
		do
			if edit_history.has_redo_items then
				edit_history.redo; restore_from_history
			end
		end

feature {EL_UNDOABLE_TEXT} -- Implementation

	restore_from_history
		do
			change_actions.block
			set_text (edit_history.string.to_unicode)
			set_caret_position (edit_history.caret_position)
			change_actions.resume
		end

	edit_history: EL_STRING_EDITION_HISTORY

end
