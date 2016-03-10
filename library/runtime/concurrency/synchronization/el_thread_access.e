note
	description: "Summary description for {EL_THREAD_ACCESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-10 15:43:57 GMT (Sunday 10th May 2015)"
	revision: "3"

class
	EL_THREAD_ACCESS

feature {NONE} -- Basic operations

	restrict_access (object: EL_MUTEX_REFERENCE [ANY])
		require
			not_locked_by_same_thread: not object.is_monitor_aquired
		do
			object.lock
		end

	end_restriction (object: EL_MUTEX_REFERENCE [ANY])
		do
			object.unlock
		end

end
