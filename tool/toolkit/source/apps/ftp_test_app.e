note
	description: "FTP test application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-15 11:44:20 GMT (Monday 15th March 2021)"
	revision: "5"

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

	EIFFEL_LOOP_TEST_CONSTANTS
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
			Test.do_file_test ("txt/file.txt", agent send_file, 942172748)
			log.exit
		end

feature {NONE} -- Tests

	send_file (file_path: EL_FILE_PATH)
		local
			ftp: EL_FTP_WEBSITE
		do
			log.enter ("send_file")
			create ftp.make (Application_option.url, Application_option.user_home)
			ftp.login
			if ftp.is_logged_in then
				log.put_line ("Logged in")
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