note
	description: "Summary description for {EL_FIND_DIRECTORIES_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-18 11:41:06 GMT (Tuesday 18th June 2013)"
	revision: "2"

class
	EL_FIND_DIRECTORIES_COMMAND

inherit
	EL_FIND_OS_COMMAND [EL_FIND_DIRECTORIES_IMPL, EL_DIR_PATH]
		redefine
			new_output_file, path_list
		end

create
	make, make_default

feature -- Access

	path_list: ARRAYED_LIST [EL_DIR_PATH]

feature {NONE} -- Implementation

	new_output_file (output_file_path: EL_FILE_PATH): PLAIN_TEXT_FILE
			-- Prepend lines to output file before command has executed
		do
			Result := Precursor (output_file_path)
			implementation.prepend_lines (Current, Result)
		end

end
