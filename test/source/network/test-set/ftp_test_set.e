note
	description: "Test set for [$source FTP_BACKUP_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-22 18:36:05 GMT (Tuesday 22nd August 2023)"
	revision: "11"

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
				["ftp_directory_exists", agent test_ftp_directory_exists],
				["ftp_upload",				 agent test_ftp_upload]
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

				ftp.remove_until_empty (dir_path)
				assert ("not directory exists", not ftp.directory_exists (dir_path.parent))

				if attached ftp.entry_list ("css") as list then
					assert ("4 entries", list.count = 4)
					assert_same_string (Void, list.first_path.base, "common.css")
					assert_same_string (Void, list.last_path.base, "prism.css")
				end
				ftp.read_entry_count ("css")
				assert ("4 entries", ftp.last_entry_count = 4)

				ftp.close
			else
				failed ("Authenticated")
			end
		end

	test_ftp_upload
		-- FTP_TEST_SET.test_ftp_upload
		local
			config: EL_FTP_CONFIGURATION ftp: EL_FTP_PROTOCOL; dir_path: EL_DIR_PATH
			w_code_dir, classic_dir: EL_DIR_PATH; c_source: EL_FTP_UPLOAD_ITEM
		do
			config := new_pyxis_config.ftp
			if attached Args.value ("pp") as pp and then pp.count > 0 then
				config.authenticate (pp)
			else
				config.authenticate (Void)
			end
			w_code_dir := "build/$ISE_PLATFORM/EIFGENs/classic/W_code"
			w_code_dir.expand
			classic_dir := w_code_dir.parent
			if config.credential.is_valid then
				create ftp.make_write (config)
				ftp.open
				ftp.login
				across OS.file_list (w_code_dir, "*.c") as source loop
					create c_source.make_relative (source.item, classic_dir)
					c_source.display (lio, "Uploading")
					ftp.upload (c_source)
					if ftp.file_exists (source.item.relative_path (classic_dir)) then
						do_nothing
					end
				end
				ftp.close
			end
		end

feature {NONE} -- Implementation

	new_pyxis_config: EL_PYXIS_FTP_CONFIGURATION
		do
			create Result.make (Dev_environ.Eiffel_loop_dir + "doc-config/config.pyx")
		end

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