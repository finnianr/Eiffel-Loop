note
	description: "Finding files with extension comparison"
	notes: "[
		Passes over 10000 millisecs (in descending order)

			With EL_FIND_FILES_COMMAND_I : 19.0 times (100%)
			With EL_DIRECTORY            :  9.0 times (-52.6%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-31 8:08:55 GMT (Sunday 31st December 2023)"
	revision: "9"

class
	DIRECTORY_WALK_VS_FIND_COMMAND

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_DIRECTORY

	EL_MODULE_OS

create
	make

feature -- Access

	Description: STRING = "Finding files with extension"

feature -- Basic operations

	execute
		local
			file_list: EL_FILE_PATH_LIST
		do
			create file_list.make (6000) -- 4225 for project test.ecf

			compare ("list_w_code_c_files", <<
				["With EL_DIRECTORY", 				agent el_directory (file_list)],
				["With EL_FIND_FILES_COMMAND_I",	agent el_find_files_command (file_list)]
			>>)
		end

feature {NONE} -- el_os_routines_i

	el_directory (file_list: EL_FILE_PATH_LIST)
		do
			file_list.wipe_out
			file_list.append (Directory.named (W_code_dir).recursive_files_with_extension ("c"))
		end

	el_find_files_command (file_list: EL_FILE_PATH_LIST)
		do
			file_list.wipe_out
			file_list.append (OS.file_list (W_code_dir, "*.c"))
		end

feature {NONE} -- Constants

	W_code_dir: DIR_PATH
		once
			Result := "build/$ISE_PLATFORM/EIFGENs/classic/W_code"
			Result.expand
		end

end