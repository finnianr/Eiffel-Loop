note
	description: "[
		Shared access to instances of classes:

			${EL_EXECUTION_ENVIRONMENT_I}
			${EL_OPERATING_ENVIRONMENT_I}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "12"

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