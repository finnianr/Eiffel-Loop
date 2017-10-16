note
	description: "`EL_COMMAND_SHELL' that plugs into `EL_COMMAND_SHELL_SUB_APPLICATTION'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 12:31:21 GMT (Sunday 15th October 2017)"
	revision: "3"

deferred class
	EL_COMMAND_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL
		export
			{EL_COMMAND_CLIENT} make_shell
		end

	EL_COMMAND
		rename
			execute as run_command_loop
		end

end
