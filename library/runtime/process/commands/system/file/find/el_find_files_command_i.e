note
	description: "Cross platform interface to [$source EL_FIND_FILES_COMMAND_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 15:39:13 GMT (Thursday 9th September 2021)"
	revision: "11"

deferred class
	EL_FIND_FILES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			make as make_path,
			copy_directory_items as copy_directory_files
		redefine
			path_list
		end

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path; a_name_pattern: READABLE_STRING_GENERAL)
			--
		do
			make_path (a_dir_path)
			name_pattern.append_string_general (a_name_pattern)
		end

feature -- Access

	path_list: EL_FILE_PATH_LIST

feature -- Measurement

	sum_file_byte_count: NATURAL
		do
			execute
			across path_list as path loop
				Result := Result + File_system.file_byte_count (path.item).to_natural_32
			end
		end

feature {NONE} -- Implementation

	copy_path_item (source_path: like new_path; destination_dir: EL_DIR_PATH)
		do
			OS.copy_file (source_path, destination_dir)
		end

	new_path (a_path: ZSTRING): EL_FILE_PATH
		do
			create Result.make (a_path)
		end

end