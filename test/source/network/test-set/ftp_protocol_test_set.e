note
	description: "Test set for ${EL_PROSITE_FTP_PROTOCOL}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-22 8:14:52 GMT (Monday 22nd July 2024)"
	revision: "23"

class
	FTP_PROTOCOL_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		redefine
			on_prepare
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
				["directory_create_delete", agent test_directory_create_delete],
				["upload_and_listing",		 agent test_upload_and_listing]
			>>)
		end

feature -- Tests

	test_directory_create_delete
		-- FTP_TEST_SET.test_directory_create_delete
		note
			testing: "[
				covers/{EL_FTP_PROTOCOL}.make_directory,
				covers/{EL_FTP_PROTOCOL}.remove_until_empty,
				covers/{EL_FTP_PROTOCOL}.directory_exists
			]"
		local
			ftp: EL_PROSITE_FTP_PROTOCOL; dir_path: EL_DIR_PATH
		do
			if is_testable then
				if config.credential.is_valid then
					create ftp.make_write (config)
					ftp.login
					assert ("logged in", ftp.is_logged_in)
					dir_path := "W_code/C1"
					assert ("not existing", not ftp.directory_exists (dir_path))
					ftp.make_directory (dir_path)
					assert ("directory exists", ftp.directory_exists (dir_path))
					ftp.close

				-- 2nd time round
					ftp.login
					ftp.make_directory (dir_path) -- already exists
					assert ("directory exists", ftp.directory_exists (dir_path))
					ftp.remove_until_empty (dir_path)
					ftp.remove_until_empty (dir_path)
					assert ("not directory exists", not ftp.directory_exists (dir_path.parent))

					ftp.close
				else
					failed ("Authenticated")
				end
			end
		end

	test_upload_and_listing
		-- FTP_TEST_SET.test_upload_and_listing
		note
			testing: "[
				covers/{EL_FTP_PROTOCOL}.entry_list,
				covers/{EL_FTP_PROTOCOL}.file_size,
				covers/{EL_FTP_PROTOCOL}.make_directory,
				covers/{EL_FTP_PROTOCOL}.remove_directory,
				covers/{EL_FTP_PROTOCOL}.delete_file,
				covers/{EL_FTP_PROTOCOL}.read_entry_count
			]"
		local
			ftp: EL_PROSITE_FTP_PROTOCOL; text_item: EL_FTP_UPLOAD_ITEM; name_list: EL_STRING_8_LIST
			dir_path: EL_DIR_PATH; name_path, src_path: FILE_PATH
		do
			if is_testable then
				if config.credential.is_valid then
					create ftp.make_write (config)
					ftp.login
					ftp.make_directory (Work_area_dir)

				-- Test big file
					src_path := "source/base/test-set/zstring/zstring_test_set.e"
					if attached open (src_path, Closed) as source then
						File.copy_contents_to_dir (source, Work_area_dir)
						file_list.extend (Work_area_dir + src_path.base)
					end

					file_list.sort (True)
					across file_list as path loop
						create text_item.make (path.item, Work_area_dir)
						text_item.display (lio, "Uploading")
						ftp.upload (text_item)
						assert ("same size", File.byte_count (path.item) = ftp.file_size (text_item.destination_file_path))
					end
					if attached ftp.entry_list (Work_area_dir) as entry_list then
						entry_list.sort (True)
						assert ("same list", entry_list ~ file_list)
					end
					text_item.display (lio, "Uploading a 2nd time")
					ftp.upload (text_item)
					assert ("no error", not ftp.has_error)

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

feature {NONE} -- Events

	on_prepare
		do
			Precursor
			config := new_pyxis_config.ftp
			if Args.has_value (Var_pp) then
				config.authenticate (Args.value (Var_pp))
				has_pp_argument := True
			else
				has_pp_argument := False
				lio.put_line ("Skipping test, no pp argument")
			end
			is_testable := Executable.Is_work_bench and has_pp_argument
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

feature {NONE} -- Internal attributes

	config: EL_FTP_CONFIGURATION

	has_pp_argument: BOOLEAN

	is_testable: BOOLEAN

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