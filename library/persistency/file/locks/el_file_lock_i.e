note
	description: "Abstract interface to file locking objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-22 16:25:14 GMT (Wednesday 22nd November 2023)"
	revision: "1"

deferred class
	EL_FILE_LOCK_I [G]

inherit
	EL_ALLOCATED_C_OBJECT

	EL_OS_DEPENDENT
		undefine
			copy, is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Status query

	is_locked: BOOLEAN

	is_lockable: BOOLEAN
		deferred
		end

feature -- Status change

	try_lock
		require
			is_lockable: is_lockable
		deferred
		end

	try_until_locked (interval_ms: INTEGER)
		-- try to lock repeatedly until `is_locked' with `interval_ms' millisecs wait between attempts
		do
			from until is_locked loop
				try_lock
				if not is_locked then
					Execution_environment.sleep (interval_ms)
				end
			end
		end

	unlock
		require
			locked: is_locked
			is_lockable: is_lockable
		deferred
		ensure
			unlocked: not is_locked
		end

feature {NONE} -- Internal attributes

	file_handle: G

end