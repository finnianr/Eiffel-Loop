note
	description: "[$source EL_COMMAND_SHELL] that plugs into [$source EL_COMMAND_SHELL_SUB_APPLICATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-02-21 17:09:52 GMT (Wednesday 21st February 2018)"
	revision: "4"

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
