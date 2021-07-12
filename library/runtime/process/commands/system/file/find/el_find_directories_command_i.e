note
	description: "Find directories command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 12:05:20 GMT (Monday 12th July 2021)"
	revision: "7"

deferred class
	EL_FIND_DIRECTORIES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			copy_directory_items as copy_sub_directories
		end

feature {NONE} -- Implementation

	copy_path_item (source_path: like new_path; destination_dir: EL_DIR_PATH)
		do
			OS.copy_tree (source_path, destination_dir)
		end

	new_path (a_path: ZSTRING): EL_DIR_PATH
		do
			create Result.make (a_path)
		end

end