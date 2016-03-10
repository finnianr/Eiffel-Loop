note
	description: "Summary description for {APPLICATION_MUTEX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_APPLICATION_MUTEX

inherit
	EL_CROSS_PLATFORM [EL_APPLICATION_MUTEX_IMPL]

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make, make_for_application_mode

feature {NONE} -- Implementation

	make
		do
			make_platform
			implementation.try_lock (Execution_environment.Executable_name)
			is_locked := Implementation.is_locked
		end

	make_for_application_mode (option_name: STRING)
			-- Create mutex for application  in mode specified by option_name
		do
			make_platform
			implementation.try_lock (Execution_environment.Executable_name + "." + option_name)
			is_locked := Implementation.is_locked
		end

feature -- Status change

	unlock
		require
			is_locked: is_locked
		do
			implementation.unlock
		end

feature -- Status query

	is_locked: BOOLEAN
		-- Is this the only instance of this application

end
