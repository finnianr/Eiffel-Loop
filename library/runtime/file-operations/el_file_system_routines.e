note
	description: "Summary description for {EL_FILE_SYSTEM_OPERATIONS_U8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 12:17:16 GMT (Monday 24th June 2013)"
	revision: "3"

class
	EL_FILE_SYSTEM_ROUTINES

inherit
	EL_MODULE_STRING
	 	rename
	 		copy as copy_object
	 	end

	EL_MODULE_EXECUTION_ENVIRONMENT
	 	rename
	 		copy as copy_object
	 	end

feature -- Access

	closed_none_plain_text: PLAIN_TEXT_FILE
		do
			create Result.make_with_name ("None.txt")
		end

	closed_raw_file (a_file_path: EL_FILE_PATH): RAW_FILE
			--
		do
			create Result.make_with_name (a_file_path.unicode)
		end

	current_working_directory: EL_DIR_PATH
			--
		do
			Result := Execution_environment.current_working_directory
		end

	file_megabyte_count (a_file_path: EL_FILE_PATH): DOUBLE
			--
		do
			Result := file_byte_count (a_file_path) / 1000000
		end

	file_byte_count (a_file_path: EL_FILE_PATH): INTEGER
			--
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (a_file_path.unicode)
			Result := l_file.count
		end

	line_one (a_file_path: EL_FILE_PATH): STRING
			--
		require
			file_exists: a_file_path.exists
		local
			text_file: PLAIN_TEXT_FILE
		do
			create text_file.make_open_read (a_file_path.unicode)
			create Result.make_empty
			if not text_file.is_empty then
				text_file.read_line
				Result := text_file.last_string
			end
			text_file.close
		end

	plain_text (a_file_path: EL_FILE_PATH): STRING
			--
		require
			file_exists: a_file_path.exists
		local
			text_file: PLAIN_TEXT_FILE
			count: INTEGER
			line: STRING
		do
			create text_file.make_open_read (a_file_path.unicode)
			create Result.make (text_file.count)
			if not text_file.is_empty then
				from until text_file.end_of_file loop
					text_file.read_line
					line := text_file.last_string
					count := count + line.count + 1
					line.prune_all_trailing ('%R')
					Result.append (line)
					if count < text_file.count then
						Result.append_character ('%N')
					end
				end
			end
			text_file.close
		end

	file_data (a_file_path: EL_FILE_PATH): MANAGED_POINTER
		require
			file_exists: a_file_path.exists
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_path.unicode)
			create Result.make (l_file.count)
			l_file.read_to_managed_pointer (Result, 0, Result.count)
			l_file.close
		end

feature -- Basic operations

	remove_file (a_file_path: EL_FILE_PATH)
			--
		require
			file_exists: a_file_path.exists
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (a_file_path.unicode)
			l_file.delete
		end

	delete_if_empty (directory_path: EL_DIR_PATH)
			--
		require
			path_exists: directory_path.exists
		do
			Directory.make_with_name (directory_path.unicode)
			if directory.is_empty then
				directory.delete
			end
		end

	delete_empty_steps (a_path_steps: EL_PATH_STEPS)
			--
		require
			path_exists: a_path_steps.as_directory_path.exists
		local
			steps: EL_PATH_STEPS
		do
			steps := a_path_steps.twin
			from
				Directory.make_with_name (a_path_steps.unicode)
			until
				not directory.is_empty or a_path_steps.is_empty
			loop
				Directory.delete
				steps.finish
				steps.remove
				Directory.make_with_name (steps.unicode)
			end
		end

	make_directory_from_steps (a_dir_path_steps: EL_PATH_STEPS)
			--
		local
			parent_path: EL_PATH_STEPS
		do
			create parent_path.make_with_count (a_dir_path_steps.count)
			across a_dir_path_steps as step loop
				parent_path.extend (step.item)
				if not (a_dir_path_steps.is_absolute and step.cursor_index = 1) then
					Directory.set_path (parent_path.unicode)
					if not Directory.exists then
						Directory.create_dir
					end
				end
			end
		end

	make_directory (a_dir_path: EL_DIR_PATH)
			--
		do
			if not a_dir_path.exists then
				make_directory_from_steps (a_dir_path.steps)
			end
		end

