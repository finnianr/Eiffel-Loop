note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:13 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_WEL_FRAME_WINDOW

inherit
	WEL_FRAME_WINDOW
		undefine
			default_process_message
		redefine
			make_top
		end
	
	EL_WEL_COMPOSITE_WINDOW
	
feature {NONE} -- Initialization

	make_top (a_name: STRING)
			-- 
		do
			Precursor (a_name)
			register_main_thread_implementation
		end

end
