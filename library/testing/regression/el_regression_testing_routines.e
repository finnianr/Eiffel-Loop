note
	description: "[
		Checks if [http://www.accuhash.com/what-is-crc32.html CRC-32] checksum for program output differs
		from previously established checksum.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:36:31 GMT (Monday 5th August 2019)"
	revision: "15"

class
	EL_REGRESSION_TESTING_ROUTINES

inherit
	ANY

	EL_ZSTRING_CONSTANTS
		rename
			Empty_string as Empty_pattern
		end

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

	EL_MODULE_LOG

	EL_MODULE_OS

create
	make

feature {NONE} -- Initialization

	make (a_work_area_dir, a_test_data_dir: like work_area_dir)
			--
		do
			work_area_dir := a_work_area_dir; test_data_dir := a_test_data_dir
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
			binary_file_extensions.compare_objects
		end

	set_excluded_file_extensions (a_excluded_file_extensions: like excluded_file_extensions)
		do
			excluded_file_extensions := a_excluded_file_extensions
			excluded_file_extensions.compare_objects
		end

feature -- Basic operations

	do_all_files_test (
		relative_dir: EL_DIR_PATH; file_name_pattern: STRING; test: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL
	)
			-- Perform test that operates on set of files
		do
			lio.put_path_field ("Testing with", relative_dir); lio.put_string_field (" pattern", file_name_pattern)
			lio.put_new_line

			do_directory_test (relative_dir, file_name_pattern, test, valid_test_checksum)
		end

	do_file_test (relative_path: EL_FILE_PATH; test: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL)
			-- Perform test that operates on a single file
		do
			lio.put_path_field ("Testing with", relative_path)
			lio.put_new_line

			reset_work_area
			OS.copy_file (test_data_dir + relative_path, work_area_dir)
			test.set_operands ([work_area_dir + relative_path.base])
			do_test (work_area_dir, Empty_pattern, test, valid_test_checksum)
		end

	do_file_tree_test (relative_dir: EL_DIR_PATH; test: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL)
			-- Perform test that operates on a file tree
		do
			lio.put_path_field ("Testing with", relative_dir)
			lio.put_new_line

			do_directory_test (relative_dir, Empty_pattern, test, valid_test_checksum)
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
			file_list: EL_FILE_PATH_LIST; lines: EL_PLAIN_TEXT_LINE_SOURCE
			extension: ZSTRING
		do
			file_list := OS.file_list (input_dir_path, "*")
			from file_list.start until file_list.after loop
				extension := file_list.path.extension
				if not excluded_file_extensions.has (extension) then
					if binary_file_extensions.has (extension) then
						Crc_32.add_file (file_list.path)
					else
						create lines.make (file_list.path)
						from lines.start until lines.after loop
							lines.item.replace_substring_all (Current_working_dir, Empty_pattern)
							Crc_32.add_string (lines.item)
							lines.forth
						end
					end
				end
				file_list.forth
			end
		end

	reset_work_area
			-- create an empty work area
		do
			if work_area_dir.exists then
				OS.delete_tree (work_area_dir)
				reset_work_area
			else
				OS.File_system.make_directory (work_area_dir)
			end
		end

	do_directory_test (
		relative_dir: EL_DIR_PATH; file_name_pattern: ZSTRING; test: PROCEDURE [EL_PATH]; valid_test_checksum: NATURAL
	)
			-- Perform test that operates on a directory search
		local
			input_dir_path: EL_DIR_PATH
		do
			reset_work_area
			input_dir_path := work_area_dir.joined_dir_path (relative_dir.base)
			OS.File_system.make_directory (input_dir_path)

			OS.copy_tree (test_data_dir.joined_dir_path (relative_dir), work_area_dir)
			check
				is_directory: input_dir_path.is_directory
			end
			if file_name_pattern.is_empty then
				test.set_operands ([input_dir_path])
			end
			do_test (input_dir_path, file_name_pattern, test, valid_test_checksum)
		end

	do_test (
		input_dir_path: EL_DIR_PATH; file_name_pattern: ZSTRING; test: PROCEDURE [EL_PATH]; old_checksum: NATURAL
	)
			--
		local
			search_results: like OS.file_list; timer: EL_EXECUTION_TIMER; new_checksum: NATURAL
		do
			create timer.make
			Crc_32.reset

			timer.start
			if file_name_pattern.is_empty then
				is_executing := True; test.apply; is_executing := False
			else
				search_results := OS.file_list (input_dir_path, file_name_pattern)
				across search_results as search loop
					test.set_operands ([search.item])
					is_executing := True; test.apply; is_executing := False
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

feature {NONE} -- Internal attributes

	binary_file_extensions: ARRAY [ZSTRING]

	excluded_file_extensions: ARRAY [ZSTRING]

	work_area_dir: EL_DIR_PATH

	test_data_dir: EL_DIR_PATH

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

	Current_working_dir: ZSTRING
		once
			Result := Directory.current_working
		end

end
