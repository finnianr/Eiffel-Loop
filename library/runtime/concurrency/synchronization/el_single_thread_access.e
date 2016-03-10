note
	description: "Summary description for {EL_SINGLE_THREAD_ACCESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SINGLE_THREAD_ACCESS

inherit
	EL_MODULE_LOG

feature {NONE} -- Initialization

	make_thread_access
			--
		do
			create mutex.make
		end

feature {NONE} -- Basic operations

	restrict_access
			-- restrict access to single thread at a time
		do
			mutex.lock
		end

	logged_restrict_access
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

	end_restriction
			-- end restricted thread access
		do
			mutex.unlock
		end

feature {NONE} -- Implementation

	mutex: MUTEX

end
