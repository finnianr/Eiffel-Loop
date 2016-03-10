note
	description: "Summary description for {EL_MODULE_EXECUTION_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 9:20:00 GMT (Thursday 6th June 2013)"
	revision: "2"

class
	EL_MODULE_EXECUTION_ENVIRONMENT

inherit
	EL_MODULE

feature -- Access

	Execution, Execution_environment: EL_EXECUTION_ENVIRONMENT
			--
		once ("PROCESS")
			create Result.make
		end

end
