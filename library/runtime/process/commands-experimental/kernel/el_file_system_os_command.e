note
	description: "Summary description for {EL_FILE_SYSTEM_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_FILE_SYSTEM_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_OS_COMMAND [T]
		rename
			make as make_command
		end
		
end
