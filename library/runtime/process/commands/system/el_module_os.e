note
	description: "Access to class [$source EL_OS_ROUTINES_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 9:50:53 GMT (Monday 1st July 2019)"
	revision: "5"

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
