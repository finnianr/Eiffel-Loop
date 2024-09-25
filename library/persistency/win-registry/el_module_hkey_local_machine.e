note
	description: "Shared instance of class ${EL_WEL_HKEY_LOCAL_MACHINE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 7:54:42 GMT (Wednesday 25th September 2024)"
	revision: "8"

deferred class
	EL_MODULE_HKEY_LOCAL_MACHINE

inherit
	EL_MODULE

feature {NONE} -- Constants

	Key_local: EL_WEL_HKEY_LOCAL_MACHINE
		once
			create Result
		end
end