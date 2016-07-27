note
	description: "Summary description for {EL_MODULE_EXCEPTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-04 8:51:43 GMT (Monday 4th July 2016)"
	revision: "5"

class
	EL_MODULE_EXCEPTION

inherit
	EL_MODULE

feature {NONE} -- Constants

	Exception: EL_EXCEPTION_ROUTINES
		once
			create Result
		end
end