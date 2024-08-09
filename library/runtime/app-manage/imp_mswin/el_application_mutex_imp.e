note
	description: "Windows implementation of ${EL_APPLICATION_MUTEX_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-09 13:20:46 GMT (Friday 9th August 2024)"
	revision: "10"

class
	EL_APPLICATION_MUTEX_IMP

inherit
	EL_APPLICATION_MUTEX_I

	EL_WINDOWS_IMPLEMENTATION

	EL_WIN_32_C_API

	EXECUTION_ENVIRONMENT

	EL_MODULE_EXCEPTION

	EL_SHARED_NATIVE_STRING

create
	make, make_for_application_mode

feature {NONE} -- Implementation

	make_default
		do
		end

feature -- Status change

	try_lock (name: ZSTRING)
		do
			if attached Native_string.new_data (name) as l_name then
				mutex_handle := c_open_mutex (l_name.item)
				if mutex_handle = 0 then
					mutex_handle := c_create_mutex (l_name.item)
					if mutex_handle > 0 then
						is_locked := True
					else
						Exception.raise_developer ("CreateMutex failed with error: %S", [c_get_last_error])
					end
				end
			end
		end

	unlock
		local
			closed: BOOLEAN
		do
			if mutex_handle > 0 then
				closed := c_close_handle (mutex_handle)
				is_locked := False
			end
		end

feature {NONE} -- Implementation

	mutex_handle: NATURAL

end