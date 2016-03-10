note
	description: "Summary description for {EL_FIND_DIRECTORIES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:30 GMT (Sunday 16th December 2012)"
	revision: "1"

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
