note
	description: "Summary description for {EL_FILE_SYSTEM_OS_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-13 16:32:17 GMT (Monday 13th June 2016)"
	revision: "3"

deferred class
	EL_FILE_SYSTEM_OS_COMMAND [T -> EL_OS_COMMAND_INTERFACE create default_create end]

inherit
	EL_OS_COMMAND [T]

end