note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_CONSOLE_HISTORY_NAVIGATION_BUTTON

inherit
	EL_PUSH_BUTTON
		undefine
			on_sys_key_down
		redefine
			parent_dialog
		end
		
	EL_ALT_ARROW_KEY_CAPTURE

create
	make

feature {NONE} -- Event handlers

	on_alt_left_arrow_key_down
			--
		do
			parent_dialog.on_alt_left_arrow_key_down
		end
		
	on_alt_right_arrow_key_down
			--
		do
			parent_dialog.on_alt_right_arrow_key_down
		end
		
feature {NONE} -- Implementation

	parent_dialog: EL_CONSOLE_MANAGER_DIALOG
	
end
