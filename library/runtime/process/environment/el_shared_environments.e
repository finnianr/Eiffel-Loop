note
	description: "Summary description for {EL_SHARED_ENVIRONMENTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SHARED_ENVIRONMENTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Access

	Operating: EL_OPERATING_ENVIRONMENT
			--
		once ("PROCESS")
			create Result
		end

end
