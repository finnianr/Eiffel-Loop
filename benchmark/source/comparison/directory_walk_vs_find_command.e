note
	description: "Finding files with extension comparison"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	DIRECTORY_WALK_VS_FIND_COMMAND

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