note
	description: "Summary description for {EL_MODULE_ARGS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MODULE_ARGS

inherit
	EL_MODULE

feature -- Access

	Args: EL_COMMAND_LINE_ARGUMENTS
			--
		once ("PROCESS")
			create Result
		end

end
