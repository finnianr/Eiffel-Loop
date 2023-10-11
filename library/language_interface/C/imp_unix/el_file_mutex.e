note
	description: "A special 1 byte created file that can be used as a mutex"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_FILE_MUTEX

inherit
	EL_FILE_LOCK_C_API

	DISPOSABLE

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make, make_from_name

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH)
		do
			make_from_name (path)
		end

	make_from_name (path_name: ZSTRING)
		do
			native_path := path_name
			create lock.make (1)
			descriptor := c_create_write_only (native_path.base_address)
		ensure
			is_lockable: is_lockable
		end

feature -- Status query

	is_lockable: BOOLEAN
		do
			Result := descriptor.to_boolean
		end

	is_locked: BOOLEAN

feature -- Status change

	close
		do
			dispose
		ensure
			not_lockable: not is_lockable
		end

	try_lock
		require
			is_lockable: is_lockable
		do
			is_locked := c_aquire_lock (descriptor, lock.self_ptr) /= -1
		end

	unlock
		require
			locked: is_locked
			is_lockable: is_lockable
		do
			lock.set_unlocked
			is_locked := c_aquire_lock (descriptor, lock.self_ptr) = -1
		ensure
			unlocked: not is_locked
		end

feature {NONE} -- Implementation

	dispose
		do
			if descriptor.to_boolean and then c_close (descriptor) = 0 then
				descriptor := 0
			end
		end

feature {NONE} -- Internal attributes

	descriptor: INTEGER

	lock: EL_FILE_LOCK

	native_path: EL_C_UTF_STRING_8

feature {NONE} -- Constants

	Lock_length: INTEGER
		once
			Result := 1
		end
end
