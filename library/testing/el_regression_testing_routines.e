note
	description: "[
		Checks if [http://www.accuhash.com/what-is-crc32.html CRC-32] checksum for program output differs
		from previously established checksum.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-08 15:09:53 GMT (Friday 8th July 2016)"
	revision: "8"

class
	EL_REGRESSION_TESTING_ROUTINES

inherit
	EL_MODULE_DIRECTORY

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_LOG

	EL_MODULE_OS

	EL_MODULE_URL

	EL_TEST_CONSTANTS

	EL_STRING_CONSTANTS
		rename
			Empty_string as Empty_pattern
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
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

	print_checksum_list
			--
		do
			from checksum_list.start until checksum_list.after loop
				log.put_labeled_string (checksum_list.index.out + ". checksum", checksum_list.item.out)
				log.put_new_line
				checksum_list.forth
			end
		end

	do_file_test (a_input_file_path: EL_FILE_PATH; test_proc: like Type_test_procedure; valid_test_checksum: NATURAL)
			-- Perform test that operates on a single file
		local
			input_file_path: EL_FILE_PATH
		do
			lio.put_path_field ("Testing with", a_input_file_path)
			create_work_area
			input_file_path := a_input_file_path
			OS.copy_file (input_file_path, Work_area_dir)

			input_file_path := Work_area_dir + input_file_path.steps.last

			test_proc.set_operands ([input_file_path])
			do_test (Work_area_dir, Empty_pattern, test_proc, valid_test_checksum)
		end

	do_file_tree_test (a_input_dir_path: EL_DIR_PATH; test_proc: like Type_test_procedure; valid_test_checksum: NATURAL)
			-- Perform test that operates on a file tree
		do
			lio.put_path_field ("Testing with", a_input_dir_path)
			do_directory_test (a_input_dir_path, Empty_pattern, test_proc, valid_test_checksum)
		end

	do_all_files_test (
		a_input_dir_path: EL_DIR_PATH; file_name_pattern: STRING
		test_proc: like Type_test_procedure; valid_test_checksum: NATURAL

	)
			-- Perform test that operates on set of files
		do
			lio.put_path_field ("Testing with", a_input_dir_path); lio.put_string_field (" pattern", file_name_pattern)
			do_directory_test (a_input_dir_path, file_name_pattern, test_proc, valid_test_checksum)
		end

feature {NONE} -- Implementation

	do_directory_test (
		a_input_dir_path: EL_DIR_PATH; file_name_pattern: ZSTRING
		test_proc: like Type_test_procedure; valid_test_checksum: NATURAL
	)
			-- Perform test that operates on a directory search
		local
			input_dir_path: EL_DIR_PATH
		do
			create_work_area
			input_dir_path := Work_area_dir.joined_dir_path (a_input_dir_path.steps.last)
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
		test_proc: like Type_test_procedure; old_checksum: NATURAL
	)
			--
		local
			search_results: ARRAYED_LIST [EL_FILE_PATH]
			timer: EL_EXECUTION_TIMER; new_checksum: NATURAL
		do
			log.enter_no_header ("do_test")
			create timer.make
			Crc_32.reset

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

			log.put_labeled_string ("Executed", timer.out); log.put_new_line
			if last_test_succeeded then
				log.put_line ("TEST IS OK ")

			else
				log.put_line ("TEST FAILURE! ")
				log.put_labeled_string ("Target checksum", old_checksum.out)
				log.put_labeled_string (" Actual sum", new_checksum.out)
				log.put_new_line
				log.put_string ("<RETURN> to continue")
				io.read_line
			end
			Checksum_list.extend (new_checksum)
			OS.delete_tree (Work_area_dir)
			create_work_area
			log.put_new_line
			log.exit_no_trailer
		end

	create_work_area
			--
		do
			if not Work_area_dir.exists then
				File_system.make_directory (Work_area_dir)
			end
		end

	normalized_directory_path (a_unix_path: ZSTRING): EL_DIR_PATH
			-- normalize unix path for current platform
		local
			l_steps: EL_PATH_STEPS
		do
			create l_steps.make (a_unix_path)
			Result := l_steps.as_directory_path
		end

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

	binary_file_extensions: ARRAY [ZSTRING]

	excluded_file_extensions: ARRAY [ZSTRING]

feature -- Constants

	Encoded_home_directory: STRING
			--
		once
			Result := Url.encoded_path (Directory.home.to_string, True)
		end

	Crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32
			--
		once
			create Result
		end

	Checksum_list: ARRAYED_LIST [NATURAL]
			--
		once
			create Result.make (10)
		end

feature {NONE} -- Type definitions

	Type_test_procedure: PROCEDURE [ANY, TUPLE [EL_PATH]]
		once
		end

end
