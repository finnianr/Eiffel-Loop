note
	description: "Summary description for {EL_MODULE_TIME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-11-13 10:09:21 GMT (Wednesday 13th November 2013)"
	revision: "2"

class
	EL_MODULE_TIME

inherit
	EL_MODULE

feature -- Access

	Time: EL_TIME_ROUTINES
			--
		once
			create Result.make
		end

end
