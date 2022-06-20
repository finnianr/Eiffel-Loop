note
	description: "Test set for class [$source EL_FTP_PROTOCOL] with command line options [$source FTP_LOGIN_OPTIONS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 9:24:12 GMT (Saturday 19th February 2022)"
	revision: "2"

class
	FTP_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TEST_ROUTINES

	EIFFEL_LOOP_TEST_ROUTINES

	EL_SHARED_APPLICATION_OPTION

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("upload", agent test_upload)
		end

feature -- Tests

	test_upload
		do
			do_test ("send_file", 0, agent send_file, [file_list.first_path])
		end

feature {NONE} -- Implementation

	send_file (file_path: FILE_PATH)
		local
			ftp: EL_FTP_WEBSITE; item: EL_FTP_UPLOAD_ITEM
			destination_dir: DIR_PATH; remote_file_path: FILE_PATH
		do
			if attached {FTP_LOGIN_OPTIONS} App_option as option then
				create ftp.make ([option.url, option.user_home])
			else
				assert ("redefined new_command_options: FTP_LOGIN_OPTIONS", False)
			end
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
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "txt/file.txt" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := El_test_data_dir
		end

end