feature -- Console command operations

	-- These commands are not suited to Windows apps that have a GUI because they cause a command console to
	-- momentarily flash up. This might upset some users.

	copy (source_path: EL_PATH; destination_path: EL_PATH)
			--
		do
			copy_command.set_source_path (source_path)
			copy_command.set_destination_path (destination_path)
			execute (copy_command)
		end

	copy_tree (source_path: EL_DIR_PATH; destination_path: EL_DIR_PATH)
			--
		do
			copy_tree_command.set_source_path (source_path)
			copy_tree_command.set_destination_path (destination_path)
			execute (copy_tree_command)
		end

	move (file_path: EL_PATH; destination_path: EL_PATH)
			--
		do
			move_command.set_source_path (file_path)
			move_command.set_destination_path (destination_path)
			execute (move_command)
		end

	delete (a_path: EL_PATH)
			--
		do
			Delete_command.set_target_path (a_path)
			execute (Delete_command)
		end

	delete_tree (directory_path: EL_DIR_PATH)
			--
		do
			Delete_tree_command.set_target_path (directory_path)
			execute (Delete_tree_command)
		end

	file_list (a_dir_path: EL_DIR_PATH; a_file_pattern: STRING): ARRAYED_LIST [EL_FILE_PATH]
			--
		do
			Find_files_command.set_path (a_dir_path)
			Find_files_command.set_file_pattern (a_file_pattern)
			execute (Find_files_command)
			Result := find_files_command.path_list
		end

	directory_list (a_dir_path: EL_DIR_PATH): ARRAYED_LIST [EL_DIR_PATH]
		do
			Find_directories_command.set_path (a_dir_path)
			execute (Find_directories_command)
			Result := Find_directories_command.path_list
		end

feature -- Status query

	dir_exists (dir_path: EL_DIR_PATH): BOOLEAN
			--
		do
			Directory.make_with_name (dir_path.unicode)
			Result := Directory.exists
		end

	dir_exists_and_is_writeable (dir_path: EL_DIR_PATH): BOOLEAN
			--
		do
			Directory.make_with_name (dir_path.unicode)
			Result := Directory.exists and then Directory.is_writable
		end

	has_content (a_file_path: EL_FILE_PATH): BOOLEAN
			-- True if file not empty
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_path.unicode)
			Result := not l_file.is_empty
			l_file.close
		end

feature {NONE} -- Implementation

	execute (command: EL_OS_COMMAND [EL_COMMAND_IMPL])
			--
		do
			command.execute
		end

	Copy_command: EL_COPY_FILE_COMMAND
			--
		once
			create Result.make_default
			Result.enable_timestamp_preserved
		end

	Copy_tree_command: EL_COPY_TREE_COMMAND
			--
		once
			create Result.make_default
			Result.enable_timestamp_preserved
		end

	Move_command: EL_MOVE_FILE_COMMAND
			--
		once
			create Result.make_default
		end

	Delete_command: EL_DELETE_PATH_COMMAND
			--
		once
			create Result.make_default
		end

	Delete_tree_command: EL_DELETE_TREE_COMMAND
			--
		once
			create Result.make_default
		end

	Find_files_command: EL_FIND_FILES_COMMAND
			--
		once
			create Result.make_default
		end

	Find_directories_command: EL_FIND_DIRECTORIES_COMMAND
			--
		once
			create Result.make_default
		end

	Make_directory_command: EL_MAKE_DIRECTORY_COMMAND
			--
		once
			create Result.make_default
		end

	Directory: EL_DIRECTORY
			--
		once
			create Result
		end

end
