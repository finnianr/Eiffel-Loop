note
	description: "[
		Access to the Eiffel-Loop log output routines defined by class ${EL_LOGGABLE}
		
		**Notes**
		If inheriting this module in a class which already inherits ${EL_MODULE_LIO} then undefine
		these factory functions from ${EL_MODULE_LIO}

			undefine
				new_lio, new_log_manager
			end
			
		This is because ${EL_MODULE_LIO} redefines the lio `object' to be loggable.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "8"

deferred class
	EL_MODULE_LOG

inherit
	EL_MODULE_LOGGING

	EL_MODULE_LIO
		redefine
			new_lio
		end

feature -- Access

	log: EL_LOGGABLE
		--	Normal logging available only when -logging switch is set on command line
		do
			Result := Once_log
			Result.set_logged_object (Current)
		end

feature {NONE} -- Implementation

	new_log: EL_LOGGABLE
		do
			if logging.is_active then
				create {EL_CONSOLE_AND_FILE_LOG} Result.make -- Normal logging object
			else
				Result := Silent_io
			end
		end

	new_lio: EL_LOGGABLE
		do
			if logging.is_active then
				Result := Once_log
			else
				Result := Precursor
			end
		end

feature {NONE} -- Constants

	Once_log: EL_LOGGABLE
		--	
		once
			Result := new_log
		end

end