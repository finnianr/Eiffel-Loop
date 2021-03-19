note
	description: "Faux FTP protocol for testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-15 13:27:31 GMT (Monday 15th March 2021)"
	revision: "5"

class
	FAUX_FTP_PROTOCOL

inherit
	EL_FTP_PROTOCOL
		redefine
			close, delete_file, login, quit, upload,
			is_open, open, file_exists, directory_exists,
			get_current_directory, make_default,
			remove_directory, set_current_directory, set_home_directory,
			make_sub_directory
		end

	EL_MODULE_OS

create
	make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create data_socket.make_empty
			create uploaded_list.make_empty
			uploaded_list.compare_objects
		end

feature -- Access

	uploaded_list: EL_FILE_PATH_LIST

feature -- Status report

	is_open: BOOLEAN

	directory_exists (dir_path: EL_DIR_PATH): BOOLEAN
		-- Does remote directory exist
		do
			if dir_path.is_empty then
				Result := True
			else
				Result := absolute_dir (dir_path).exists
			end
		end

	file_exists (file_path: EL_FILE_PATH): BOOLEAN
			-- Does remote directory exist
		do
			if file_path.is_empty then
				Result := True
			else
				last_succeeded := True
				Result := absolute_file_path (file_path).exists
			end
		end

feature -- Basic operations

	upload (item: EL_FTP_UPLOAD_ITEM)
		local
			destination: EL_DIR_PATH
		do
			destination := (home_directory + item.destination_file_path).parent
			File_system.make_directory (destination)
			OS.copy_file (item.source_path, destination)
			progress_listener.notify_tick
			last_succeeded := (destination + item.source_path.base).exists
			uploaded_list.extend (item.source_path)
		end

feature -- Remote operations

	delete_file (file_path: EL_FILE_PATH)
		do
			if file_path.exists then
				File_system.remove_file (file_path)
				progress_listener.notify_tick
			else
				last_succeeded := True
			end
		end

	remove_directory (dir_path: EL_DIR_PATH)
		do
			File_system.remove_directory (absolute_dir (dir_path))
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
			File_system.make_directory (home_directory)
			is_open := True
		end

	quit
		do
		end

feature -- Element change

	set_current_directory (a_current_directory: EL_DIR_PATH)
		do
			current_directory := a_current_directory
		end

	set_home_directory (a_home_directory: EL_DIR_PATH)
		local
			l_path: ZSTRING
		do
			l_path := a_home_directory
			l_path.prepend_string_general ("ftp")
			home_directory := Work_area_dir.joined_dir_path (l_path)
		end

feature {NONE} -- Implementation

	get_current_directory: EL_DIR_PATH
		do
			Result := current_directory
		end

	make_sub_directory (dir_path: EL_DIR_PATH)
		do
			OS.File_system.make_directory (absolute_dir (dir_path))
			last_succeeded := absolute_dir (dir_path).exists
		end

feature {NONE} -- Constants

	Work_area_dir: EL_DIR_PATH
		once
			Result := "workarea"
		end

end