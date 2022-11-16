note
	description: "Unix implemenation of [$source EL_MOVE_TO_DIRECTORY_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

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