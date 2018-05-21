note
	description: "Wel frame window"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

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