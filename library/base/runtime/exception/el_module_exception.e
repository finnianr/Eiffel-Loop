note
	description: "Shared access to routines of class [$source EL_EXCEPTION_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:15:52 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_EXCEPTION

inherit
	EL_MODULE

feature {NONE} -- Constants

	Exception: EL_EXCEPTION_ROUTINES
		once
			create Result.make
		end
end
