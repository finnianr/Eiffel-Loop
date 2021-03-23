note
	description: "Ftp file sync medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-22 18:32:19 GMT (Monday 22nd March 2021)"
	revision: "1"

class
	EL_FTP_FILE_SYNC_MEDIUM

inherit
	EL_FILE_SYNC_MEDIUM
		undefine
			is_equal
		end

	EL_FTP_PROTOCOL
		rename
			set_current_directory as set_remote_home,
			current_directory as home_dir
		redefine
			Max_login_attempts
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

create
	make_write

feature -- Basic operations

	copy_item (item: EL_FILE_SYNC_ITEM)
		do
			transfer_file (item.source_path, item.file_path)
		end

	remove_item (item: EL_FILE_SYNC_ITEM)
		-- remove old item
		do
			delete_file (item.file_path)
		end

	reset
		do
			close; reset_error
			execution.sleep (500)
			login
		end

feature {NONE} -- Constants

	Max_login_attempts: INTEGER
		once
			Result := 1000
		end

end