note
	description: "Summary description for {EL_MODULE_LOGGING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 10:45:56 GMT (Thursday 28th December 2017)"
	revision: "3"

deferred class
	EL_MODULE_LOGGING

inherit
	EL_MODULE
		undefine
			is_equal
		end

feature -- Access

	Logging: EL_GLOBAL_LOGGING
		--	
		once ("PROCESS")
			create Result.make
		end

end
