note
	description: "Summary description for {EL_FIND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-17 15:54:38 GMT (Wednesday 17th December 2014)"
	revision: "3"

deferred class
	EL_FIND_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Basic operations

	adjust (command: EL_OS_COMMAND [EL_COMMAND_IMPL]; output_file_path: EL_FILE_PATH)
			-- For non-recursive finds prepend path argument to each found path
			-- This is to make results of Windows 'dir' command compatible with Unix 'find' command
		do
			-- Do nothing under Unix
		end

end
