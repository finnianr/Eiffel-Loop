note
	description: "Unix implementation of [$source EL_FIND_DIRECTORIES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:26:16 GMT (Wednesday 1st September 2021)"
	revision: "8"

class
	EL_FIND_DIRECTORIES_COMMAND_IMP

inherit
	EL_FIND_DIRECTORIES_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, new_command_parts, reset
		end

	EL_UNIX_FIND_TEMPLATE

create
	make, make_default

feature {NONE} -- Constants

	Type: STRING = "d"
		-- Unix find type

end