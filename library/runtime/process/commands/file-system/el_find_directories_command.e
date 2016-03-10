note
	description: "Summary description for {EL_FIND_DIRECTORIES_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-27 12:20:47 GMT (Wednesday 27th May 2015)"
	revision: "4"

class
	EL_FIND_DIRECTORIES_COMMAND

inherit
	EL_FIND_OS_COMMAND [EL_FIND_DIRECTORIES_IMPL, EL_DIR_PATH]
		redefine
			new_output_file, path_list
		end

create
	make, default_create

feature -- Access

	path_list: EL_ARRAYED_LIST [EL_DIR_PATH]

feature {NONE} -- Implementation

	new_output_file (output_file_path: EL_FILE_PATH): PLAIN_TEXT_FILE
			-- Prepend lines to output file before command has executed
		do
			Result := Precursor (output_file_path)
			implementation.prepend_lines (Current, Result)
		end

end
