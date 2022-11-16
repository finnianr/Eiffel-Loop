note
	description: "[
		Shared access to instances of classes:

			[$source EL_EXECUTION_ENVIRONMENT_I]
			[$source EL_OPERATING_ENVIRONMENT_I]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

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