note
	description: "Summary description for {APPLICATION_MUTEX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 16:43:53 GMT (Thursday 1st January 2015)"
	revision: "2"

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
			make_default
			implementation.try_lock (Execution_environment.Executable_name)
			is_locked := Implementation.is_locked
		end

	make_for_application_mode (option_name: STRING)
			-- Create mutex for application  in mode specified by option_name
		do
			make_default
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
