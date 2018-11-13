note
	description: "Module environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:18:36 GMT (Monday 12th November 2018)"
	revision: "6"

class
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
