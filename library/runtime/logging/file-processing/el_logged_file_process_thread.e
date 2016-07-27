note
	description: "Summary description for {EL_LOGGED_FILE_PROCESS_THREAD}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 8:31:35 GMT (Sunday 3rd July 2016)"
	revision: "4"

class
	EL_LOGGED_FILE_PROCESS_THREAD

inherit
	EL_FILE_PROCESS_THREAD
		undefine
			on_start
		end

	EL_MODULE_LOG_MANAGER
	
create
	make

feature {NONE} -- Implementation

	on_start
		do
			Log_manager.add_thread (Current)
		end

end