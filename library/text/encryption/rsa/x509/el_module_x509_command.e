note
	description: "Summary description for {EL_MODULE_X509_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-23 13:46:48 GMT (Thursday 23rd June 2016)"
	revision: "1"

class
	EL_MODULE_X509_COMMAND

inherit
	EL_MODULE

feature {NONE} -- Constants

	X509_command: EL_X509_COMMAND_FACTORY
		once
			create Result
		end

end