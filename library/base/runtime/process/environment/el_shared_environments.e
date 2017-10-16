note
	description: "Summary description for {EL_SHARED_ENVIRONMENTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_SHARED_ENVIRONMENTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

feature -- Access

	Operating: EL_OPERATING_ENVIRONMENT_I
			--
		once ("PROCESS")
			create {EL_OPERATING_ENVIRONMENT_IMP} Result
		end

end