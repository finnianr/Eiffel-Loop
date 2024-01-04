note
	description: "Windows implementation of [$source EL_APPLICATION_MUTEX_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-04 20:17:31 GMT (Thursday 4th January 2024)"
	revision: "8"

class
	EL_APPLICATION_MUTEX_IMP

inherit
	EL_APPLICATION_MUTEX_I

	EL_WINDOWS_IMPLEMENTATION

	EL_WIN_32_C_API

	EXECUTION_ENVIRONMENT

create
	make, make_for_application_mode

feature {NONE} -- Implementation

	make_default
		do
		end

feature -- Status change

	try_lock (name: ZSTRING)
		local
			wide_name: EL_C_WIDE_CHARACTER_STRING
		do
			create wide_name.make_from_string (name.to_unicode)
			mutex_handle := c_open_mutex (wide_name.base_address)
			if mutex_handle = 0 then
				mutex_handle := c_create_mutex (wide_name.base_address)
				if mutex_handle > 0 then
					is_locked := True
				end
			end
		end

	unlock
		local
			closed: BOOLEAN
		do
			if mutex_handle > 0 then
				closed := c_close_handle (mutex_handle)
				is_locked := True
			end
		end

feature {NONE} -- Implementation

	mutex_handle: NATURAL

end