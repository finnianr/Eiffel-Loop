note
	description: "Local file system as file synchronized medium destination"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-05 6:31:15 GMT (Wednesday 5th June 2024)"
	revision: "11"

class
	EL_LOCAL_FILE_SYNC_MEDIUM

inherit
	EL_FILE_SYNC_MEDIUM

	EL_MODULE_FILE_SYSTEM; EL_MODULE_FILE

create
	make

feature {NONE} -- Initialization

	make
		do
			create home_dir
		end

feature -- Element change

	set_remote_home (a_home_dir: DIR_PATH)
		do
			home_dir := a_home_dir
		end

feature -- Status report

	directory_exists (dir_path: DIR_PATH): BOOLEAN
		-- `True' if directory exists on medium
		do
			Result := (home_dir #+ dir_path).exists
		end

	has_error: BOOLEAN
		do
		end

	is_open: BOOLEAN

feature -- Basic operations

	close
		do
			is_open := False
		end

	copy_item (item: EL_FILE_SYNC_ITEM)
		-- copy item
		local
			source_file: RAW_FILE
		do
			create source_file.make_with_name (item.source_path)
			File.copy_contents (source_file, home_dir + item.file_path)
		end

	make_directory (dir_path: DIR_PATH)
		-- make directory `dir_path' relative to home directory
		do
			File_system.make_directory (home_dir #+ dir_path)
		end

	open
		do
			is_open := True
		end

	remove_directory (dir_path: DIR_PATH)
		-- remove directory `dir_path' relative to home directory
		do
			if attached (home_dir #+ dir_path) as path and then path.exists then
				File_system.remove_directory (path)
			end
		end

	remove_item (item: EL_FILE_SYNC_ITEM)
		-- remove old item
		do
			if attached (home_dir + item.file_path) as path and then path.exists then
				File_system.remove_file (path)
			end
		end

	reset
		do
		end

feature {NONE} -- Internal attributes

	home_dir: DIR_PATH
end