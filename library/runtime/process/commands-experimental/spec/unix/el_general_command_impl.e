note
	description: "Summary description for {EL_GENERAL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_GENERAL_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	program_path: EL_FILE_PATH
		once
		end

feature -- Basic operations

	set_arguments (command: EL_OS_COMMAND [like Current]; arguments: EL_COMMAND_ARGUMENT_LIST)
			-- call back arguments
		do
		end

end
