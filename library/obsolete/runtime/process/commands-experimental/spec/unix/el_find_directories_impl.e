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

create
	default_create

feature -- Basic operations

	set_arguments (command: EL_FIND_DIRECTORIES_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			if command.follow_symbolic_links then
				arguments.add_option ("L")
			end
			arguments.add_path (command.path)
			arguments.add_option_argument ("type", "d")
		end

feature -- Not applicable

	prepend_line (command: EL_FIND_DIRECTORIES_COMMAND)
			-- Prepend line to make results of Windows 'dir' command compatible with Unix 'find' command
		do
			-- Do nothing under Unix
		end

end
