note
	description: "Unix implementation of [$source EL_USER_LIST_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

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
