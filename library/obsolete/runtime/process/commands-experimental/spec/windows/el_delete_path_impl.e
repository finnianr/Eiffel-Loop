note
	description: "Summary description for {EL_DELETE_PATH_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_DELETE_PATH_IMPL

inherit
	EL_CMD_EXE_COMMAND
		redefine
			set_arguments
		end

feature -- Basic operations

	set_arguments (command: EL_DELETE_PATH_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			Precursor (command, arguments)
			arguments.add_path (command.target_path)
		end

feature {NONE} -- Constants

	Shell_command: STRING = "del"

end
