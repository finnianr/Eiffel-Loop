note
	description: "Command factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_COMMAND_FACTORY

feature -- Internet

	new_sendmail (email: EL_EMAIL): EL_SEND_MAIL_COMMAND_I
		do
			create {EL_SEND_MAIL_COMMAND_IMP} Result.make (email)
		end

feature -- Informational

	new_cpu_info: EL_CPU_INFO_COMMAND_I
		do
			create {EL_CPU_INFO_COMMAND_IMP} Result.make
			-- make calls execute
		end

	new_jpeg_info (file_path: EL_FILE_PATH): EL_JPEG_FILE_INFO_COMMAND_I
		do
			create {EL_JPEG_FILE_INFO_COMMAND_IMP} Result.make (file_path)
		end

	new_user_list: EL_USER_LIST_COMMAND_I
		do
			create {EL_USER_LIST_COMMAND_IMP} Result.make
			-- make calls execute
		end

	new_directory_info (a_dir_path: EL_DIR_PATH): EL_DIRECTORY_INFO_COMMAND_I
		do
			create {EL_DIRECTORY_INFO_COMMAND_IMP} Result.make (a_dir_path)
			-- make calls execute
		end

	new_ip_adapter_info: EL_IP_ADAPTER_INFO_COMMAND_I
		do
			create {EL_IP_ADAPTER_INFO_COMMAND_IMP} Result.make
			-- make calls execute
		end

feature -- File management

	new_find_files (a_dir_path: EL_DIR_PATH; a_file_pattern: ZSTRING): EL_FIND_FILES_COMMAND_I
		do
			create {EL_FIND_FILES_COMMAND_IMP} Result.make (a_dir_path, a_file_pattern)
		end

	new_find_directories (a_dir_path: EL_DIR_PATH): EL_FIND_DIRECTORIES_COMMAND_I
		do
			create {EL_FIND_DIRECTORIES_COMMAND_IMP} Result.make (a_dir_path)
		end

	new_delete_file (a_file_path: EL_FILE_PATH): EL_DELETE_FILE_COMMAND_I
		do
			create {EL_DELETE_FILE_COMMAND_IMP} Result.make (a_file_path)
		end

	new_delete_tree (a_path: EL_DIR_PATH): EL_DELETE_TREE_COMMAND_I
		do
			create {EL_DELETE_TREE_COMMAND_IMP} Result.make (a_path)
		end

	new_copy_file (a_source_path: EL_FILE_PATH; a_destination_path: EL_PATH): EL_COPY_FILE_COMMAND_I
		do
			create {EL_COPY_FILE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_copy_tree (a_source_path, a_destination_path: EL_DIR_PATH): EL_COPY_TREE_COMMAND_I
		do
			create {EL_COPY_TREE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_move_file (a_source_path: EL_FILE_PATH; a_destination_path: EL_PATH): EL_MOVE_FILE_COMMAND_I
		do
			create {EL_MOVE_FILE_COMMAND_IMP} Result.make (a_source_path, a_destination_path)
		end

	new_make_directory (a_path: EL_DIR_PATH): EL_MAKE_DIRECTORY_COMMAND_I
		do
			create {EL_MAKE_DIRECTORY_COMMAND_IMP} Result.make (a_path)
		end
end
