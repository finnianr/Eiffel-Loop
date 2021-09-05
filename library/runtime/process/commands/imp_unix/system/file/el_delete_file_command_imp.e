note
	description: "Unix implementation of [$source EL_DELETE_FILE_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:23:47 GMT (Wednesday 1st September 2021)"
	revision: "6"

class
	EL_DELETE_FILE_COMMAND_IMP

inherit
	EL_DELETE_FILE_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "rm $target_path"

end