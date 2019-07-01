note
	description: "Menu driven console terminal shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-14 9:03:15 GMT (Thursday 14th March 2019)"
	revision: "6"

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

	make (name: READABLE_STRING_GENERAL; table: like command_table)
		do
			command_table := table
			make_shell (name)
		end

end
