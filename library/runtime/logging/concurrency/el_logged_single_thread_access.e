note
	description: "Summary description for {EL_LOGGED_SINGLE_THREAD_ACCESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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