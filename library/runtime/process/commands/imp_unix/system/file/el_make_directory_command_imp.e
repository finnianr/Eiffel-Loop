note
	description: "Unix implementation of ${EL_MAKE_DIRECTORY_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-27 9:45:54 GMT (Friday 27th September 2024)"
	revision: "10"

class
	EL_MAKE_DIRECTORY_COMMAND_IMP

inherit
	EL_MAKE_DIRECTORY_COMMAND_I

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "mkdir --parents $directory_path"
end