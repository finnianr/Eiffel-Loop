note
	description: "Unix implementation of `EL_USER_LIST_COMMAND_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-19 10:04:43 GMT (Sunday 19th June 2016)"
	revision: "4"

class
	EL_USER_LIST_COMMAND_IMP

inherit
	EL_USER_LIST_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string
		end

create
	make

feature {NONE} -- Constants

	Template: STRING = "ls $path"

end
