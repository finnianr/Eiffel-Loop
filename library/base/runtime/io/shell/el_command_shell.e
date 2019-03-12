note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-11 10:28:34 GMT (Monday 11th March 2019)"
	revision: "5"

class
	EL_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_I
		rename
			new_command_table as command_table
		end

create
	make

feature {NONE} -- Initialization

	make (name: ZSTRING; table: like command_table)
		do
			command_table := table
			make_shell (name)
		end

end
