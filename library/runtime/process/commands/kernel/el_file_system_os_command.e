note
	description: "Summary description for {EL_FILE_SYSTEM_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_FILE_SYSTEM_OS_COMMAND [T -> EL_COMMAND_IMPL create default_create end]

inherit
	EL_OS_COMMAND [T]
		rename
			make as make_command
		end

end
