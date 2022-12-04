note
	description: "Find directories command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 21:24:40 GMT (Sunday 4th December 2022)"
	revision: "10"

deferred class
	EL_FIND_DIRECTORIES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			copy_directory_items as copy_sub_directories
		redefine
			path_list
		end

feature -- Access

	path_list: EL_DIRECTORY_PATH_LIST note option: transient attribute end

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