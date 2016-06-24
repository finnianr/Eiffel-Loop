note
	description: "Summary description for {EL_COPY_TREE_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-09-16 10:22:15 GMT (Wednesday 16th September 2015)"
	revision: "4"

class
	EL_COPY_TREE_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("xcopy")
		end

feature -- Basic operations

	set_arguments (command: EL_COPY_TREE_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			arguments.add_option ("I")
			arguments.add_option ("E")
			arguments.add_option ("Y") -- suppress overwrite prompting
			arguments.add_path (command.source_path)
			arguments.add_path (
				File.joined_path (
					Directory.directory_name (command.destination_path),
					File.steps (command.source_path).last
				)
			)
		end

end
