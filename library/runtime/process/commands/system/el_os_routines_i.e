note
	description: "OS operations based on command line utilities"
	notes: "[
		If you are creating an application on Windows with a graphical UI then these commands are not suitable
		as they cause a command console to momentarily appear. This might be off-putting to some users.
		For Windows GUI apps use instead the routines accessible via [$source EL_MODULE_FILE_SYSTEM]
		
		But maybe something can be done about this by appending `>null' to the command strings or
		something.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-21 9:11:30 GMT (Saturday 21st August 2021)"
	revision: "12"

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

	EL_MODULE_EXECUTABLE

	EL_STRING_8_CONSTANTS

feature -- Access

	user_list: EL_ZSTRING_LIST
		do
			Result := Command.new_user_info.user_list
		end

feature -- OS commands

	find_directories_command (a_dir_path: EL_DIR_PATH): like Find_directories_cmd
		do
			Result := Find_directories_cmd
			Result.set_defaults
			Result.set_dir_path (a_dir_path)
		end

	find_files_command (a_dir_path: EL_DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL): like Find_files_cmd
		do
			Result := Find_files_cmd
			Result.set_defaults
			Result.set_dir_path (a_dir_path)
			Result.set_name_pattern (a_file_pattern)
		end

feature -- File operations

	copy_file (source_path: EL_FILE_PATH; destination_path: EL_PATH)
			--
		do
			if attached Copy_file_cmd as cmd then
				cmd.set_source_path (source_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	delete_file (file_path: EL_FILE_PATH)
			--
		do
			if attached Delete_file_cmd as cmd then
				cmd.set_target_path (file_path)
				cmd.execute
			end
		end

	move_file (file_path: EL_FILE_PATH; destination_path: EL_PATH)
			--
		do
			if attached Move_file_cmd as cmd then
				cmd.set_source_path (file_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	move_to_directory (a_path: EL_PATH; destination_path: EL_DIR_PATH)
			--
		do
			if attached Move_to_directory_cmd as cmd then
				cmd.set_source_path (a_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

feature -- Directory operations

	copy_tree (source_path: EL_DIR_PATH; destination_path: EL_DIR_PATH)
			--
		do
			if attached Copy_tree_cmd as cmd then
				cmd.set_source_path (source_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	delete_tree (directory_path: EL_DIR_PATH)
			--
		do
			Delete_tree_cmd.set_target_path (directory_path)
			Delete_tree_cmd.execute
		end

	link (target_path, link_path: EL_PATH)
		-- create symbolic link
		do
			if attached Create_link_cmd as cmd then
				cmd.set_target_path (target_path)
				cmd.set_link_path (link_path)
				cmd.execute
			end
		end

feature -- File query

	directory_list (a_dir_path: EL_DIR_PATH): like Find_directories_cmd.path_list
		do
			if attached find_directories_command (a_dir_path) as cmd then
				cmd.execute
				Result := cmd.path_list
			end
		end

	file_md5_digest (path: EL_FILE_PATH): STRING
		require
			md5sum_available: md5sum_available
		do
			if path.exists then
				if attached MD5_sum_cmd as cmd then
					cmd.sum.wipe_out
					cmd.set_target_path (path)
					cmd.execute
					Result := cmd.sum.twin
				end
			else
				create Result.make_empty
			end
		end

	file_list (a_dir_path: EL_DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
			--
		do
			if attached find_files_command (a_dir_path, a_file_pattern) as cmd then
				cmd.execute
				Result := cmd.path_list
			end
		end

	filtered_file_list (
		a_dir_path: EL_DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL; condition: EL_QUERY_CONDITION [ZSTRING]
	): EL_FILE_PATH_LIST
			-- list of paths that meet filter `condition'
			-- Use `Filter.*' routines in class `EL_SHARED_FIND_FILE_FILTER_FACTORY'
		do
			if attached find_files_command (a_dir_path, a_file_pattern) as cmd then
				cmd.set_filter (condition)
				cmd.execute
				Result := cmd.path_list
			end
		end

feature -- Contract Support

	md5sum_available: BOOLEAN
		-- `True' if md5sum command is in search path
		do
			Result := Executable.search_path_has ("md5sum")
		end

feature -- Constants

	CPU_model_name: STRING
			--
		once
			Result := new_cpu_model_name
			Result.replace_substring_all (once "(R)", Empty_string_8)
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

	Create_link_cmd: EL_CREATE_LINK_COMMAND_I
		once
			create {EL_CREATE_LINK_COMMAND_IMP} Result.make_default
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

	MD5_sum_cmd: EL_MD5_SUM_COMMAND
		once
			create Result.make
		end

	Move_file_cmd: EL_MOVE_FILE_COMMAND_I
			--
		once
			create {EL_MOVE_FILE_COMMAND_IMP} Result.make_default
		end

	Move_to_directory_cmd: EL_MOVE_TO_DIRECTORY_COMMAND_I
			--
		once
			create {EL_MOVE_TO_DIRECTORY_COMMAND_IMP} Result.make_default
		end
end