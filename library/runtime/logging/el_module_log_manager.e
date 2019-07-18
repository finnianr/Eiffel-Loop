note
	description: "Module log manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:55:45 GMT (Monday 1st July 2019)"
	revision: "6"

deferred class
	EL_MODULE_LOG_MANAGER

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Log_manager: EL_LOG_MANAGER
		--	
		once ("PROCESS")
			Result := new_log_manager
		end

	current_thread_log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			Result := Log_manager.current_thread_log_file
		end

feature {NONE} -- Factory

	new_log_manager: EL_LOG_MANAGER
		do
			create Result.make
		end
end
