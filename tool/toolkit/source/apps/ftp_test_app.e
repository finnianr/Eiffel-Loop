note
	description: "FTP test application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-09 12:11:16 GMT (Sunday 9th January 2022)"
	revision: "8"

class
	FTP_TEST_APP

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		rename
			extra_log_filter_set as empty_log_filter_set
		undefine
			test_data_dir
		redefine
			Is_test_mode, Is_logging_active, Application_option
		end

	EIFFEL_LOOP_TEST_ROUTINES
		rename
			EL_test_data_dir as test_data_dir
		end

create
	make

feature -- Basic operations

	test_run
			--
		do
			log.enter ("run")
			Test.do_file_test ("txt/file.txt", agent send_file, 4252695631)
			log.exit
		end

feature {NONE} -- Tests

	send_file (file_path: FILE_PATH)
		local
			ftp: EL_FTP_WEBSITE; item: EL_FTP_UPLOAD_ITEM
			destination_dir: DIR_PATH; remote_file_path: FILE_PATH
		do
			log.enter ("send_file")
			create ftp.make ([Application_option.url, Application_option.user_home])
			ftp.login
			ftp.change_home_dir
			if ftp.is_logged_in then
				log.put_line ("Logged in")
				destination_dir := "txt"; remote_file_path := destination_dir + file_path.base
				log.put_labeled_string ("directory exists", ftp.directory_exists (destination_dir).out)
				log.put_new_line
				log.put_line ("Creating directory")
				ftp.make_directory (destination_dir)
				log.put_labeled_string ("directory exists", ftp.directory_exists (destination_dir).out)
				log.put_new_line
				create item.make (file_path, destination_dir)
				log.put_path_field ("Uploading", file_path)
				log.put_new_line
				ftp.upload (item)
				log.put_labeled_string ("file exists", ftp.file_exists (remote_file_path).out)
				log.put_new_line
				log.put_path_field ("Deleting", remote_file_path)
				ftp.delete_file (remote_file_path)
				log.put_new_line
				log.put_labeled_string ("file exists", ftp.file_exists (remote_file_path).out)
				log.put_new_line
				log.put_path_field ("Deleting", destination_dir)
				log.put_new_line
				ftp.remove_directory (destination_dir)
				log.put_labeled_string ("directory exists", ftp.directory_exists (destination_dir).out)
				log.put_new_line
			else
				log.put_line ("Login failed")
			end
			ftp.close
			log.exit
		end

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [like Current]
		do
			create Result.make
		end

	normal_initialize
		do
		end

	normal_run
		do
		end

feature {NONE} -- Internal attributes

	url: STRING

	user_home: STRING

feature {NONE} -- Constants

	Application_option: FTP_LOGIN_OPTIONS
		once
			create Result.make
		end

	Description: STRING = "Test for class EL_FTP_PROTOCOL"

	Quit_cmd: STRING = "quit"

	Is_test_mode: BOOLEAN = True

	Is_logging_active: BOOLEAN = True

end
