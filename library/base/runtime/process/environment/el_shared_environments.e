note
	description: "Shared environments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-12 18:21:18 GMT (Monday 12th November 2018)"
	revision: "6"

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
