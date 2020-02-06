note
	description: "[
		Shared access to routines of classes [$source EL_OPERATING_ENVIRONMENT_I]
		and [$source EL_EXECUTION_ENVIRONMENT_I]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:13:56 GMT (Thursday 6th February 2020)"
	revision: "9"

class
	EL_SHARED_ENVIRONMENTS

inherit
	ANY

	EL_MODULE_EXECUTION_ENVIRONMENT
		export
			{EL_MODULE_ENVIRONMENT} all
		end

feature {EL_MODULE_ENVIRONMENT} -- Constants

	Operating: EL_OPERATING_ENVIRONMENT_I
			--
		once ("PROCESS")
			create {EL_OPERATING_ENVIRONMENT_IMP} Result
		end

end
