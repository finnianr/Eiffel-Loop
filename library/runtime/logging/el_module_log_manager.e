note
	description: "Summary description for {EL_MODULE_LOG_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 12:52:50 GMT (Friday 8th July 2016)"
	revision: "1"

class
	EL_MODULE_LOG_MANAGER

inherit
	EL_MODULE

feature -- Access

	Log_manager: EL_LOG_MANAGER
		--	
		once ("PROCESS")
			Result := new_log_manager
		end
		
feature {NONE} -- Factory

	new_log_manager: EL_LOG_MANAGER
		do
			create Result.make
		end
end