note
	description: "Module execution environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:18:49 GMT (Monday 12th November 2018)"
	revision: "6"

class
	EL_MODULE_EXECUTION_ENVIRONMENT

inherit
	EL_MODULE

feature {NONE} -- Constants

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
