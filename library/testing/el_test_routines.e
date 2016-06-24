note
	description: "Summary description for {EL_TEST_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 7:24:44 GMT (Monday 20th June 2016)"
	revision: "8"

class
	EL_TEST_ROUTINES

inherit
	EL_MODULE_LOG

	EL_MODULE_LOG_MANAGER

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_DIRECTORY

	EL_MODULE_URL

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
			log.enter ("print_checksum_list")
			from checksum_list.start until  checksum_list.after loop
				log_or_io.put_labeled_string (checksum_list.index.out + ". checksum", checksum_list.item.out)
				log_or_io.put_new_line
				checksum_list.forth
			end
			log.exit
		end

	do_file_test (a_input_file_path: EL_FILE_PATH; test_proc: like Type_test_procedure; valid_test_checksum: NATURAL)
			-- Perform test that operates on a single file
		local
			input_file_path: EL_FILE_PATH
		do
			log.enter ("do_file_test")
			create_work_area
			input_file_path := a_input_file_path
			File_system.copy_file (input_file_path, Work_area_directory)

			input_file_path := Work_area_directory + input_file_path.steps.last

			test_proc.set_operands ([input_file_path])
			do_test (Work_area_directory, Empty_pattern, test_proc, valid_test_checksum)
			log.exit
		end

	do_file_tree_test (a_input_dir_path: EL_DIR_PATH; test_proc: like Type_test_procedure; valid_test_checksum: NATURAL)
			-- Perform test that operates on a file tree
		do
			log.enter ("do_file_tree_test")
			do_directory_test (a_input_dir_path, Empty_pattern, test_proc, valid_test_checksum)
			log.exit
		end

	do_all_files_test (
		a_input_dir_path: EL_DIR_PATH; file_name_pattern: STRING
		test_proc: like Type_test_procedure; valid_test_checksum: NATURAL

	)
			-- Perform test that operates on set of files
		do
			log.enter ("do_all_files_test")
			do_directory_test (a_input_dir_path, file_name_pattern, test_proc, valid_test_checksum)
			log.exit
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
			input_dir_path := Work_area_directory.joined_dir_path (a_input_dir_path.steps.last)
			if a_input_dir_path.exists then
				File_system.copy_tree (a_input_dir_path, Work_area_directory)
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
		require
			logging_active: logging.is_active
		local
			search_results: ARRAYED_LIST [EL_FILE_PATH]
			timer: EL_EXECUTION_TIMER
		do
			Log_manager.clear_current_thread_log

			create timer.make
			if file_name_pattern = Empty_pattern then
				is_executing := True; test_proc.apply; is_executing := False
			else
				search_results := File_system.file_list (input_dir_path, file_name_pattern)
				from search_results.start until search_results.after loop
					test_proc.set_operands ([search_results.item])
					is_executing := True; test_proc.apply; is_executing := False
					search_results.forth
				end
			end
			timer.stop

			Log_manager.flush_current_thread_log
			File_system.copy_file (Log_manager.current_thread_log_path, input_dir_path + "main.log")
			set_checksum (input_dir_path)
			log_or_io.put_new_line

			last_test_succeeded := checksum = old_checksum

			log.put_labeled_string ("Executed", timer.out); log.put_new_line
			if last_test_succeeded then
				log_or_io.put_line ("TEST IS OK ")

			else
				log_or_io.put_line ("TEST FAILURE! ")
				log_or_io.put_labeled_string ("Target checksum", old_checksum.out)
				log_or_io.put_labeled_string (" Actual sum", checksum.out)
				log_or_io.put_new_line
				log_or_io.put_string ("<RETURN> to continue")
				io.read_line
			end
			Checksum_list.extend (checksum)
			File_system.delete_tree (Work_area_directory)
			create_work_area

			log_or_io.put_new_line
		end

	create_work_area
			--
		do
			if not Work_area_directory.exists then
				File_system.make_directory (Work_area_directory)
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

	set_checksum (input_dir_path: EL_DIR_PATH)
			--
		local
			file_list: EL_FILE_PATH_LIST
			line_list: EL_FILE_LINE_SOURCE
		do
			CRC.reset
			create file_list.make (input_dir_path, "*")
			from file_list.start until file_list.after loop
				if across excluded_file_extensions as excluded_ext all file_list.path.extension /~ excluded_ext.item  end then
					if across binary_file_extensions as ext some file_list.path.extension ~ ext.item end then
						CRC.add_file (file_list.path)
					else
						create line_list.make (file_list.path)
						from line_list.start until line_list.after loop
							line_list.item.replace_substring_general_all (Encoded_home_directory, once "")
							CRC.add_string (line_list.item)
							line_list.forth
						end
					end
				end
				file_list.forth
			end
			checksum := CRC.checksum
		end

	binary_file_extensions: ARRAY [ZSTRING]

	excluded_file_extensions: ARRAY [ZSTRING]

	checksum: NATURAL

feature -- Constants

	Encoded_home_directory: STRING
			--
		once
			Result := Url.encoded_path (Directory.home.to_string, True)
		end

	Work_area_directory: EL_DIR_PATH
			--
		once
			create Result.make ("workarea")
		end

	CRC: EL_CYCLIC_REDUNDANCY_CHECK_32
			--
		once
			create Result
		end

	Checksum_list: ARRAYED_LIST [NATURAL]
			--
		once
			create Result.make (10)
		end

	Empty_pattern: ZSTRING
		once
			create Result.make_empty
		end

feature {NONE} -- Type definitions

	Type_test_procedure: PROCEDURE [ANY, TUPLE [EL_PATH]]
		once
		end

end
