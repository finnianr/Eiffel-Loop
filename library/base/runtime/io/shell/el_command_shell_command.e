note
	description: "[$source EL_COMMAND_SHELL] that plugs into [$source EL_COMMAND_SHELL_SUB_APPLICATION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-01 8:21:16 GMT (Wednesday 1st September 2021)"
	revision: "7"

deferred class
	EL_COMMAND_SHELL_COMMAND

inherit
	EL_COMMAND_SHELL_I
		export
			{EL_COMMAND_CLIENT} make
		end

	EL_COMMAND
		rename
			execute as run_command_loop
		end

end