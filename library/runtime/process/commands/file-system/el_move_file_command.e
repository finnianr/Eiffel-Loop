note
	description: "Summary description for {EL_MOVE_FILE_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-01 18:33:25 GMT (Thursday 1st January 2015)"
	revision: "2"

class
	EL_MOVE_FILE_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_MOVE_FILE_IMPL]

create
	make, default_create

end
