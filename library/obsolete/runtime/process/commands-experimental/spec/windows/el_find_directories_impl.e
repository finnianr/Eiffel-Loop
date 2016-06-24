note
	description: "Summary description for {EL_FIND_DIRECTORIES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_FIND_DIRECTORIES_IMPL

inherit
	EL_FIND_COMMAND_IMPL
		redefine
			set_arguments
		end

create
	default_create

feature -- Access

	set_arguments (command: EL_FIND_DIRECTORIES_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			Precursor (command, arguments)
			arguments.add_option_argument ("AD", command.path)
		end

feature -- Not applicable

	prepend_line (command: EL_FIND_DIRECTORIES_COMMAND)
			-- Prepend line to make results of Windows 'dir' command compatible with Unix 'find' command
		do
			command.do_with_line (command.path)
		end

end
