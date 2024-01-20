note
	description: "${EL_COMMAND_SHELL} that plugs into ${EL_COMMAND_SHELL_APPLICATION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "12"

deferred class
	EL_APPLICATION_COMMAND_SHELL

inherit
	EL_COMMAND_SHELL_I
		export
			{EL_COMMAND_CLIENT} make
		end

	EL_APPLICATION_COMMAND

feature -- Basic operations

	execute
		do
			-- DO NOT rename `execute' as `run_command_loop'
			run_command_loop
		end

end