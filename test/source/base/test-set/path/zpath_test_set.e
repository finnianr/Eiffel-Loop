note
	description: "Test classes conforming to [$source ZPATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 7:59:37 GMT (Tuesday 15th February 2022)"
	revision: "4"

class
	ZPATH_TEST_SET

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
			evaluator.call ("extension", agent test_extension)
			evaluator.call ("first_step", agent test_first_step)
			evaluator.call ("joined_steps", agent test_joined_steps)
			evaluator.call ("make_from_steps", agent test_make_from_steps)
			evaluator.call ("ntfs_translation", agent test_ntfs_translation)
			evaluator.call ("parent", agent test_parent)
			evaluator.call ("parent_of", agent test_parent_of)
			evaluator.call ("relative_joins", agent test_relative_joins)
			evaluator.call ("set_parent", agent test_set_parent)
			evaluator.call ("universal_relative_path", agent test_universal_relative_path)
			evaluator.call ("version_number", agent test_version_number)
		end

feature -- Tests

	test_extension
		note
			testing:
				"covers/{EL_ZPATH}.with_new_extension, covers/{EL_ZPATH}.without_extension,, covers/{EL_ZPATH}.has_dot_extension",
				"covers/{EL_ZPATH}.replace_extension, covers/{EL_ZPATH}.remove_extension, covers/{EL_ZPATH}.add_extension",
				"covers/{EL_ZPATH}.base_matches, covers/{EL_ZPATH}.same_extension"
		local
			eiffel_pdf: EL_FILE_ZPATH
		do
			eiffel_pdf := Documents_eiffel_pdf
			assert ("same string", eiffel_pdf.same_extension ("PDF", True))
			assert ("base matches", eiffel_pdf.base_matches ("Eiffel-spec"))
			assert ("same string", eiffel_pdf.with_new_extension ("doc").base.same_string ("Eiffel-spec.doc"))
			assert ("same string", eiffel_pdf.without_extension.base.same_string ("Eiffel-spec"))
		end

	test_first_step
		note
			testing:
				"covers/{EL_ZPATH}.first_step, covers/{EL_ZPATH}.is_absolute"
		local
			dir_path: EL_DIR_ZPATH
		do
			dir_path := Dev_eiffel
			assert ("is home", dir_path.first_step.same_string ("home"))
			dir_path := Documents_eiffel_pdf
			assert ("is Documents", dir_path.first_step.same_string ("Documents"))
		end

	test_joined_steps
		note
			testing: "covers/{EL_ZPATH}.make_from_steps, covers/{EL_ZPATH}.make, covers/{EL_ZPATH}.to_string"
		local
			p1, p2: EL_DIR_ZPATH
		do
			p1 := Dev_eiffel
			assert ("reversible to string", p1.to_string ~ Dev_eiffel)

			create p2.make_from_steps (Dev_eiffel.split_list ('/'))
			assert ("same path", p1 ~ p2)
		end

	test_make_from_steps
		note
			testing:
				"covers/{EL_ZPATH}.make_from_steps, covers/{EL_ZPATH}.make, covers/{EL_ZPATH}.to_string",
				"covers/{EL_ZPATH}.joined_dir_steps"
		local
			home_path, config_path: EL_DIR_ZPATH
		do
			home_path := "/home"
			config_path := home_path.joined_dir_steps (<< "finnian", ".config" >>)
			assert ("same path", config_path.to_string ~ Home_finnian + "/.config")
		end

	test_ntfs_translation
		note
			testing: "covers/{EL_ZPATH}.is_valid_ntfs, covers/{EL_ZPATH}.to_ntfs_compatible"
		local
			path_name: ZSTRING; path: EL_FILE_ZPATH; index_dot: INTEGER
		do
			path_name := Mem_test_exe
			path := path_name
			assert ("valid path", path.is_valid_ntfs)
			index_dot := path_name.index_of ('.', 1)
			path_name [index_dot] := ':'
			path := path_name
			assert ("invalid path", not path.is_valid_ntfs)

			path_name [index_dot] := '-'
			assert ("same path", path.to_ntfs_compatible ('-').to_string ~ path_name)
		end

	test_parent
		note
			testing: "covers/{EL_ZPATH}.has_parent, covers/{EL_ZPATH}.parent, covers/{EL_ZPATH}.parent_string"
		local
			dir_path: EL_DIR_ZPATH; root_name: ZSTRING
		do
			assert ("2 parents", parent_count (Home_finnian) = 2)
			assert ("1 parents", parent_count (Documents_eiffel_pdf) = 1)

			if {PLATFORM}.is_windows then
				dir_path := Mem_test_exe; root_name := "C:"
			else
				dir_path := Home_finnian; root_name := "/"
			end
			assert ("same as " + root_name, dir_path.parent.parent.to_string ~ root_name)
			assert ("same string", dir_path.parent.to_string ~ dir_path.parent_string)
		end

	test_parent_of
		note
			testing: "covers/{EL_ZPATH}.is_parent_of"
		local
			dir_home, dir: EL_DIR_ZPATH; dir_string, dir_string_home: ZSTRING
			is_parent: BOOLEAN
		do
			create dir_string.make_empty
			dir_string_home := Home_finnian
			dir_home := dir_string_home
			across Dev_eiffel.split_list ('/') as step loop
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
		note
			testing: "covers/{EL_DIR_ZPATH}.plus, covers/{EL_DIR_ZPATH}.leading_backstep_count, covers/{EL_DIR_ZPATH}.append_path"
		local
			eif_dir_path: EL_DIR_ZPATH; abs_eiffel_pdf_path: EL_FILE_ZPATH
		do
			eif_dir_path := Dev_eiffel
			abs_eiffel_pdf_path := eif_dir_path.plus (Parent_dots + Parent_dots + Documents_eiffel_pdf)

			assert ("same string", abs_eiffel_pdf_path.to_string ~ Home_finnian + "/" + Documents_eiffel_pdf)
		end

	test_set_parent
		note
			testing: "covers/{EL_DIR_ZPATH}.set_parent, covers/{EL_DIR_ZPATH}.set_parent_path"
		local
			eiffel_pdf: EL_FILE_ZPATH; dir_path: EL_DIR_ZPATH
		do
			eiffel_pdf := Documents_eiffel_pdf
			eiffel_pdf.set_parent_path (Dev_eiffel)
			assert ("same string", eiffel_pdf.to_string.same_string (Dev_eiffel + "/Eiffel-spec.pdf"))

			eiffel_pdf := Documents_eiffel_pdf
			dir_path := Dev_eiffel
			eiffel_pdf.set_parent (dir_path)
			assert ("same string", eiffel_pdf.to_string.same_string (Dev_eiffel + "/Eiffel-spec.pdf"))
		end

	test_universal_relative_path
		note
			testing:
				"covers/{EL_DIR_ZPATH}.relative_path, covers/{EL_FILE_ZPATH}.relative_path",
				"covers/{EL_ZPATH}.universal_relative_path, covers/{EL_ZPATH}.exists, covers/{EL_ZPATH}.expand"

		local
			path_1, p1, relative_path: EL_FILE_ZPATH; path_2, p2: EL_DIR_ZPATH
		do
			log.enter ("test_universal_relative_path")
			across OS.file_list (Eiffel_dir.to_string, "*.e") as list loop
				p1 := list.item.to_string
				path_1 := p1.relative_path (Eiffel_dir)
				log.put_labeled_string ("class", path_1.to_string)
				log.put_new_line
				across OS.directory_list (Eiffel_dir.to_string) as dir loop
					p2 := dir.item.to_string
					if Eiffel_dir.is_parent_of (p2) then
						path_2 := p2.relative_path (Eiffel_dir)
						relative_path := path_1.universal_relative_path (path_2)

						Execution_environment.push_current_working (p2)
						assert ("Path exists", relative_path.exists)
						Execution_environment.pop_current_working
					end
				end
			end
			log.exit
		end

	test_version_number
		note
			testing:
				"covers/{EL_ZPATH}.version_number, covers/{EL_ZPATH}.has_version_number",
				"covers/{EL_ZPATH}.version_interval"
		local
			path: EL_FILE_ZPATH
		do
			across << "myfile.mp3", "myfile.02.mp3", "myfile..mp3" >> as p loop
				path := p.item
				inspect p.cursor_index
					when 1 then
						assert ("no version", path.version_number = -1)
					when 2 then
						assert ("version is 2", path.version_number = 2)
						path.set_version_number (3)
						assert ("version is 3", path.version_number = 3)
						assert ("same format width", path.version_interval.item_count = 2)
					when 3 then
						assert ("no version", path.version_number = -1)
				end
			end
		end

feature {NONE} -- Implementation

	parent_count (a_path: EL_DIR_ZPATH): INTEGER
		local
			path: EL_ZPATH
		do
			from path := a_path until not path.has_parent loop
				path := path.parent
				Result := Result + 1
			end
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

	Eiffel_dir: EL_DIR_ZPATH
		once
			Result := "$EIFFEL_LOOP/tool/eiffel/test-data"
			Result.expand
		ensure
			valid_expansion: Result.exists
		end

	Home_finnian: ZSTRING
		once
			Result := "/home/finnian"
		end

	Mem_test_exe: STRING = "C:/Boot/memtest.exe"

	Parent_dots: ZSTRING
		once
			Result := "../"
		end

end