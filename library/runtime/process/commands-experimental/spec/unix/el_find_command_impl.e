note
	description: "Summary description for {EL_FIND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

deferred class
	EL_FIND_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("find")
		end

feature -- Basic operations

	set_arguments (command: EL_FIND_OS_COMMAND [like Current, EL_PATH]; arguments: EL_COMMAND_ARGUMENT_LIST)
		deferred
		end

	adjust_for_non_recursive (find_command: EL_FIND_OS_COMMAND [EL_FIND_COMMAND_IMPL, EL_PATH]; line: STRING)
			-- For non-recursive finds prepend path argument to each found path
			-- This is to make results of Windows 'dir' command compatible with Unix 'find' command
		do
			-- Do nothing under Unix
		end

end
