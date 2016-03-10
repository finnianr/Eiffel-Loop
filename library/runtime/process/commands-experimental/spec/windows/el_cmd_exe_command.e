note
	description: "Windows cmd.exe shell"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

deferred class
	EL_CMD_EXE_COMMAND

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("cmd")
		end

feature -- Basic operations

	set_arguments (command: EL_OS_COMMAND [EL_COMMAND_IMPL]; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			arguments.add_option_argument ("C", shell_command)
		end

feature {NONE} -- Implementation

	shell_command: STRING
		deferred
		end

end
