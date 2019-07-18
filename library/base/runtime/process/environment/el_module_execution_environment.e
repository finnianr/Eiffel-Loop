note
	description: "Module execution environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:57:30 GMT (Monday 1st July 2019)"
	revision: "7"

deferred class
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
