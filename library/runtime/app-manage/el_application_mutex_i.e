note
	description: "Application mutex i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "6"

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
			try_lock (Execution_environment.Executable_and_user_name)
		end

	make_for_application_mode (option_name: STRING)
			-- Create mutex for application  in mode specified by option_name
		do
			make_default
			try_lock (Execution_environment.Executable_and_user_name + "." + option_name)
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
