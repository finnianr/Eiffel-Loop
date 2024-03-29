note
	description: "Application mutex i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-05 15:13:35 GMT (Sunday 5th November 2023)"
	revision: "10"

deferred class
	EL_APPLICATION_MUTEX_I

inherit
	EL_OS_DEPENDENT

	EL_MODULE_EXECUTABLE

feature {NONE} -- Implementation

	make_default
		deferred
		end

	make
		do
			make_default
			try_lock (Executable.User_qualified_name)
		end

	make_for_application_mode (option_name: READABLE_STRING_GENERAL)
			-- Create mutex for application  in mode specified by option_name
		do
			make_default
			try_lock (Executable.User_qualified_name + "." + option_name)
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