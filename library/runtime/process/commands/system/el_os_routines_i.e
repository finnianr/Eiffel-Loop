note
	description: "OS operations based on command line utilities"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-23 8:40:43 GMT (Saturday 23rd June 2018)"
	revision: "3"

deferred class
	EL_OS_ROUTINES_I

inherit
	EL_MODULE_FILE_SYSTEM
		export
			{ANY} File_system
		end

	EL_MODULE_COMMAND
		export
			{NONE} all
		end

feature -- Access

	user_list: EL_ZSTRING_LIST
		do
			Result := Command.new_user_info.user_list
		end

feature -- OS commands

	-- These commands are not suited to Windows apps that have a GUI because they cause a command console to
	-- momentarily flash up. This might upset some users.

	copy_file (source_path: EL_FILE_PATH; destination_path: EL_PATH)
			--
		do
			Copy_file_cmd.set_source_path (source_path)
			Copy_file_cmd.set_destination_path (destination_path)
			Copy_file_cmd.execute
		end

	copy_tree (source_path: EL_DIR_PATH; destination_path: EL_DIR_PATH)
			--
		do
			Copy_tree_cmd.set_source_path (source_path)
			Copy_tree_cmd.set_destination_path (destination_path)
			Copy_tree_cmd.execute
		end

	delete_file (file_path: EL_FILE_PATH)
			--
		do
			Delete_file_cmd.set_target_path (file_path)
			Delete_file_cmd.execute
		end

	delete_tree (directory_path: EL_DIR_PATH)
			--
		do
			Delete_tree_cmd.set_target_path (directory_path)
			Delete_tree_cmd.execute
		end

	directory_list (a_dir_path: EL_DIR_PATH): like Find_directories_cmd.path_list
		do
			Find_directories_cmd.set_dir_path (a_dir_path)
			Find_directories_cmd.execute
			Result := Find_directories_cmd.path_list.twin
		end

	file_list (a_dir_path: EL_DIR_PATH; a_file_pattern: ZSTRING): EL_ARRAYED_LIST [EL_FILE_PATH]
			--
		do
			Find_files_cmd.set_dir_path (a_dir_path)
			Find_files_cmd.set_file_pattern (a_file_pattern)
			Find_files_cmd.execute
			Result := Find_files_cmd.path_list.twin
		end

	move_file (file_path: EL_FILE_PATH; destination_path: EL_PATH)
			--
		do
			Move_file_cmd.set_source_path (file_path)
			Move_file_cmd.set_destination_path (destination_path)
			Move_file_cmd.execute
		end

feature -- Constants

	CPU_model_name: STRING
			--
		once
			Result := new_cpu_model_name
			Result.replace_substring_all ("(R)", "")
		end

feature {NONE} -- Factory

	new_cpu_model_name: STRING
		deferred
		end

feature {NONE} -- Constants

	Copy_file_cmd: EL_COPY_FILE_COMMAND_I
			--
		once
			create {EL_COPY_FILE_COMMAND_IMP} Result.make_default
			Result.enable_timestamp_preserved
		end

	Copy_tree_cmd: EL_COPY_TREE_COMMAND_I
			--
		once
			create {EL_COPY_TREE_COMMAND_IMP} Result.make_default
			Result.enable_timestamp_preserved
		end

	Delete_file_cmd: EL_DELETE_FILE_COMMAND_I
			--
		once
			create {EL_DELETE_FILE_COMMAND_IMP} Result.make_default
		end

	Delete_tree_cmd: EL_DELETE_TREE_COMMAND_I
			--
		once
			create {EL_DELETE_TREE_COMMAND_IMP} Result.make_default
		end

	Find_directories_cmd: EL_FIND_DIRECTORIES_COMMAND_I
			--
		once
			create {EL_FIND_DIRECTORIES_COMMAND_IMP} Result.make_default
		end

	Find_files_cmd: EL_FIND_FILES_COMMAND_I
			--
		once
			create {EL_FIND_FILES_COMMAND_IMP} Result.make_default
		end

	Make_directory_cmd: EL_MAKE_DIRECTORY_COMMAND_I
			--
		once
			create {EL_MAKE_DIRECTORY_COMMAND_IMP} Result.make_default
		end

	Move_file_cmd: EL_MOVE_FILE_COMMAND_I
			--
		once
			create {EL_MOVE_FILE_COMMAND_IMP} Result.make_default
		end

end
