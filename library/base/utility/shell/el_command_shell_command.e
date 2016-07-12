note
	description: "`EL_COMMAND_SHELL' that plugs into `EL_COMMAND_SHELL_SUB_APPLICATTION'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-07 21:25:34 GMT (Thursday 7th July 2016)"
	revision: "5"

deferred class
	EL_COMMAND_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL

	EL_COMMAND
		rename
			execute as run_command_loop
		end

end
