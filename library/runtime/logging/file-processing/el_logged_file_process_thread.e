note
	description: "Logged file process thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

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