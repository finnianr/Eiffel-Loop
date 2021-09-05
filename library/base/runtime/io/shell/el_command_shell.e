note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 8:22:20 GMT (Wednesday 1st September 2021)"
	revision: "9"

class
	EL_COMMAND_SHELL

inherit
	ANY

	EL_COMMAND_SHELL_I
		rename
			make as make_shell,
			new_command_table as command_table
		end

create
	make

feature {NONE} -- Initialization

	make (name: READABLE_STRING_GENERAL; table: like command_table; a_row_count: INTEGER)
		do
			command_table := table
			make_shell (name, a_row_count)
		end

end