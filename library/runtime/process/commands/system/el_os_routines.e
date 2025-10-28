note
	description: "OS operations based on command line utilities accessible via ${EL_MODULE_OS}"
	notes: "[
		If you are creating an application on Windows with a graphical UI then these commands are not suitable
		as they cause a command console to momentarily appear. This might be off-putting to some users.
		For Windows GUI apps use instead the routines accessible via ${EL_MODULE_FILE_SYSTEM}
		
		But maybe something can be done about this by appending `>null' to the command strings or
		something.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-10-28 11:36:34 GMT (Tuesday 28th October 2025)"
	revision: "36"

class
	EL_OS_ROUTINES

inherit
	ANY

	EL_MODULE_FILE_SYSTEM
		export
			{ANY} File_system
		end

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_EXECUTABLE

	EL_STRING_8_CONSTANTS

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature -- Access

	separator: CHARACTER
		do
			Result := Operating_environment.Directory_separator
		end

feature -- OS commands

	find_directories_command (a_dir_path: DIR_PATH): like Find_directories_cmd
		do
			Result := Find_directories_cmd
			Result.set_defaults
			Result.set_dir_path (a_dir_path)
		end

	find_files_command (a_dir_path: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL): like Find_files_cmd
		do
			Result := Find_files_cmd
			Result.set_defaults
			if a_dir_path.is_empty then
				Result.set_dir_path (Directory.current_working)
			else
				Result.set_dir_path (a_dir_path)
			end
			Result.set_name_pattern (a_file_pattern)
		end

feature -- File operations

	copy_file (source_path: FILE_PATH; destination_path: EL_PATH)
			--
		do
			if attached Copy_file_cmd as cmd then
				cmd.set_source_path (source_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	delete_file (file_path: FILE_PATH)
			--
		do
			if attached Delete_file_cmd as cmd then
				cmd.set_target_path (file_path)
				cmd.execute
			end
		end

	move_file (file_path: FILE_PATH; destination_path: EL_PATH)
			--
		do
			if attached Move_file_cmd as cmd then
				cmd.set_source_path (file_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	move_to_directory (a_path: EL_PATH; destination_path: DIR_PATH)
			--
		do
			if attached Move_to_directory_cmd as cmd then
				cmd.set_source_path (a_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

feature -- Directory operations

	copy_tree (source_path: DIR_PATH; destination_path: DIR_PATH)
			--
		do
			if attached Copy_tree_cmd as cmd then
				cmd.set_source_path (source_path)
				cmd.set_destination_path (destination_path)
				cmd.execute
			end
		end

	delete_tree (directory_path: DIR_PATH)
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

	rename_directory (from_path, to_path: DIR_PATH)
		do
			if attached Shared_directory.named (from_path) as dir then
				dir.rename_to (to_path)
			end
		end

feature -- File query

	directory_list (a_dir_path: DIR_PATH): EL_DIRECTORY_PATH_LIST
		do
			if attached find_directories_command (a_dir_path) as cmd then
				cmd.execute
				Result := cmd.path_list
			end
		end

	file_list (a_dir_path: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
			--
		do
			if attached find_files_command (a_dir_path, a_file_pattern) as cmd then
				cmd.execute
				Result := cmd.path_list
			end
		end

	file_pattern_list (file_pattern: FILE_PATH): EL_FILE_PATH_LIST
		do
			if attached find_files_command (file_pattern.parent, file_pattern.base) as cmd then
				cmd.execute
				Result := cmd.path_list
			end
		end

	filtered_file_list (
		a_dir_path: DIR_PATH; condition: EL_QUERY_CONDITION [ZSTRING]; a_file_pattern: READABLE_STRING_GENERAL
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

	md5_binary_digest (path: FILE_PATH): STRING
		do
			Result := md5_digest (path, True)
		end

	md5_text_digest (path: FILE_PATH): STRING
		do
			Result := md5_digest (path, False)
		end

	one_or_many_file_list (file_path_or_wildcard: FILE_PATH): EL_FILE_PATH_LIST
		do
			if file_path_or_wildcard.is_pattern then
				Result := file_list (file_path_or_wildcard.parent, file_path_or_wildcard.base)

			elseif file_path_or_wildcard.exists then
				create Result.make_from_array (<< file_path_or_wildcard  >>)
			else
				create Result.make_empty
			end
		end

	sorted_file_list (a_dir_path: DIR_PATH; a_file_pattern: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
			--
		do
			Result := file_list (a_dir_path, a_file_pattern)
			Result.ascending_sort
		end

feature -- Contract Support

	md5sum_available: BOOLEAN
		-- `True' if md5sum command is in search path
		do
			Result := Executable.search_path_has ("md5sum")
		end

feature {NONE} -- Implementation

	md5_digest (path: FILE_PATH; binary_mode: BOOLEAN): STRING
		require
			md5sum_available: md5sum_available
		do
			if attached MD5_sum_cmd as cmd then
				cmd.set_target_path (path)
				if binary_mode then
					cmd.set_binary
				else
					cmd.set_text
				end
				Result := cmd.digest_string
			else
				create Result.make_empty
			end
		end

feature {NONE} -- Constants

	Copy_file_cmd: EL_COPY_FILE_COMMAND_I
			--
		once
			create {EL_COPY_FILE_COMMAND_IMP} Result.make_default
			Result.timestamp_preserved.enable
		end

	Copy_tree_cmd: EL_COPY_TREE_COMMAND_I
			--
		once
			create {EL_COPY_TREE_COMMAND_IMP} Result.make_default
			Result.timestamp_preserved.enable
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

	MD5_sum_cmd: EL_MD5_HASH_COMMAND_I
		once
			create {EL_MD5_HASH_COMMAND_IMP} Result.make_default
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

	Move_to_directory_cmd: EL_MOVE_TO_DIRECTORY_COMMAND_I
			--
		once
			create {EL_MOVE_TO_DIRECTORY_COMMAND_IMP} Result.make_default
		end
end