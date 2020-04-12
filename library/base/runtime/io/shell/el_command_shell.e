note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-11 11:29:37 GMT (Saturday 11th April 2020)"
	revision: "8"

class
	EL_COMMAND_SHELL

inherit
	ANY

	EL_COMMAND_SHELL_I
		rename
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
