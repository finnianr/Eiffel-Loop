note
	description: "Summary description for {EL_APPLICATION_MUTEX_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_APPLICATION_MUTEX_IMPL

inherit
	EL_PLATFORM_IMPL

	EL_WINDOWS_MUTEX_API

	EXECUTION_ENVIRONMENT

create
	make

feature -- Status change

	try_lock (name: STRING)
		local
			wide_name: EL_C_WIDE_CHARACTER_STRING
		do
			create wide_name.make_from_string (name)
			mutex_ptr := c_open_mutex (wide_name.base_address)
			if not is_attached (mutex_ptr) then
				mutex_ptr := c_create_mutex (wide_name.base_address)
				if is_attached (mutex_ptr) then
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
			if is_attached (mutex_ptr) then
				closed := c_close_handle (mutex_ptr)
				is_locked := True
			end
		end

feature -- Status query

	is_locked: BOOLEAN

feature {NONE} -- Implementation

	mutex_ptr: POINTER

end
