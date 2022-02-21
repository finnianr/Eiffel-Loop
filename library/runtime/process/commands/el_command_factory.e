note
	description: "Command factory accessible via [$source EL_MODULE_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-21 7:55:33 GMT (Monday 21st February 2022)"
	revision: "18"

class
	EL_COMMAND_FACTORY

feature -- Internet

	new_sendmail (email: EL_EMAIL): EL_SEND_MAIL_COMMAND_I
		do
			create {EL_SEND_MAIL_COMMAND_IMP} Result.make (email)
		end

feature -- Informational

	new_jpeg_info (file_path: FILE_PATH): EL_JPEG_FILE_INFO_COMMAND_I
		do
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} Result.make (file_path)
		end

	new_directory_info (a_dir_path: DIR_PATH): EL_DIRECTORY_INFO_COMMAND_I
		do
			create {EL_DIRECTORY_INFO_COMMAND_IMP} Result.make (a_dir_path)
			-- make calls execute
		end

feature -- Linux only commands

	new_set_executable_mode_cmd (script_path: FILE_PATH): EL_OS_COMMAND
		local
			var: TUPLE [path: STRING]
		do
			create var
			create Result.make ("chmod 0755 $PATH")
			Result.fill_variables (var)
			Result.put_path (var.path, script_path)
		end

feature -- File management

	new_delete_file (a_file_path: FILE_PATH): EL_DELETE_FILE_COMMAND_I
		do
			create {EL_DELETE_FILE_COMMAND_IMP} Result.make (a_file_path)
		end

	new_delete_tree (a_path: DIR_PATH): EL_DELETE_TREE_COMMAND_I
		do
			create {EL_DELETE_TREE_COMMAND_IMP} Result.make (a_path)
		end

	new_copy_file (a_source_path: FILE_PATH; a_destination_path: EL_PATH): EL_COPY_FILE_COMMAND_I
		do
			create {EL_COPY_FILE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_copy_tree (a_source_path, a_destination_path: DIR_PATH): EL_COPY_TREE_COMMAND_I
		do
			create {EL_COPY_TREE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_link_file (target_path, link_path: EL_PATH): EL_CREATE_LINK_COMMAND_I
		-- create symbolic link
		do
			create {EL_CREATE_LINK_COMMAND_IMP} Result.make_default
			Result.set_target_path (target_path)
			Result.set_link_path (link_path)
		end

	new_move_file (a_source_path: FILE_PATH; a_destination_path: EL_PATH): EL_MOVE_FILE_COMMAND_I
		do
			create {EL_MOVE_FILE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_move_to_directory (a_source_path: EL_PATH; a_destination_path: DIR_PATH): EL_MOVE_TO_DIRECTORY_COMMAND_I
		do
			create {EL_MOVE_TO_DIRECTORY_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_make_directory (a_path: DIR_PATH): EL_MAKE_DIRECTORY_COMMAND_I
		do
			create {EL_MAKE_DIRECTORY_COMMAND_IMP} Result.make (a_path)
		end

end