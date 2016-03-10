note
	description: "Summary description for {EL_MODULE_LOG_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 15:53:23 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_MODULE_LOG_MANAGER

inherit
	EL_MODULE

feature -- Access

	log_manager: EL_LOG_MANAGER
		--	
		once ("PROCESS")
			create Result.make
		end

end
