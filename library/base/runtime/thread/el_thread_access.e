note
	description: "Thread access"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "6"

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
