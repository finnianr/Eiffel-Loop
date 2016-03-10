note
	description: "Summary description for {EL_MODULE_EXECUTION_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-02 14:09:29 GMT (Sunday 2nd March 2014)"
	revision: "3"

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
