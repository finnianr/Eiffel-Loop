note
	description: "EL_COMMAND_SHELL that plugs into EL_COMMAND_SHELL_SUB_APPLICATTION"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_COMMAND_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL

	EL_COMMAND
		rename
			execute as run_command_loop
		end

end
