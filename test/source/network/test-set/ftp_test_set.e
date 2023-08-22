note
	description: "Test set for [$source FTP_BACKUP_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-22 12:20:13 GMT (Tuesday 22nd August 2023)"
	revision: "10"

class
	FTP_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_PLAIN_TEXT_FILE_STATE_MACHINE
		undefine
			default_create
		redefine
			make
		end

	EL_MODULE_ARGS

	EL_CRC_32_TESTABLE

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["ftp_directory_exists", agent test_ftp_directory_exists]
			>>)
		end

feature -- Tests

	test_ftp_directory_exists
		-- FTP_TEST_SET.test_ftp_directory_exists
		local
			config: EL_FTP_CONFIGURATION ftp: EL_FTP_PROTOCOL; dir_path: EL_DIR_PATH
		do
			config := new_pyxis_config.ftp
			if attached Args.value ("pp") as pp and then pp.count > 0 then
				config.authenticate (pp)
			else
				config.authenticate (Void)
			end

			if config.credential.is_valid then
				create ftp.make_write (config)
				ftp.open
				ftp.login
				assert ("logged in", ftp.is_logged_in)
				ftp.change_home_dir
				dir_path := "W_code/C1"
				ftp.make_directory (dir_path)
				assert ("directory exists", ftp.directory_exists (dir_path))

				from until dir_path.is_empty loop
					ftp.remove_directory (dir_path)
					assert ("not directory exists", not ftp.directory_exists (dir_path))
					dir_path := dir_path.parent
				end

				across ftp.file_list ("css") as list loop
					lio.put_path_field ("css %S", list.item)
					lio.put_new_line
				end
				ftp.read_file_count ("css")
				assert ("4 entries", ftp.file_count = 4)

				ftp.close
			else
				failed ("Authenticated")
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.txt")
		end

	new_pyxis_config: EL_PYXIS_FTP_CONFIGURATION
		do
			create Result.make (Dev_environ.Eiffel_loop_dir + "doc-config/config.pyx")
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