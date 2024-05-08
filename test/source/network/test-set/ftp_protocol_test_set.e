note
	description: "Test set for ${EL_PROSITE_FTP_PROTOCOL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-05 8:03:21 GMT (Sunday 5th May 2024)"
	revision: "20"

class
	FTP_PROTOCOL_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE

	EL_CRC_32_TESTABLE

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["ftp_directory_create_delete", agent test_ftp_directory_create_delete],
				["ftp_upload_and_listing",		  agent test_ftp_upload_and_listing]
			>>)
		end

feature -- Tests

	test_ftp_directory_create_delete
		-- FTP_TEST_SET.test_ftp_directory_create_delete
		note
			testing: "[
				covers/{EL_FTP_PROTOCOL}.make_directory,
				covers/{EL_FTP_PROTOCOL}.remove_until_empty,
				covers/{EL_FTP_PROTOCOL}.directory_exists
			]"
		local
			config: EL_FTP_CONFIGURATION ftp: EL_PROSITE_FTP_PROTOCOL; dir_path: EL_DIR_PATH
		do
			if Executable.Is_work_bench then
				config := new_pyxis_config.ftp
				if attached Args.value (Var_pp) as pp and then pp.count > 0 then
					config.authenticate (pp)
				else
					config.authenticate (Void)
				end
				if config.credential.is_valid then
					create ftp.make_write (config)
					ftp.open; ftp.login

					assert ("logged in", ftp.is_logged_in)
					ftp.change_home_dir

					dir_path := "W_code/C1"
					ftp.make_directory (dir_path)
					assert ("directory exists", ftp.directory_exists (dir_path))

					ftp.remove_until_empty (dir_path)
					assert ("not directory exists", not ftp.directory_exists (dir_path.parent))

					ftp.close
				else
					failed ("Authenticated")
				end
			end
		end

	test_ftp_upload_and_listing
		-- FTP_TEST_SET.test_ftp_upload_and_listing
		note
			testing: "[
				covers/{EL_FTP_PROTOCOL}.entry_list,
				covers/{EL_FTP_PROTOCOL}.make_directory,
				covers/{EL_FTP_PROTOCOL}.remove_directory,
				covers/{EL_FTP_PROTOCOL}.delete_file,
				covers/{EL_FTP_PROTOCOL}.read_entry_count
			]"
		local
			config: EL_FTP_CONFIGURATION ftp: EL_PROSITE_FTP_PROTOCOL; dir_path: EL_DIR_PATH
			text_item: EL_FTP_UPLOAD_ITEM; name_path: FILE_PATH; name_list: EL_STRING_8_LIST
		do
			if Executable.Is_work_bench then
				config := new_pyxis_config.ftp
				if attached Args.value (Var_pp) as pp and then pp.count > 0 then
					config.authenticate (pp)
				else
					config.authenticate (Void)
				end
				if config.credential.is_valid then
					create ftp.make_write (config)
					ftp.open; ftp.login
					ftp.make_directory (Work_area_dir)
					file_list.sort (True)
					across file_list as path loop
						create text_item.make (path.item, Work_area_dir)
						text_item.display (lio, "Uploading")
						ftp.upload (text_item)
					end
					if attached ftp.entry_list (Work_area_dir) as entry_list then
						entry_list.sort (True)
						assert ("same list", entry_list ~ file_list)
					end
					across file_list as path loop
						ftp.delete_file (path.item)
					end
					ftp.remove_directory (Work_area_dir)
					assert ("directory removed", not ftp.directory_exists (Work_area_dir))
					ftp.close
				else
					failed ("user validated")
				end
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

	Var_pp: ZSTRING
		once
			Result := "pp"
		end

end