note
	description: "Summary description for {EL_COPY_FILE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_COPY_FILE_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("cp")
		end

feature -- Basic operations

	set_arguments (command: EL_COPY_FILE_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			arguments.set_command_option_prefix ("--")
			if command.is_timestamp_preserved then
				arguments.add_option ("preserve=timestamps")
			end
			if command.is_destination_a_normal_file then
				arguments.add_option ("no-target-directory")
			end
			arguments.add_path (command.source_path)
			arguments.add_path (command.destination_path)
		end
end
