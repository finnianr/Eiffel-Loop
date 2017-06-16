note
	description: "[
		Checks if [http://www.accuhash.com/what-is-crc32.html CRC-32] checksum for program output differs
		from previously established checksum.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-12 12:26:53 GMT (Monday 12th June 2017)"
	revision: "6"

class
	EL_REGRESSION_TESTING_ROUTINES

inherit
	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_OS

	EL_MODULE_URL

	EL_STRING_CONSTANTS
		rename
			Empty_string as Empty_pattern
		end

create
	make

feature {NONE} -- Initialization

	make (a_work_area_dir: like work_area_dir)
			--
		do
			work_area_dir := a_work_area_dir
			create binary_file_extensions.make (1, 0)
			create excluded_file_extensions.make (1, 0)
		end

feature -- Access

	last_test_succeeded: BOOLEAN

feature -- Status query

	is_executing: BOOLEAN

feature -- Element change

	set_binary_file_extensions (a_binary_file_extensions: like binary_file_extensions)
			-- set binary files to exclude from file normalization before checksum
		do
			binary_file_extensions := a_binary_file_extensions
		end

	set_excluded_file_extensions (a_excluded_file_extensions: like excluded_file_extensions)
		do
			excluded_file_extensions := a_excluded_file_extensions
		end

feature -- Basic operations

	do_all_files_test (
		a_input_dir_path: EL_DIR_PATH; file_name_pattern: STRING
		test_proc: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL

	)
			-- Perform test that operates on set of files
		do
			lio.put_path_field ("Testing with", a_input_dir_path); lio.put_string_field (" pattern", file_name_pattern)
			do_directory_test (a_input_dir_path, file_name_pattern, test_proc, valid_test_checksum)
		end

	do_file_test (a_input_file_path: EL_FILE_PATH; test_proc: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL)
			-- Perform test that operates on a single file
		local
			input_file_path: EL_FILE_PATH
		do
			lio.put_path_field ("Testing with", a_input_file_path)
			reset_work_area
			input_file_path := a_input_file_path
			OS.copy_file (input_file_path, Work_area_dir)

			input_file_path := Work_area_dir + input_file_path.base

			test_proc.set_operands ([input_file_path])
			do_test (Work_area_dir, Empty_pattern, test_proc, valid_test_checksum)
		end

	do_file_tree_test (a_input_dir_path: EL_DIR_PATH; test_proc: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL)
			-- Perform test that operates on a file tree
		do
			lio.put_path_field ("Testing with", a_input_dir_path)
			do_directory_test (a_input_dir_path, Empty_pattern, test_proc, valid_test_checksum)
		end

	print_checksum_list
			--
		do
			from checksum_list.start until checksum_list.after loop
				log.put_labeled_string (checksum_list.index.out + ". checksum", checksum_list.item.out)
				log.put_new_line
				checksum_list.forth
			end
		end

feature {NONE} -- Implementation

	check_file_output (input_dir_path: EL_DIR_PATH)
			--
		local
			file_list: EL_FILE_PATH_LIST
			line_list: EL_FILE_LINE_SOURCE
		do
			create file_list.make (input_dir_path, "*")
			from file_list.start until file_list.after loop
				if across excluded_file_extensions as excluded_ext all file_list.path.extension /~ excluded_ext.item  end then
					if across binary_file_extensions as ext some file_list.path.extension ~ ext.item end then
						Crc_32.add_file (file_list.path)
					else
						create line_list.make (file_list.path)
						from line_list.start until line_list.after loop
							line_list.item.replace_substring_general_all (Encoded_home_directory, once "")
							Crc_32.add_string (line_list.item)
							line_list.forth
						end
					end
				end
				file_list.forth
			end
		end

	reset_work_area
			-- create an empty work area
		do
			if Work_area_dir.exists then
				OS.delete_tree (Work_area_dir)
				reset_work_area
			else
				File_system.make_directory (Work_area_dir)
			end
		end

	do_directory_test (
		a_input_dir_path: EL_DIR_PATH; file_name_pattern: ZSTRING
		test_proc: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL
	)
			-- Perform test that operates on a directory search
		local
			input_dir_path: EL_DIR_PATH
		do
			reset_work_area
			input_dir_path := Work_area_dir.joined_dir_path (a_input_dir_path.base)
			if a_input_dir_path.exists then
				OS.copy_tree (a_input_dir_path, Work_area_dir)
			else
				File_system.make_directory (input_dir_path)
			end
			check
				is_directory: input_dir_path.is_directory
			end

			if file_name_pattern = Empty_pattern then
				test_proc.set_operands ([input_dir_path])
			end
			do_test (input_dir_path, file_name_pattern, test_proc, valid_test_checksum)
		end

	do_test (
		input_dir_path: EL_DIR_PATH; file_name_pattern: ZSTRING
		test_proc: PROCEDURE [EL_PATH]; old_checksum: NATURAL
	)
			--
		local
			search_results: ARRAYED_LIST [EL_FILE_PATH]
			timer: EL_EXECUTION_TIMER; new_checksum: NATURAL
		do
			create timer.make
			Crc_32.reset

			timer.start
			if file_name_pattern = Empty_pattern then
				is_executing := True; test_proc.apply; is_executing := False
			else
				search_results := OS.file_list (input_dir_path, file_name_pattern)
				from search_results.start until search_results.after loop
					test_proc.set_operands ([search_results.item])
					is_executing := True; test_proc.apply; is_executing := False
					search_results.forth
				end
			end
			timer.stop
			check_file_output (input_dir_path)
			log.put_new_line

			new_checksum := Crc_32.checksum
			last_test_succeeded := new_checksum = old_checksum

			lio.put_labeled_string ("Executed", timer.elapsed_time.out); lio.put_new_line
			if last_test_succeeded then
				lio.put_line ("TEST IS OK ")

			else
				lio.put_line ("TEST FAILURE! ")
				lio.put_labeled_string ("Target checksum", old_checksum.out)
				lio.put_labeled_string (" Actual sum", new_checksum.out)
				lio.put_new_line

				io.put_string ("<RETURN> to continue")
				io.read_line
			end
			Checksum_list.extend (new_checksum)
			reset_work_area
			lio.put_new_line
		end

	normalized_directory_path (a_unix_path: ZSTRING): EL_DIR_PATH
			-- normalize unix path for current platform
		local
			l_steps: EL_PATH_STEPS
		do
			create l_steps.make (a_unix_path)
			Result := l_steps.as_directory_path
		end

feature {NONE} -- Internal attributes

	binary_file_extensions: ARRAY [ZSTRING]

	excluded_file_extensions: ARRAY [ZSTRING]

	work_area_dir: EL_DIR_PATH

feature -- Constants

	Checksum_list: ARRAYED_LIST [NATURAL]
			--
		once
			create Result.make (10)
		end

	Crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32
			--
		once
			create Result
		end

	Encoded_home_directory: STRING
			--
		once
			Result := Url.encoded_path (Directory.home.to_string, True)
		end

end
