note
	description: "Windows implemenation of [$source EL_MOVE_TO_DIRECTORY_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-19 12:37:43 GMT (Sunday 19th April 2020)"
	revision: "1"

class
	EL_MOVE_TO_DIRECTORY_COMMAND_IMP

inherit
	EL_MOVE_TO_DIRECTORY_COMMAND_I

	EL_OS_COMMAND_IMP
		undefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "[
		move /Y $source_path $destination_path
	]"

end
