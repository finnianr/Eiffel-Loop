note
	description: "Windows implementation of ${EL_FIND_FILES_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "11"

class
	EL_FIND_FILES_COMMAND_IMP

inherit
	EL_FIND_FILES_COMMAND_I
		export
			{NONE} all
		undefine
			make_default, get_escaped_path,  new_command_parts
		redefine
			path_list
		end

	EL_FIND_COMMAND_IMP
		rename
			make as make_path,
			copy_directory_items as copy_directory_files
		redefine
			path_list
		end

create
	make, make_default

feature -- Access

	path_list: EL_FILE_PATH_LIST

feature {NONE} -- Constants

	Type: STRING = "-D"
		-- /A-D (exclude directories)
end