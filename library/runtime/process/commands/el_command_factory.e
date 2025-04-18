note
	description: "Command factory accessible via ${EL_MODULE_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 14:09:16 GMT (Friday 28th March 2025)"
	revision: "29"

class
	EL_COMMAND_FACTORY

feature -- Linux only commands

	launch_gedit (file_path: FILE_PATH)
		local
			gedit_cmd: EL_FILE_UTILITY_COMMAND
		do
			create gedit_cmd.make ("gedit")
			gedit_cmd.set_path (file_path)
			gedit_cmd.execute
		end

	new_set_executable_mode_cmd (script_path: FILE_PATH): EL_OS_COMMAND
		local
			var: TUPLE [path: STRING]
		do
			create var
			create Result.make ("chmod 0755 $PATH")
			Result.fill_variables (var)
			Result.put_path (var.path, script_path)
		end

	sudo_execute (cmd: EL_OS_COMMAND_I)
		do
			cmd.sudo.enable
			cmd.execute
		end

feature -- Internet

	new_sendmail (email: EL_EMAIL): EL_SEND_MAIL_COMMAND_I
		do
			create {EL_SEND_MAIL_COMMAND_IMP} Result.make (email)
		end

feature -- Informational

	new_directory_info (a_dir_path: DIR_PATH): EL_DIRECTORY_INFO_COMMAND_I
		do
			create {EL_DIRECTORY_INFO_COMMAND_IMP} Result.make (a_dir_path)
			-- make calls execute
		end

	new_jpeg_info: EL_JPEG_FILE_INFO_COMMAND_I
		do
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} Result.make
		end

feature -- File management

	new_copy_file (a_source_path: FILE_PATH; a_destination_path: EL_PATH): EL_COPY_FILE_COMMAND_I
		do
			create {EL_COPY_FILE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_copy_tree (a_source_path, a_destination_path: DIR_PATH): EL_COPY_TREE_COMMAND_I
		do
			create {EL_COPY_TREE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_delete_directory (a_path: DIR_PATH): EL_DELETE_TREE_COMMAND_I
		do
			create {EL_DELETE_TREE_COMMAND_IMP} Result.make (a_path)
			Result.recursive.disable
		end

	new_delete_file (a_file_path: FILE_PATH): EL_DELETE_FILE_COMMAND_I
		do
			create {EL_DELETE_FILE_COMMAND_IMP} Result.make (a_file_path)
		end

	new_delete_tree (a_path: DIR_PATH): EL_DELETE_TREE_COMMAND_I
		do
			create {EL_DELETE_TREE_COMMAND_IMP} Result.make (a_path)
		end

	new_directory_sync  (a_source_path, a_destination_path: DIR_PATH): EL_RSYNC_COMMAND_I
		-- mirror local directory tree using Unix rsync command
		do
			create {EL_RSYNC_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_file_sync  (a_source_path: FILE_PATH; a_destination_path: DIR_PATH): EL_RSYNC_COMMAND_I
		-- mirror local file(s) using Unix rsync command
		-- `a_source_path.base' may contain wildcards
		do
			create {EL_RSYNC_COMMAND_IMP} Result.make_default
			Result.set_source_file_path (a_source_path)
			Result.set_destination_path (a_destination_path)
		end

	new_link_file (target_path, link_path: EL_PATH): EL_CREATE_LINK_COMMAND_I
		-- create symbolic link
		do
			create {EL_CREATE_LINK_COMMAND_IMP} Result.make_default
			Result.set_target_path (target_path)
			Result.set_link_path (link_path)
		end

	new_make_directory (a_path: DIR_PATH): EL_MAKE_DIRECTORY_COMMAND_I
		do
			create {EL_MAKE_DIRECTORY_COMMAND_IMP} Result.make (a_path)
		end

	new_md5_hash (a_path: FILE_PATH): EL_MD5_HASH_COMMAND_I
		do
			create {EL_MD5_HASH_COMMAND_IMP} Result.make (a_path)
		end

	new_move_file (a_source_path: FILE_PATH; a_destination_path: EL_PATH): EL_MOVE_FILE_COMMAND_I
		do
			create {EL_MOVE_FILE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_move_to_directory (a_source_path: EL_PATH; a_destination_path: DIR_PATH): EL_MOVE_TO_DIRECTORY_COMMAND_I
		do
			create {EL_MOVE_TO_DIRECTORY_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

end