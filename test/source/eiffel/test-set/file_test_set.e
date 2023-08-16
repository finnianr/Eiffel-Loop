note
	description: "File and directory experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-12 20:31:22 GMT (Saturday 12th August 2023)"
	revision: "19"

class
	FILE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_ARGS

	EL_MODULE_OS; EL_MODULE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
--				["ftp_directory_exists", agent test_ftp_directory_exists]
			>>)
		end

feature -- Tests

	test_ftp_directory_exists
		-- FILE_TEST_SET.test_ftp_directory_exists
		local
			ftp: EL_FTP_PROTOCOL; home_dir: DIR_PATH
			domain: STRING
		do
			home_dir := Args.directory_path ("home")
			domain := Args.value ("ftp")
			create ftp.make_write ([domain, home_dir])
			ftp.open
			if attached ftp.authenticator as a then
				a.username.share (domain.substring (5, domain.count))
				a.password.share (Args.value ("pp"))
				a.force_authenticated
			end
			ftp.login
			assert ("logged in", ftp.is_logged_in)
			ftp.change_home_dir
			assert ("directory exists", ftp.directory_exists ("example"))
			ftp.close
		end

feature -- Basic operations

	date_setting
		local
			png_file, file_copy: RAW_FILE
		do
			create png_file.make_open_read ("data\01.png")
			create file_copy.make_open_write ("workarea\01(copy).png")
			png_file.copy_to (file_copy)
			png_file.close; file_copy.close
			file_copy.stamp (1418308263)
		end

	find_directories
		do
			if attached OS.find_directories_command ("source") as cmd then
				cmd.set_depth (1 |..| 1)
				cmd.execute
				across cmd.path_list as dir loop
					lio.put_path_field ("", dir.item)
					lio.put_new_line
				end
			end
		end

	find_files_command_on_root
			--
		do
			if attached OS.find_files_command ("/", "*.rc") as cmd then
				cmd.set_depth (1 |..| 1)
				cmd.execute
				lio.put_new_line
				across cmd.path_list as list loop
					lio.put_line (list.item.to_string)
				end
			end
		end

	launch_remove_files_script
		local
			script: FILE_PATH; bat_file: PLAIN_TEXT_FILE
		do
--			script := "/tmp/eros removal.sh"
			script := Directory.temporary + "eros remove files.bat"
			create bat_file.make_with_name (script)
			bat_file.add_permission ("uog", "x")
			Execution_environment.launch ("call " + script.escaped)
		end

	make_directory_path
		local
			dir: DIR_PATH; temp: FILE_PATH
		do
			dir := "E:/"
			temp := dir + "temp"
			lio.put_string_field ("Path", temp.as_windows)
		end

	position
		local
			txt_file: PLAIN_TEXT_FILE
		do
			create txt_file.make_open_write ("workarea\test.txt")
			txt_file.put_string ("one two three")
			lio.put_integer_field ("file.position", txt_file.position)
			txt_file.close
			txt_file.delete
		end

	print_app_data
		do
			lio.put_path_field ("Directory.app_data", Directory.app_data)
			lio.put_new_line
		end

	self_deletion_from_batch
		do
			Execution_environment.launch ("cmd /C D:\Development\Eiffel\Eiffel-Loop\test\uninstall.bat")
		end

	stamp
		local
			txt_file: PLAIN_TEXT_FILE
			date: DATE_TIME
		do
			create txt_file.make_open_write ("workarea\file.txt")
			txt_file.put_string ("hello"); txt_file.close
--			txt_file.add_permission ("u", "Write Attributes")
			create date.make_from_epoch (1418308263)
			lio.put_labeled_string ("Date", date.out)
			txt_file.set_date (1418308263)
			txt_file.delete
		end

end