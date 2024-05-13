note
	description: "Medium containing synchronized tree of files: FTP, local file system, etc"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-08 10:50:47 GMT (Wednesday 8th May 2024)"
	revision: "6"

deferred class
	EL_FILE_SYNC_MEDIUM

feature -- Element change

	set_remote_home (a_home_dir: DIR_PATH)
		deferred
		end

feature -- Status report

	directory_exists (dir_path: DIR_PATH): BOOLEAN
		-- `True' if directory exists on medium
		deferred
		end

	is_open: BOOLEAN
		deferred
		end

	has_error: BOOLEAN
		deferred
		end

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		-- copy item
		require
			destination_dir_exists: directory_exists (item.file_path.parent)
		deferred
		end

	close
		deferred
		end

	log_error (log: EL_LOGGABLE)
		do
		end

	make_directory (dir_path: DIR_PATH)
		-- make directory `dir_path' relative to home directory
		deferred
		end

	open
		deferred
		end

	remove_directory (dir_path: DIR_PATH)
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