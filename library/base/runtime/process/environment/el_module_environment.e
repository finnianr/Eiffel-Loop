note
	description: "Shared access to routines of class [$source EL_SHARED_ENVIRONMENTS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-29 12:52:16 GMT (Friday 29th May 2020)"
	revision: "9"

deferred class
	EL_MODULE_ENVIRONMENT

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_SHARED_OPERATING_ENVIRON

feature {NONE} -- Constants

	Environment: TUPLE [execution: EL_EXECUTION_ENVIRONMENT_I; operating: EL_OPERATING_ENVIRONMENT_I]
			--
		once
			Result := [Execution_environment, Operating_environ]
		end

end
