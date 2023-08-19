note
	description: "Test set for [$source FTP_BACKUP_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-19 14:49:43 GMT (Saturday 19th August 2023)"
	revision: "9"

class
	FTP_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["ftp_directory_exists", agent test_ftp_directory_exists],
				["reuse_authenticator",	 agent test_reuse_authenticator]
			>>)
		end

feature -- Tests

	test_ftp_directory_exists
		-- FILE_TEST_SET.test_ftp_directory_exists
		local
			config: EL_FTP_CONFIGURATION
			ftp: EL_FTP_PROTOCOL; home_dir: DIR_PATH
			url: FTP_URL; dir_path: EL_DIR_PATH
		do
--			create config.

--			create ftp.make_write ([url.host, home_dir])
			ftp.open
			ftp.login
			assert ("logged in", ftp.is_logged_in)
			ftp.change_home_dir
			dir_path := "test_location"
			ftp.make_directory (dir_path)
			assert ("directory exists", ftp.directory_exists (dir_path))
			ftp.remove_directory (dir_path)
			assert ("not directory exists", not ftp.directory_exists (dir_path))
			ftp.close
		end

	test_reuse_authenticator
		local
			config: EL_FTP_CONFIGURATION; item: EL_FTP_UPLOAD_ITEM
			ftp: EL_FTP_PROTOCOL
		do
			create config.make_default
			config.authenticate
			across file_list as list loop
				create ftp.make_write (config)
				ftp.login
				ftp.make_directory (Test_set)
				lio.put_path_field ("Uploading", list.item)
				lio.put_new_line
				create item.make (list.item, Test_set)
				ftp.upload (item)
				ftp.close
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.txt")
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "data/txt"
		end

	Test_set: DIR_PATH
		once
			Result := "test_set"
		end


end