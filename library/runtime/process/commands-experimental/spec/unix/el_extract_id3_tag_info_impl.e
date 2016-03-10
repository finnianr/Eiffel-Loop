note
	description: "Summary description for {EL_EXTRACT_ID3_TAG_INFO_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_EXTRACT_ID3_TAG_INFO_IMPL

inherit
	EL_COMMAND_IMPL

feature -- Access

	Program_path: EL_FILE_PATH
		once
			Result := Environment.Execution.command_path_abs ("extract")
		end

feature -- Basic operations

	set_arguments (command: EL_EXTRACT_ID3_TAGS_COMMAND; arguments: EL_COMMAND_ARGUMENT_LIST)
		do
			arguments.add_path (command.path)
		end
end
