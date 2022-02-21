note
	description: "Shared access to routines of class [$source EL_OS_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 21:07:14 GMT (Sunday 20th February 2022)"
	revision: "7"

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