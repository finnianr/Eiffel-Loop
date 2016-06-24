﻿note
	description: "Summary description for {EL_FILE_SYSTEM_OPERATIONS_U8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-20 7:36:45 GMT (Monday 20th June 2016)"
	revision: "6"

class
	EL_FILE_SYSTEM_ROUTINES

inherit
	EL_SHARED_DIRECTORY
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
			create Result.make_with_name (a_file_path)
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
			create l_file.make_with_name (a_file_path)
			Result := l_file.count
		end

	line_one (a_file_path: EL_FILE_PATH): STRING
			--
		require
			file_exists: a_file_path.exists
		local
			text_file: PLAIN_TEXT_FILE
		do
			create text_file.make_open_read (a_file_path)
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
			text_file: PLAIN_TEXT_FILE; count: INTEGER; line: STRING
		do
			create text_file.make_open_read (a_file_path)
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
			create l_file.make_open_read (a_file_path)
			create Result.make (l_file.count)
			l_file.read_to_managed_pointer (Result, 0, l_file.count)
			l_file.close
		end

feature -- Basic operations

	copy_file_contents (source_file: FILE; destination_path: EL_FILE_PATH)
		require
			exists_and_closed: source_file.is_closed and source_file.exists
		local
			destination_file: FILE; data: MANAGED_POINTER
			byte_count: INTEGER
		do
			make_directory (destination_path.parent)
			destination_file := source_file.twin
			source_file.open_read
			byte_count := source_file.count
			-- Read
			create data.make (byte_count)
			source_file.read_to_managed_pointer (data, 0, byte_count)
			notify_progress (source_file)
			source_file.close
			-- Write
			destination_file.make_open_write (destination_path)
			destination_file.put_managed_pointer (data, 0, byte_count)
			notify_progress (destination_file)
			destination_file.close
		end

	remove_file (a_file_path: EL_FILE_PATH)
			--
		require
			file_exists: a_file_path.exists
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (a_file_path)
			l_file.delete
		end

	rename_file (a_file_path, new_file_path: EL_FILE_PATH)
			-- change name of file to new_name. If preserve_extension is true, the original extension is preserved
		require
			file_exists: a_file_path.exists
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (a_file_path)
			l_file.rename_file (new_file_path)
		end

	delete_if_empty (dir_path: EL_DIR_PATH)
			--
		require
			path_exists: dir_path.exists
		local
			dir: like named_directory
		do
			dir := named_directory (dir_path)
			if dir.is_empty then
				dir.delete
			end
		end

	delete_empty_branch (dir_path: EL_DIR_PATH)
			--
		require
			path_exists: dir_path.exists
		local
			dir_steps: EL_PATH_STEPS
			dir: like named_directory
		do
			dir_steps := dir_path
			from dir := named_directory (dir_path) until dir_steps.is_empty or else not dir.is_empty loop
				dir.delete
				dir_steps.remove_last
				dir.make_with_name (dir_steps)
			end
		end

	make_directory (a_dir_path: EL_DIR_PATH)
			-- recursively create directory
		local
			dir_parent: EL_DIR_PATH
		do
			if not (a_dir_path.is_empty or else a_dir_path.exists) then
				dir_parent := a_dir_path.parent
				make_directory (dir_parent)
				if dir_parent.exists_and_is_writeable then
					named_directory (a_dir_path).create_dir
				end
			end
		end

feature -- Console command operations

	-- These commands are not suited to Windows apps that have a GUI because they cause a command console to
	-- momentarily flash up. This might upset some users.

	copy_file (source_path: EL_FILE_PATH; destination_path: EL_PATH)
			--
		do
			Copy_file_command.set_source_path (source_path)
			Copy_file_command.set_destination_path (destination_path)
			Copy_file_command.execute
		end

	copy_tree (source_path: EL_DIR_PATH; destination_path: EL_DIR_PATH)
			--
		do
			Copy_tree_command.set_source_path (source_path)
			Copy_tree_command.set_destination_path (destination_path)
			Copy_tree_command.execute
		end

	move_file (file_path: EL_FILE_PATH; destination_path: EL_PATH)
			--
		do
			Move_file_command.set_source_path (file_path)
			Move_file_command.set_destination_path (destination_path)
			Move_file_command.execute
		end

	delete_file (file_path: EL_FILE_PATH)
			--
		do
			Delete_file_command.set_target_path (file_path)
			Delete_file_command.execute
		end

	delete_tree (directory_path: EL_DIR_PATH)
			--
		do
			Delete_tree_command.set_target_path (directory_path)
			Delete_tree_command.execute
		end

	file_list (a_dir_path: EL_DIR_PATH; a_file_pattern: ZSTRING): EL_ARRAYED_LIST [EL_FILE_PATH]
			--
		do
			Find_files_command.set_path (a_dir_path)
			Find_files_command.set_file_pattern (a_file_pattern)
			Find_files_command.execute
			Result := Find_files_command.path_list.twin
		end

	directory_list (a_dir_path: EL_DIR_PATH): like Find_directories_command.path_list
		do
			Find_directories_command.set_path (a_dir_path)
			Find_directories_command.execute
			Result := Find_directories_command.path_list.twin
		end

feature -- Status query

	has_content (a_file_path: EL_FILE_PATH): BOOLEAN
			-- True if file not empty
		local
			l_file: RAW_FILE
		do
			create l_file.make_open_read (a_file_path)
			Result := not l_file.is_empty
			l_file.close
		end

feature {NONE} -- Implementation

	notify_progress (file: FILE)
		do
			if attached {EL_NOTIFYING_FILE} file as l_file then
				l_file.notify
			end
		end

feature {NONE} -- Constants

	Copy_file_command: EL_COPY_FILE_COMMAND_I
			--
		once
			create {EL_COPY_FILE_COMMAND_IMP} Result.make_default
			Result.enable_timestamp_preserved
		end

	Copy_tree_command: EL_COPY_TREE_COMMAND_I
			--
		once
			create {EL_COPY_TREE_COMMAND_IMP} Result.make_default
			Result.enable_timestamp_preserved
		end

	Move_file_command: EL_MOVE_FILE_COMMAND_I
			--
		once
			create {EL_MOVE_FILE_COMMAND_IMP} Result.make_default
		end

	Delete_file_command: EL_DELETE_FILE_COMMAND_I
			--
		once
			create {EL_DELETE_FILE_COMMAND_IMP} Result.make_default
		end

	Delete_tree_command: EL_DELETE_TREE_COMMAND_I
			--
		once
			create {EL_DELETE_TREE_COMMAND_IMP} Result.make_default
		end

	Find_files_command: EL_FIND_FILES_COMMAND_I
			--
		once
			create {EL_FIND_FILES_COMMAND_IMP} Result.make_default
		end

	Find_directories_command: EL_FIND_DIRECTORIES_COMMAND_I
			--
		once
			create {EL_FIND_DIRECTORIES_COMMAND_IMP} Result.make_default
		end

	Make_directory_command: EL_MAKE_DIRECTORY_COMMAND_I
			--
		once
			create {EL_MAKE_DIRECTORY_COMMAND_IMP} Result.make_default
		end

end
