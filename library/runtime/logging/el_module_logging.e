note
	description: "Module logging"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 8:55:51 GMT (Monday 1st July 2019)"
	revision: "9"

deferred class
	EL_MODULE_LOGGING

inherit
	EL_MODULE

feature {NONE} -- Constants

	Logging: EL_GLOBAL_LOGGING
		--	
		once ("PROCESS")
			create Result.make
		end

end
