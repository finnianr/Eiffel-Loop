note
	description: "Shared access to routines of class [$source EL_SHARED_ENVIRONMENTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:08:26 GMT (Thursday 6th February 2020)"
	revision: "8"

deferred class
	EL_MODULE_ENVIRONMENT

inherit
	EL_MODULE

feature {NONE} -- Constants

	Environment: EL_SHARED_ENVIRONMENTS
			--
		once ("PROCESS")
			create Result
		end

end
