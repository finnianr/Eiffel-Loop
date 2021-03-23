note
	description: "Local file system as file synchronized medium destination"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-22 13:09:36 GMT (Monday 22nd March 2021)"
	revision: "3"

class
	EL_LOCAL_FILE_SYNC_MEDIUM

inherit
	EL_FILE_SYNC_MEDIUM

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make
		do
			create home_dir
		end

feature -- Element change

	set_remote_home (a_home_dir: EL_DIR_PATH)
		do
			home_dir := a_home_dir
		end

feature -- Status report

	directory_exists (dir_path: EL_DIR_PATH): BOOLEAN
		-- `True' if directory exists on medium
		do
			Result := (home_dir #+ dir_path).exists
		end

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		-- copy item
		local
			source_file: RAW_FILE
		do
			create source_file.make_with_name (item.source_path)
			File_system.copy_file_contents (source_file, home_dir + item.file_path)
		end

	make_directory (dir_path: EL_DIR_PATH)
		-- make directory `dir_path' relative to home directory
		do
			File_system.make_directory (home_dir.joined_dir_path (dir_path))
		end

	remove_directory (dir_path: EL_DIR_PATH)
		-- remove directory `dir_path' relative to home directory
		do
			File_system.remove_directory (home_dir.joined_dir_path (dir_path))
		end

	remove_item (item: EL_FILE_SYNC_ITEM)
		-- remove old item
		do
			File_system.remove_file (home_dir + item.file_path)
		end

	reset
		do
		end

feature {NONE} -- Internal attributes

	home_dir: EL_DIR_PATH
end