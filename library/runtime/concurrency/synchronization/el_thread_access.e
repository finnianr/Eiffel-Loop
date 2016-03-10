note
	description: "Summary description for {EL_THREAD_ACCESS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
