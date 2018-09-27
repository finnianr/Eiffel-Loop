note
	description: "Module logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "7"

class
	EL_MODULE_LOGGING

inherit
	EL_MODULE

feature -- Access

	Logging: EL_GLOBAL_LOGGING
		--	
		once ("PROCESS")
			create Result.make
		end

end
