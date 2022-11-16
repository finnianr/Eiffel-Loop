note
	description: "Windows implementation of [$source EL_FIND_DIRECTORIES_COMMAND_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	EL_FIND_DIRECTORIES_COMMAND_IMP

inherit
	EL_FIND_DIRECTORIES_COMMAND_I
		export
			{NONE} all
		undefine
			new_command_parts, get_escaped_path
		end

	EL_FIND_COMMAND_IMP
		rename
			copy_directory_items as copy_sub_directories
		undefine
			make_default, do_command, do_with_lines
		redefine
			new_output_lines
		end

	EL_MODULE_DIRECTORY

create
	make, make_default

feature {NONE} -- Implementation

	new_output_lines (file_path: FILE_PATH): EL_WINDOWS_DIR_PATH_LINE_SOURCE
		do
			create Result.make (Current, file_path)
		end

feature {NONE} -- Constants

	Type: STRING = "D"
end