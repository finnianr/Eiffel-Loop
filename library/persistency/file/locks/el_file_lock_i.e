note
	description: "Abstract interface to file locking objects"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 18:02:42 GMT (Monday 26th August 2024)"
	revision: "3"

deferred class
	EL_FILE_LOCK_I [G]

inherit
	EL_ALLOCATED_C_OBJECT

	EL_OS_DEPENDENT
		undefine
			copy, is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SHARED_NATIVE_STRING; EL_SHARED_SYSTEM_ERROR_TABLE

feature -- Access

	last_error: INTEGER

	last_error_message: ZSTRING
		do
			Result := System_error_table [last_error]
		end

feature -- Status query

	is_lockable: BOOLEAN
		deferred
		end

	is_locked: BOOLEAN

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