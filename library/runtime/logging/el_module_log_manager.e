note
	description: "Shared access to routines of class [$source EL_LOG_MANAGER]"
	descendants: "[
			EL_LOG_MANAGER
				[$source EL_CRC_32_LOG_MANAGER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-04-23 10:08:37 GMT (Saturday 23rd April 2022)"
	revision: "11"

deferred class
	EL_MODULE_LOG_MANAGER

inherit
	EL_MODULE

	EL_SHARED_SINGLETONS

feature -- Contract Support

	is_logged_application: BOOLEAN
		do
			Result := Singleton_table.has_conforming_type ({EL_LOG_MANAGER})
		end

feature {NONE} -- Implementation

	Log_manager: EL_LOG_MANAGER
		--	
		once ("PROCESS")
			Result := create {EL_CONFORMING_SINGLETON [EL_LOG_MANAGER]}
		end

	current_thread_log_file: EL_FILE_AND_CONSOLE_LOG_OUTPUT
		do
			Result := Log_manager.current_thread_log_file
		end

end