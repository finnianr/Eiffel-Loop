note
	description: "Module log manager"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
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
