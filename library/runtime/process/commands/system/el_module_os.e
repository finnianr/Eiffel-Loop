note
	description: "Summary description for {EL_MODULE_OS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 9:13:22 GMT (Friday 1st July 2016)"
	revision: "4"

class
	EL_MODULE_OS

feature {NONE} -- Constants

	OS: EL_OS_ROUTINES_I
		once
			create {EL_OS_ROUTINES_IMP} Result
		end
end