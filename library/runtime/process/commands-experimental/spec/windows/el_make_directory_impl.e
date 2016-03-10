note
	description: "Summary description for {EL_MAKE_DIRECTORY_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_MAKE_DIRECTORY_IMPL

inherit
	EL_CMD_EXE_COMMAND
		redefine
			set_arguments
		end

feature -- Basic operations

	set_arguments (command: EL_MAKE_DIRECTORY_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			Precursor (command, arguments)
			arguments.add_path (command.directory_path)
		end

feature {NONE} -- Constants

	Shell_command: STRING = "mkdir"

end
