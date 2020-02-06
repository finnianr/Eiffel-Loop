note
	description: "Shared access to routines of class [$source EL_LOG_MANAGER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:21:56 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_LOG_MANAGER

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Log_manager: EL_LOG_MANAGER
		--	
		once ("PROCESS")
			Result := (create {EL_CONFORMING_SINGLETON [EL_LOG_MANAGER]}).singleton
		end

	current_thread_log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			Result := Log_manager.current_thread_log_file
		end

end
