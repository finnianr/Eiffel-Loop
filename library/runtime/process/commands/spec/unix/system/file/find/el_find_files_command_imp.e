note
	description: "Unix implementation of [$source EL_FIND_FILES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:28:33 GMT (Wednesday 21st February 2018)"
	revision: "3"

class
	EL_FIND_FILES_COMMAND_IMP

inherit
	EL_FIND_FILES_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default, do_command, new_command_string, reset
		end

	EL_UNIX_FIND_TEMPLATE

create
	make, make_default

end
