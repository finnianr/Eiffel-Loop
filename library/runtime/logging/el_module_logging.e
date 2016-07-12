note
	description: "Summary description for {EL_MODULE_LOGGING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 13:52:59 GMT (Friday 8th July 2016)"
	revision: "4"

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
