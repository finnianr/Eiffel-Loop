note
	description: "File and directory experiments"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-11 15:23:58 GMT (Wednesday 11th March 2020)"
	revision: "7"

class
	FILE_EXPERIMENTS

inherit
	EXPERIMENTAL

	EL_MODULE_OS

	EL_MODULE_DIRECTORY

feature -- Basic operations

	date_setting
		local
			file, file_copy: RAW_FILE
		do
			create file.make_open_read ("data\01.png")
			create file_copy.make_open_write ("workarea\01(copy).png")
			file.copy_to (file_copy)
			file.close; file_copy.close
			file_copy.stamp (1418308263)
		end

	find_directories
		local
			find_cmd: like Command.new_find_directories
		do
			find_cmd := Command.new_find_directories ("source")
			find_cmd.set_depth (1 |..| 1)
			find_cmd.execute
			across find_cmd.path_list as dir loop
				lio.put_path_field ("", dir.item)
				lio.put_new_line
			end
		end

	find_files_command_on_root
			--
		local
			find_files_cmd: like Command.new_find_files
		do
			find_files_cmd := Command.new_find_files ("/", "*.rc")
			find_files_cmd.set_depth (1 |..| 1)
			find_files_cmd.execute
			lio.put_new_line
			from find_files_cmd.path_list.start until find_files_cmd.path_list.after loop
				lio.put_line (find_files_cmd.path_list.item.to_string)
				find_files_cmd.path_list.forth
			end
		end

	launch_remove_files_script
		local
			script: EL_FILE_PATH; file: PLAIN_TEXT_FILE
		do
--			script := "/tmp/eros removal.sh"
			script := Directory.temporary + "eros remove files.bat"
			create file.make_with_name (script)
			file.add_permission ("uog", "x")
			Execution_environment.launch ("call " + script.escaped)
		end

	make_directory_path
		local
			dir: EL_DIR_PATH; temp: EL_FILE_PATH
		do
			dir := "E:/"
			temp := dir + "temp"
			lio.put_string_field ("Path", temp.as_windows.to_string)
		end

	position
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_open_write ("workarea\test.txt")
			file.put_string ("one two three")
			lio.put_integer_field ("file.position", file.position)
			file.close
			file.delete
		end

	print_app_data
		do
			lio.put_path_field ("Directory.app_data", Directory.app_data)
			lio.put_new_line
		end

	print_os_user_list
		local
			dir_path: EL_DIR_PATH; user_info: like command.new_user_info
		do
			user_info := command.new_user_info
			across << user_info.configuration_dir_list, user_info.data_dir_list >> as dir_list loop
				across dir_list.item as dir loop
					lio.put_path_field ("", dir.item)
					lio.put_new_line
				end
			end
		end

	self_deletion_from_batch
		do
			Execution_environment.launch ("cmd /C D:\Development\Eiffel\Eiffel-Loop\test\uninstall.bat")
		end

	stamp
		local
			file: PLAIN_TEXT_FILE
			date: DATE_TIME
		do
			create file.make_open_write ("workarea\file.txt")
			file.put_string ("hello"); file.close
--			file.add_permission ("u", "Write Attributes")
			create date.make_from_epoch (1418308263)
			lio.put_labeled_string ("Date", date.out)
			file.set_date (1418308263)
			file.delete
		end


end
