note
	description: "Thread access"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	EL_THREAD_ACCESS [G]

feature {NONE} -- Basic operations

	end_restriction
		do
			if attached mutex_object as object then
				mutex_object := Void
				object.unlock
			end
		end

	restrict_access (object: EL_MUTEX_REFERENCE [G])
		require
			not_locked_by_same_thread: not object.is_monitor_aquired
		do
			object.lock
			mutex_object := object
		end

	restricted_access (object: EL_MUTEX_REFERENCE [G]): G
		do
			restrict_access (object)
			Result := object.item
		end

feature {NONE} -- Internal attributes

	mutex_object: detachable EL_MUTEX_REFERENCE [G]

end