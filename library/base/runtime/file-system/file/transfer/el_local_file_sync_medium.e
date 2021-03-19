note
	description: "Local file system as file transfer medium destination"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-19 18:01:21 GMT (Friday 19th March 2021)"
	revision: "1"

class
	EL_LOCAL_FILE_SYNC_MEDIUM

inherit
	EL_FILE_SYNC_MEDIUM

	EL_MODULE_FILE_SYSTEM

	EL_FILE_OPEN_ROUTINES

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

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		-- copy item
		do
			if attached open_raw (item.source_path, Read) as source_file then
				File_system.copy_file_contents (source_file, home_dir + item.file_path)
				source_file.close
			end
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

feature {NONE} -- Internal attributes

	home_dir: EL_DIR_PATH
end