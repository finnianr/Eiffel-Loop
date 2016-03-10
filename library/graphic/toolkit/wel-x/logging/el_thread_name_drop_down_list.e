note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_THREAD_NAME_DROP_DOWN_LIST

inherit
	WEL_DROP_DOWN_LIST_COMBO_BOX
		rename
			make as make_list
		undefine
			on_key_down, on_sys_key_down
		end
		
	EL_CONTROL
		export
			{NONE} all
		undefine
			on_sys_key_down, height, text_length
		redefine
			parent_dialog
		end

	EL_ALT_ARROW_KEY_CAPTURE

create
	make

feature {NONE} -- Initialization

	make (a_parent_dialog: EL_CONSOLE_MANAGER_DIALOG; pos: WEL_POINT; size: WEL_SIZE)
			-- Make a control identified by `an_id' with `a_parent'
			-- as parent.
		do
			make_list (a_parent_dialog, pos.x, pos.y, size.width, size.height, -1)
			make_control (a_parent_dialog)
			
		end
		
feature {NONE} -- Event handlers

	on_alt_left_arrow_key_down
			--
		do
			parent_dialog.on_alt_left_arrow_key_down
		end
		
	on_alt_right_arrow_key_down
			--
		do
			parent_dialog.on_alt_left_arrow_key_down
		end

feature {NONE} -- Implementation

	parent_dialog: EL_CONSOLE_MANAGER_DIALOG

feature {NONE} -- Constants

	Field_spacing: INTEGER = 10
	
	Border_left_right: INTEGER = 10
	
	Border_top_bottom: INTEGER = 15

end



