note
	description: "Summary description for {EL_COPY_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_COPY_FILE_IMPL

inherit
	EL_CMD_EXE_COMMAND
		redefine
			set_arguments
		end

feature -- Basic operations

	set_arguments (command: EL_COPY_FILE_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			Precursor (command, arguments)
			arguments.add_path (command.source_path)
			arguments.add_path (command.destination_path)
		end

feature {NONE} -- Constants

	Shell_command: STRING = "copy"
end
