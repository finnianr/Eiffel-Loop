note
	description: "Summary description for {EL_FIND_FILES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FIND_FILES_IMPL

inherit
	EL_FIND_COMMAND_IMPL
		redefine
			set_arguments
		end

create
	default_create

feature -- Basic operations

	set_arguments (command: EL_FIND_FILES_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			Precursor (command, arguments)
			arguments.add_option ("A-D")
			arguments.add_path (File.joined_path (command.path, command.file_pattern))
		end

end
