note
	description: "Access to class [$source EL_OS_ROUTINES_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "4"

class
	EL_MODULE_OS

feature {NONE} -- Constants

	OS: EL_OS_ROUTINES_I
		once
			create {EL_OS_ROUTINES_IMP} Result
		end
end
