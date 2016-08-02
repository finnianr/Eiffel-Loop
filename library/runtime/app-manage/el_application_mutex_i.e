note
	description: "Summary description for {APPLICATION_MUTEX}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-15 13:53:45 GMT (Sunday 15th May 2016)"
	revision: "1"

deferred class
	EL_APPLICATION_MUTEX_I

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Implementation

	make_default
		deferred
		end

	make
		do
			make_default
			try_lock (Execution_environment.Executable_name)
		end

	make_for_application_mode (option_name: STRING)
			-- Create mutex for application  in mode specified by option_name
		do
			make_default
			try_lock (Execution_environment.Executable_name + "." + option_name)
		end

feature -- Status change

	try_lock (name: ZSTRING)
		deferred
		end

	unlock
		require
			is_locked: is_locked
		deferred
		end

feature -- Status query

	is_locked: BOOLEAN
		-- Is this the only instance of this application

end