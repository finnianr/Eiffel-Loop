note
	description: "Unix implementation of [$source EL_USERS_INFO_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-23 8:38:39 GMT (Saturday 23rd June 2018)"
	revision: "4"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			do_command, make_default, new_command_string
		end

create
	make

feature {NONE} -- Implementation

	new_users_dir: EL_DIR_PATH
		do
			Result := "/home"
		end

feature {NONE} -- Constants

	Template: STRING = "ls $path"

end
