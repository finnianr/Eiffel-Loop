note
	description: "Module exception"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_MODULE_EXCEPTION

inherit
	EL_MODULE

feature {NONE} -- Constants

	Exception: EL_EXCEPTION_ROUTINES
		once
			create Result.make
		end
end
