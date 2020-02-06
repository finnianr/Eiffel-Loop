note
	description: "Shared access to routines of class [$source EL_EXECUTION_ENVIRONMENT_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:16:03 GMT (Thursday 6th February 2020)"
	revision: "8"

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
