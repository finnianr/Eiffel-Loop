note
	description: "Summary description for {EL_MODULE_LOG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EL_MODULE_LOG

inherit
	EL_MODULE_LOGGING

feature -- Access

	log: EL_LOG
		--	Normal logging available only when -logging switch is set on command line
		do
			Result := Active_or_inactive_log.item
			Result.set_logged_object (Current)
		end

	log_or_io: EL_LOG
			-- Minimal 'console only logging' that is always on even when normal logging is disabled
		do
			if logging.is_active then
				Result := log
			else
				Result := Default_console_only_log
			end
		end

feature {NONE} -- Implementation

	Active_or_inactive_log: CELL [EL_LOG]
		--	
		once
			if logging.is_active then
				create Result.put (create {EL_CONSOLE_AND_FILE_LOG}.make) -- Normal logging object
			else
				create Result.put (create {EL_LOG}) -- Silent 'turned off' logging object
			end
		end

	Default_console_only_log: EL_CONSOLE_LOG
			-- Minimal console only logging that is always on even when logging is disabled
			-- available through the 'log_or_io' object.
		once
			create Result.make
		end

end
