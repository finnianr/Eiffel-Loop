note
	description: "Summary description for {EL_FIND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

deferred class
	EL_FIND_COMMAND_IMPL

inherit
	EL_CMD_EXE_COMMAND
		redefine
			shell_command, set_arguments
		end

feature -- Basic operations

	set_arguments (command: EL_FIND_OS_COMMAND [EL_FIND_COMMAND_IMPL, EL_PATH]; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			Precursor (command, arguments)
			arguments.add_option ("B")
			if command.is_recursive then
				arguments.add_option ("S")
			end
		end

	adjust_for_non_recursive (find_command: EL_FIND_OS_COMMAND [EL_FIND_COMMAND_IMPL, EL_PATH]; line: STRING)
			-- For non-recursive finds prepend path argument to each found path
			-- This is to results of Windows 'dir' command compatible with Unix 'find' command
		require
			not find_command.is_recursive
		do
			if line /~ find_command.path.string  then
				line.prepend_character ('\')
				line.prepend (find_command.path)
			end
		end

feature {NONE} -- Constants

	Shell_command: STRING = "dir"

end
