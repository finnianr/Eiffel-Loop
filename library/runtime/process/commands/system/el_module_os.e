note
	description: "Shared access to routines of class [$source EL_OS_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-04-29 8:53:47 GMT (Saturday 29th April 2023)"
	revision: "9"

deferred class
	EL_MODULE_OS

inherit
	EL_MODULE

feature {NONE} -- Constants

	OS: EL_OS_ROUTINES
		once
			create Result
		end
end