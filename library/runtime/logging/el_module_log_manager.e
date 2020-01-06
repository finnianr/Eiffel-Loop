note
	description: "Module log manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-06 8:38:44 GMT (Monday 6th January 2020)"
	revision: "7"

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
