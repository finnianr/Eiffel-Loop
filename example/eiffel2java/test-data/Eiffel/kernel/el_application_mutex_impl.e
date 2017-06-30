note
	description: "Summary description for {EL_APPLICATION_MUTEX_IMPL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_APPLICATION_MUTEX_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_WINDOWS_MUTEX_API

	EXECUTION_ENVIRONMENT

feature -- Status change

	try_lock (name: STRING)
		local
			wide_name: EL_C_WIDE_CHARACTER_STRING
		do
			create wide_name.make_from_string (name)
			mutex_ptr := c_open_mutex (wide_name.base_address)
			if mutex_ptr = Default_pointer then
				mutex_ptr := c_create_mutex (wide_name.base_address)
				if mutex_ptr /= Default_pointer then
					is_locked := True
				end
			end
		end

	unlock
		require
			is_locked: is_locked
		local
			closed: BOOLEAN
		do
			if mutex_ptr /= Default_pointer then
				closed := c_close_handle (mutex_ptr)
				is_locked := True
			end
		end

feature -- Status query

	is_locked: BOOLEAN

feature {NONE} -- Implementation

	mutex_ptr: POINTER

end
