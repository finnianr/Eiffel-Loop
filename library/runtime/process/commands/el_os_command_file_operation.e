note
	description: "OS command implementation of [$source EL_FILE_OPERATION]"
	notes: "[
		Using this class is usually much faster than [$source EL_FILE_OPERATION]
		as the native OS commands **find** (on Unix) and **dir** (on Windows) are highly
		optimized.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-04 18:05:50 GMT (Sunday 4th December 2022)"
	revision: "1"

class
	EL_OS_COMMAND_FILE_OPERATION

inherit
	EL_FILE_OPERATION
		redefine
			new_file_list, new_directory_list
		end

	EL_MODULE_OS

feature -- Access

	new_directory_list (a_dir_path: DIR_PATH): EL_SORTABLE_ARRAYED_LIST [DIR_PATH]
		do
			Result := OS.directory_list (a_dir_path)
		end

	new_file_list (a_dir_path: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
		do
			Result := OS.file_list (a_dir_path, a_file_pattern)
		end
end