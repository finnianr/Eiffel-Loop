note
	description: "Windows implemenation of ${EL_MOVE_TO_DIRECTORY_COMMAND_I}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_MOVE_TO_DIRECTORY_COMMAND_IMP

inherit
	EL_MOVE_TO_DIRECTORY_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		move /Y $source_path $destination_path
	]"

end