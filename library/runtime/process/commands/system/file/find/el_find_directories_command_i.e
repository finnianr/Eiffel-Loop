note
	description: "Find directories command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 13:30:38 GMT (Monday 5th December 2022)"
	revision: "11"

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

	new_path_list (n: INTEGER): EL_DIRECTORY_PATH_LIST
		do
			create Result.make_sized (n)
		end

end