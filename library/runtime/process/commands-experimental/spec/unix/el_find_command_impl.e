note
	description: "Summary description for {EL_FIND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

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
