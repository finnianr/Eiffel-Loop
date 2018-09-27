note
	description: "Module environment"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_MODULE_ENVIRONMENT

inherit
	EL_MODULE

feature -- Access

	Environment: EL_SHARED_ENVIRONMENTS
			--
		once ("PROCESS")
			create Result
		end

end