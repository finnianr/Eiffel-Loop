note
	description: "Faux FTP protocol for testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	FAUX_FTP_PROTOCOL

inherit
	EL_FTP_PROTOCOL
		redefine
			close, delete_file, login, quit, upload, initialize,
			is_open, open, file_exists, directory_exists,
			get_current_directory, remove_directory, set_current_directory,
			make_sub_directory, user_home_dir
		end

	EL_MODULE_OS

create
	make_write

feature {NONE} -- Initialization

	initialize
		do
			Precursor
			create data_socket.make_empty
		end

feature -- Access

	user_home_dir: DIR_PATH
		local
			l_path: ZSTRING
		do
			l_path := config.user_home_dir
			l_path.prepend_string_general ("ftp")
			Result := Work_area_dir #+ l_path
		end

feature -- Status report

	directory_exists (dir_path: DIR_PATH): BOOLEAN
		-- Does remote directory exist
		do
			if dir_path.is_empty then
				Result := True
			else
				Result := (current_directory #+ dir_path).exists
			end
		end

	file_exists (file_path: FILE_PATH): BOOLEAN
			-- Does remote directory exist
		do
			if file_path.is_empty then
				Result := True
			else
				last_succeeded := True
				Result := (current_directory + file_path).exists
			end
		end

	is_open: BOOLEAN

feature -- Basic operations

	upload (item: EL_FTP_UPLOAD_ITEM)
		local
			destination: DIR_PATH
		do
			destination := (user_home_dir + item.destination_file_path).parent
			File_system.make_directory (destination)
			OS.copy_file (item.source_path, destination)
			last_succeeded := (destination + item.source_path.base).exists
		end

feature -- Remote operations

	delete_file (file_path: FILE_PATH)
		do
			if file_path.exists then
				File_system.remove_file (file_path)
			else
				last_succeeded := True
			end
		end

	remove_directory (dir_path: DIR_PATH)
		do
			File_system.remove_directory (current_directory #+ dir_path)
		end

feature -- Status change

	close
			--
		do
			is_open := False
		end

	login
		do
		end

	open
		do
			File_system.make_directory (user_home_dir)
			is_open := True
		end

	quit
		do
		end

feature -- Element change

	set_current_directory (a_current_directory: DIR_PATH)
		do
			current_directory := a_current_directory
		end

feature {NONE} -- Implementation

	get_current_directory: DIR_PATH
		do
			Result := current_directory
		end

	make_sub_directory (dir_path: DIR_PATH)
		do
			OS.File_system.make_directory (current_directory #+ dir_path)
			last_succeeded := (current_directory #+ dir_path).exists
		end

feature {NONE} -- Constants

	Work_area_dir: DIR_PATH
		once
			Result := "workarea"
		end

end