note
	description: "Medium containing synchronized tree of files: FTP, local file system, etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-22 13:10:24 GMT (Monday 22nd March 2021)"
	revision: "2"

deferred class
	EL_FILE_SYNC_MEDIUM

feature -- Element change

	set_remote_home (a_home_dir: EL_DIR_PATH)
		deferred
		end

feature -- Status report

	directory_exists (dir_path: EL_DIR_PATH): BOOLEAN
		-- `True' if directory exists on medium
		deferred
		end

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		-- copy item
		require
			destination_dir_exists: directory_exists (item.file_path.parent)
		deferred
		end

	make_directory (dir_path: EL_DIR_PATH)
		-- make directory `dir_path' relative to home directory
		deferred
		end

	remove_directory (dir_path: EL_DIR_PATH)
		-- remove directory `dir_path' relative to home directory
		deferred
		end

	remove_item (item: EL_FILE_SYNC_ITEM)
		-- remove old item
		deferred
		end

	reset
		-- reset medium after an error
		deferred
		end

end