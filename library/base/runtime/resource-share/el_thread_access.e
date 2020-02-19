note
	description: "Thread access"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-19 13:44:53 GMT (Wednesday 19th February 2020)"
	revision: "7"

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

	restricted_access (object: EL_MUTEX_REFERENCE [ANY]): ANY
		do
			restrict_access (object)
			Result := object.item
		end

end
