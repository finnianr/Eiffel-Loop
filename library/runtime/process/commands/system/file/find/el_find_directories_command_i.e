note
	description: "Find directories command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:52 GMT (Monday 3rd January 2022)"
	revision: "8"

deferred class
	EL_FIND_DIRECTORIES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			copy_directory_items as copy_sub_directories
		end

feature {NONE} -- Implementation

	copy_path_item (source_path: like new_path; destination_dir: DIR_PATH)
		do
			OS.copy_tree (source_path, destination_dir)
		end

	new_path (a_path: ZSTRING): DIR_PATH
		do
			create Result.make (a_path)
		end

end