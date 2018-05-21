note
	description: "Logged single thread access"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_LOGGED_SINGLE_THREAD_ACCESS

inherit
	EL_SINGLE_THREAD_ACCESS
		redefine
			restrict_access
		end

	EL_MODULE_LOG

feature {NONE} -- Basic operations

	restrict_access
			-- restrict access to single thread at a time
			-- and log any waiting for mutex
		local
			lock_aquired: BOOLEAN
		do
			lock_aquired := mutex.try_lock
			if not lock_aquired then
				log.put_line ("Waiting for mutex lock ..")
				mutex.lock
			end
		end

end