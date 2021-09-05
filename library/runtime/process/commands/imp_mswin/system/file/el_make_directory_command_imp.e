note
	description: "Windows implementation of [$source EL_MAKE_DIRECTORY_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 11:29:48 GMT (Wednesday 1st September 2021)"
	revision: "5"

class
	EL_MAKE_DIRECTORY_COMMAND_IMP

inherit
	EL_MAKE_DIRECTORY_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP

create
	make, make_default

feature {NONE} -- Constants

	Template: STRING = "mkdir $directory_path"
end