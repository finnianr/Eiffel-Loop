note
	description: "Summary description for {EL_MODULE_EXECUTION_ENVIRONMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 15:51:15 GMT (Wednesday 22nd June 2016)"
	revision: "5"

class
	EL_MODULE_EXECUTION_ENVIRONMENT

inherit
	EL_MODULE

feature -- Access

	execution: like Execution_environment
		do
			Result := Execution_environment
		end

	Execution_environment: EL_EXECUTION_ENVIRONMENT_I
			--
		once ("PROCESS")
			create {EL_EXECUTION_ENVIRONMENT_IMP} Result.make
		end

end
