note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_TEXT_EDIT_FIELD

inherit
	WEL_SINGLE_LINE_EDIT
		rename
			make as make_single_line_edit
		undefine
			on_key_down
		redefine
			on_en_change, on_set_focus, on_kill_focus
		end
		
	EL_CONTROL
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_parent_dialog: EL_DIALOG; pos: WEL_POINT; size: WEL_SIZE;
		a_field_value: EL_EDITABLE_VALUE
	)
			-- Make a control identified by `an_id' with `a_parent'
			-- as parent.
		do
			make_single_line_edit (a_parent_dialog, a_field_value.out, pos.x, pos.y, size.width, size.height, -1)
			make_control (a_parent_dialog)
			
			check
				parent_dialog_is_an_edit_listener: parent_dialog /= Void
			end
			field_value := a_field_value
			create new_text.make_from_string (a_field_value.out)
		end

feature -- Basic operations

	apply_edit
			--
		do
			field_value.set_item (text)
		end
		
feature -- Status query

	is_valid_text: BOOLEAN
			--
		do
			Result := true
		end
		
feature -- Notifications

	on_en_change
			-- The user has taken an action
			-- that may have altered the text.
		do
			if not is_valid_text then
				set_text (text.substring (1, text.count - 1))
				set_caret_position (text.count)
			end
			if not text.is_equal (new_text) then
				parent_dialog.on_field_edit (Current)
			end
			new_text := text
		end
		
	on_set_focus
			--
		do
			set_caret_position (text.count)
			set_selection (0, text.count)
		end
		
	on_kill_focus
			-- Wm_killfocus message
		do
			if text.is_empty then
				set_text (field_value.out)
			end
		end

feature {NONE} -- Implementation

	new_text: STRING

	field_value: EL_EDITABLE_VALUE
	
end

