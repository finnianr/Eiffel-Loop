note
	description: "Cross platform interface to ${EL_FIND_FILES_COMMAND_IMP}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "17"

deferred class
	EL_FIND_FILES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			make as make_path,
			copy_directory_items as copy_directory_files
		end

	EL_MODULE_FILE

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path; a_name_pattern: READABLE_STRING_GENERAL)
			--
		do
			make_path (a_dir_path)
			name_pattern.append_string_general (a_name_pattern)
		end

feature -- Measurement

	sum_file_byte_count: NATURAL
		do
			execute
			across path_list as path loop
				Result := Result + File.byte_count (path.item).to_natural_32
			end
		end

feature {NONE} -- Implementation

	copy_path_item (source_path: like new_path; destination_dir: DIR_PATH)
		do
			OS.copy_file (source_path, destination_dir)
		end

	new_path (a_path: ZSTRING): FILE_PATH
		do
			create Result.make (a_path)
		end

	new_path_list (n: INTEGER): EL_FILE_PATH_LIST
		do
			create Result.make (n)
		end
end