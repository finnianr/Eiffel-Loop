note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_WEL_MAIN_DIALOG

inherit
	WEL_MAIN_DIALOG
		undefine
			default_process_message
		redefine
			internal_dialog_make
		end
		
	EL_WEL_COMPOSITE_WINDOW

feature {NONE} -- Implementation

	internal_dialog_make (a_parent: WEL_WINDOW; an_id: INTEGER; a_name: STRING)
			-- Create the dialog
		do
			Precursor (a_parent, an_id, a_name)
			register_main_thread_implementation
		end


end
