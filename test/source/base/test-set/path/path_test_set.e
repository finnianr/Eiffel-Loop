note
	description: "Path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-12 6:56:10 GMT (Monday 12th July 2021)"
	revision: "15"

class
	PATH_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_MODULE_COMMAND

	EL_MODULE_DIRECTORY

	EL_MODULE_OS

	EL_MODULE_LOG

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("joined_steps", agent test_joined_steps)
			evaluator.call ("make_from_steps", agent test_make_from_steps)
			evaluator.call ("parent_of", agent test_parent_of)
			evaluator.call ("ntfs_translation", agent test_ntfs_translation)
			evaluator.call ("relative_joins", agent test_relative_joins)
			evaluator.call ("universal_relative_path", agent test_universal_relative_path)
		end

feature -- Tests

	test_joined_steps
		note
			testing: "covers/{EL_PATH}.make_from_path"
		local
			p1, p2: EL_DIR_PATH
		do
			p1 := Dev_eiffel
			create p2.make_from_steps (Dev_eiffel.split ('/'))
			assert ("same path", p1 ~ p2)
		end

	test_make_from_steps
		note
			testing: "covers/{EL_PATH}.make_from_steps"
		local
			home_path, config_path: EL_DIR_PATH
		do
			home_path := "/home"
			config_path := home_path.joined_dir_steps (<< "finnian", ".config" >>)
			assert ("same path", config_path.to_string ~ Home_finnian + "/.config")
		end

	test_ntfs_translation
		note
			testing: "covers/{EL_NT_FILE_SYSTEM_ROUTINES}.is_valid",
						"covers/{EL_NT_FILE_SYSTEM_ROUTINES}.translated"
		local
			ntfs: EL_NT_FILE_SYSTEM_ROUTINES
			path_name: ZSTRING; path: EL_FILE_PATH; index_dot: INTEGER
		do
			path_name := "C:/Boot/memtest.exe"
			path := path_name
			assert ("valid path", ntfs.is_valid (path))
			index_dot := path_name.index_of ('.', 1)
			path_name [index_dot] := ':'
			path := path_name
			assert ("invalid path", not ntfs.is_valid (path))

			path_name [index_dot] := '-'
			assert ("same path", ntfs.translated (path, '-').to_string ~ path_name)
		end

	test_parent_of
		local
			dir_home, dir: EL_DIR_PATH; dir_string, dir_string_home: ZSTRING
			is_parent: BOOLEAN
		do
			create dir_string.make_empty
			dir_string_home := Home_finnian
			dir_home := dir_string_home
			across Dev_eiffel.split ('/') as step loop
				if step.cursor_index > 1 then
					dir_string.append_character ('/')
				end
				dir_string.append (step.item)
				dir := dir_string
				is_parent := dir_string.starts_with (dir_string_home) and dir_string.count > dir_string_home.count
				assert ("same result", is_parent ~ dir_home.is_parent_of (dir))
			end
		end

	test_relative_joins
		local
			eif_dir_path: EL_DIR_PATH; abs_eiffel_pdf_path: EL_FILE_PATH
		do
			eif_dir_path := Dev_eiffel
			abs_eiffel_pdf_path := eif_dir_path.joined_file_path (Parent_dots + Parent_dots + Documents_eiffel_pdf)

			assert ("same string", abs_eiffel_pdf_path.to_string ~ Home_finnian + "/" + Documents_eiffel_pdf)
		end

	test_universal_relative_path
		local
			path_1, relative_path: EL_FILE_PATH; path_2: EL_DIR_PATH
		do
			log.enter ("test_universal_relative_path")
			across OS.file_list (Eiffel_dir, "*.e") as p1 loop
				path_1 := p1.item.relative_path (Eiffel_dir)
				log.put_path_field ("class", path_1)
				log.put_new_line
				across OS.directory_list (Eiffel_dir) as p2 loop
					if Eiffel_dir.is_parent_of (p2.item) then
						path_2 := p2.item.relative_path (Eiffel_dir)
						relative_path := path_1.universal_relative_path (path_2)

						Execution_environment.push_current_working (p2.item)
						assert ("Path exists", relative_path.exists)
						Execution_environment.pop_current_working
					end
				end
			end
			log.exit
		end

feature {NONE} -- Constants

	Dev_eiffel: ZSTRING
		once
			Result := Home_finnian + "/dev/Eiffel"
		end

	Documents_eiffel_pdf: ZSTRING
		once
			Result := "Documents/Eiffel-spec.pdf"
		end

	Eiffel_dir: EL_DIR_PATH
		once
			Result := "$EIFFEL_LOOP/tool/eiffel/test-data"
			Result.expand
		end

	Home_finnian: ZSTRING
		once
			Result := "/home/finnian"
		end

	Parent_dots: ZSTRING
		once
			Result := "../"
		end

end