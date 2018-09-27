note
	description: "Module exception"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "6"

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
