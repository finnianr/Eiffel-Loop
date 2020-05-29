note
	description: "Unix implementation of [$source EL_USERS_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-26 17:47:28 GMT (Tuesday 26th May 2020)"
	revision: "7"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_parts
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "ls $path"

end
