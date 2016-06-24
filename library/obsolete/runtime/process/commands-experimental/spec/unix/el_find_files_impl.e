note
	description: "Summary description for {EL_FIND_FILES_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_FIND_FILES_IMPL

inherit
	EL_FIND_COMMAND_IMPL

create
	default_create

feature -- Basic operations

	set_arguments (command: EL_FIND_FILES_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			if command.follow_symbolic_links then
				arguments.add_option ("L")
			end

			arguments.add_path (command.path)

			if not command.is_recursive then
				arguments.add_option_argument ("maxdepth", "1")
			end
			arguments.add_option_argument ("type", "f")
			arguments.add_option ("name")
			arguments.add_path (File.file_name (command.file_pattern))
		end

end
