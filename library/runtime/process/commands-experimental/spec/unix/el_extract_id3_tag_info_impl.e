note
	description: "Summary description for {EL_EXTRACT_ID3_TAG_INFO_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 8:35:00 GMT (Tuesday 18th June 2013)"
	revision: "2"

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
