note
	description: "Test set for [$source FTP_BACKUP_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 15:46:25 GMT (Tuesday 15th February 2022)"
	revision: "2"

class
	FTP_BACKUP_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("exclude_list", agent test_exclude_list)
			eval.call ("exclude_wildcard", agent test_exclude_wildcard)
			eval.call ("include_list", agent test_include_list)
		end

feature -- Tests

	test_exclude_list
		local
			archive: like new_archive
		do
			archive := new_archive ("exclude_list")
			assert_excludes_files (archive, <<
				"XML/jobserve.xml",
				"XML/Jobs-spreadsheet.fods"
			>>)
			assert_includes_files (archive, <<
				"XML/uuid.ecf"
			>>)
		end

	test_exclude_wildcard
		local
			archive: like new_archive
		do
			archive := new_archive ("exclude_wildcard")
			assert_excludes_files (archive, <<
				"XML/jobserve.xml",
				"XML/creatable/request-matrix-sum.xml"
			>>)
			assert_includes_files (archive, <<
				"XML/uuid.ecf"
			>>)
		end

	test_include_list
		do
			assert_includes_files (new_archive ("include_list"), <<
				"XML/jobserve.xml",
				"XML/Jobs-spreadsheet.fods",
				"txt/file.txt"
			>>)
		end

feature {NONE} -- Implementation

	assert_excludes_files (tar_path: FILE_PATH; path_list: ARRAY [STRING])
		do
			assert_file_condition (tar_path, path_list, False)
		end

	assert_file_condition (tar_path: FILE_PATH; path_list: ARRAY [STRING]; has: BOOLEAN)
		local
			path: ZSTRING
		do
			List_archive_cmd.put_path (Tar.file_path, tar_path)
			List_archive_cmd.execute
			across path_list as list loop
				path := list.item
				if has then
					assert ("includes " + path.to_latin_1, List_archive_cmd.lines.has (path))
				else
					assert ("excludes " + path.to_latin_1, not List_archive_cmd.lines.has (path))
				end
			end
		end

	assert_includes_files (tar_path: FILE_PATH; path_list: ARRAY [STRING])
		do
			assert_file_condition (tar_path, path_list, True)
		end

	new_archive (name: STRING): FILE_PATH
		local
			command: FTP_BACKUP_COMMAND
		do
			set_eiffel_loop_env
			file_list.find_first_true (agent {FILE_PATH}.base_matches (name, False))
			if file_list.found then
				create command.make (file_list.path, False)
				if attached command.config as config then
					assert ("is set", config.ftp_url ~ "eiffel-loop.com")
					assert ("is set", config.ftp_home_dir.to_string.same_string ("/public/www"))
					assert ("has 1 backup", config.backup_list.count = 1)
					if attached config.backup_list.first as backup then
						assert ("max 5 versions", backup.max_versions = 5)
						assert ("is myfiles/test", backup.ftp_destination_path.to_latin_1 ~ "myfiles/test")
					end
				end
				command.execute
				assert ("1 upload", command.archive_upload_list.count = 1)
				Result := command.archive_upload_list.first.source_path
				assert ("version 0", Result.version_number = 0)

				-- Check next version
				command.execute
				assert ("version 1", command.archive_upload_list.first.source_path.version_number = 1)
			else
				assert ("has bkup file", False)
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.bkup")
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/bkup/ftp_backup"
		end

	List_archive_cmd: EL_CAPTURED_OS_COMMAND
		once
			create Result.make_with_name ("tar-list", "tar --list --file $FILE_PATH")
			Result.fill_variables (Tar)
		end

	Tar: TUPLE [file_path: STRING]
		once
			create Result
		end

end