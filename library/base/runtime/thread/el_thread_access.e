note
	description: "Summary description for {EL_THREAD_ACCESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-22 11:36:53 GMT (Friday 22nd December 2017)"
	revision: "3"

class
	EL_THREAD_ACCESS

feature {NONE} -- Basic operations

	end_restriction (object: EL_MUTEX_REFERENCE [ANY])
		do
			object.unlock
		end

	restrict_access (object: EL_MUTEX_REFERENCE [ANY])
		require
			not_locked_by_same_thread: not object.is_monitor_aquired
		do
			object.lock
		end

end
