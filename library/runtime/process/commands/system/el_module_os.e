note
	description: "Shared access to routines of class [$source EL_OS_ROUTINES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:23:02 GMT (Thursday 6th February 2020)"
	revision: "6"

deferred class
	EL_MODULE_OS

inherit
	EL_MODULE

feature {NONE} -- Constants

	OS: EL_OS_ROUTINES_I
		once
			create {EL_OS_ROUTINES_IMP} Result
		end
end
