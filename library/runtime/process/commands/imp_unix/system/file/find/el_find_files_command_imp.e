note
	description: "Unix implementation of [$source EL_FIND_FILES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 12:04:59 GMT (Monday 12th July 2021)"
	revision: "6"

class
	EL_FIND_FILES_COMMAND_IMP

inherit
	EL_FIND_FILES_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default, do_command, new_command_parts, reset
		end

	EL_UNIX_FIND_TEMPLATE

create
	make, make_default

feature {NONE} -- Constants

	Type: STRING = "f"
		-- Unix find type

end