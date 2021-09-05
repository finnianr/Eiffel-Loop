note
	description: "Unix implemenation of [$source EL_MOVE_TO_DIRECTORY_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 9:24:50 GMT (Wednesday 1st September 2021)"
	revision: "2"

class
	EL_MOVE_TO_DIRECTORY_COMMAND_IMP

inherit
	EL_MOVE_TO_DIRECTORY_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		mv -t $destination_path $source_path
	]"

end