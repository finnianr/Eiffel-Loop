note
	description: "Finding files with extension comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-06 9:36:35 GMT (Tuesday 6th April 2021)"
	revision: "2"

class
	FINDING_FILES_WITH_EXTENSION_COMPARISON

inherit
	EL_BENCHMARK_COMPARISON

	EL_SHARED_DIRECTORY

	EL_MODULE_OS

create
	make

feature -- Basic operations

	execute
		local
			file_list: EL_FILE_PATH_LIST
		do
			create file_list.make_with_count (6000) -- 4225 for project test.ecf

			compare ("list_w_code_c_files", 1, <<
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

	W_code_dir: EL_DIR_PATH
		once
			Result := "build/$ISE_PLATFORM/EIFGENs/classic/W_code"
			Result.expand
		end

end