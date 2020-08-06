note
	description: "FTP test application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-06 11:19:09 GMT (Thursday 6th August 2020)"
	revision: "2"

class
	FTP_TEST_APP

inherit
	TEST_SUB_APPLICATION
		rename
			extra_log_filter as no_log_filter
		redefine
			normal_initialize, Application_option
		end

create
	make

feature {NONE} -- Initialization

	normal_initialize
		do
		end

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

end
