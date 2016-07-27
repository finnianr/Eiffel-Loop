note
	description: "Summary description for {EL_MOVE_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-11 14:13:23 GMT (Wednesday 11th May 2016)"
	revision: "3"

class
	EL_MOVE_FILE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_MOVE_FILE_IMPL]

create
	default_create, make

end