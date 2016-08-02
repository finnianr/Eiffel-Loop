note
	description: "Worker thread with logging output visible in console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 6:40:22 GMT (Sunday 3rd July 2016)"
	revision: "1"

class
	EL_LOGGED_WORKER_THREAD

inherit
	EL_WORKER_THREAD
		redefine
			on_start
		end

	EL_MODULE_LOG_MANAGER

create
	make

feature {NONE} -- Event handling

	on_start
		do
			Log_manager.add_thread (Current)
		end

end