note
	description: "Summary description for {EL_MODULE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 13:44:26 GMT (Thursday 23rd June 2016)"
	revision: "6"

class
	EL_MODULE_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	Command: EL_COMMAND_FACTORY
		once
			create Result
		end
end