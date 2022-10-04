note
	description: "Test set for [$source FTP_BACKUP_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 8:50:49 GMT (Tuesday 4th October 2022)"
	revision: "5"

class
	FTP_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("reuse_authenticator", agent test_reuse_authenticator)
		end

feature -- Tests

	test_reuse_authenticator
		local
			config: EL_FTP_CONFIGURATION; item: EL_FTP_UPLOAD_ITEM
			ftp: EL_FTP_PROTOCOL; authenticator: detachable EL_FTP_AUTHENTICATOR
		do
			create config.make ("ftp.eiffel-loop.com", "/htdocs")
			across file_list as list loop
				create ftp.make_write (config)
				if attached authenticator as previous then
					ftp.set_authenticator (previous)
					ftp.login
					ftp.make_directory (Test_set)
				else
					ftp.login
					authenticator := ftp.authenticator
				end
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