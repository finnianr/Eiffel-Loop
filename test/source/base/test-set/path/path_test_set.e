note
	description: "Test classes conforming to [$source EL_PATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 18:10:29 GMT (Sunday 14th January 2024)"
	revision: "27"

class
	PATH_TEST_SET

inherit
	EIFFEL_LOOP_TEST_SET

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["comparisons",				 agent test_comparisons],
				["extension",					 agent test_extension],
				["first_step",					 agent test_first_step],
				["initialization",			 agent test_initialization],
				["ise_path_access",			 agent test_ise_path_access],
				["joined_steps",				 agent test_joined_steps],
				["ntfs_translation",			 agent test_ntfs_translation],
				["parent",						 agent test_parent],
				["parent_of",					 agent test_parent_of],
				["path_sort",					 agent test_path_sort],
				["path_steps",					 agent test_path_steps],
				["relative_joins",			 agent test_relative_joins],
				["set_parent",					 agent test_set_parent],
				["universal_relative_path", agent test_universal_relative_path],
				["version_number",			 agent test_version_number]
			>>)
		end

feature -- Tests

	test_comparisons
		-- PATH_TEST_SET.test_comparisons
		note
			testing: "covers/{EL_PATH}.base_matches, covers/{EL_PATH}.same_extension",
						"covers/{EL_PATH}.same_as"
		local
			eiffel_pdf: FILE_PATH
		do
			eiffel_pdf := Documents_eiffel_pdf
			assert ("same string", eiffel_pdf.same_extension ("PDF", True))
			assert ("base matches", eiffel_pdf.base_matches ("Eiffel-spec", False))
			assert ("same path", eiffel_pdf.same_as (Documents_eiffel_pdf))
			assert ("not same path", not eiffel_pdf.same_as (Documents_eiffel_pdf.translated ("f", "_")))
		end

	test_extension
		note
			testing: "[
				covers/{EL_PATH}.with_new_extension, covers/{EL_PATH}.without_extension,
				covers/{EL_PATH}.has_dot_extension, covers/{EL_PATH}.replace_extension,
				covers/{EL_PATH}.remove_extension, covers/{EL_PATH}.add_extension
			]"
		local
			eiffel_pdf: FILE_PATH
		do
			eiffel_pdf := Documents_eiffel_pdf
			assert_same_string (Void, eiffel_pdf.with_new_extension ("doc").base, "Eiffel-spec.doc")
			assert_same_string (Void, eiffel_pdf.without_extension.base, "Eiffel-spec")
		end

	test_first_step
		note
			testing:
				"covers/{EL_PATH}.first_step, covers/{EL_PATH}.is_absolute"
		local
			dir_path: DIR_PATH
		do
			dir_path := Dev_eiffel
			assert_same_string ("is home", dir_path.first_step, "home")
			dir_path := Documents_eiffel_pdf
			assert_same_string ("is Documents", dir_path.first_step, "Documents")
		end

	test_initialization
		note
			testing:
				"covers/{EL_PATH}.make_from_steps, covers/{EL_PATH}.make, covers/{EL_PATH}.to_string",
				"covers/{EL_PATH}.joined_dir_steps"
		local
			home_path, config_path, mem_test_path: DIR_PATH
		do
			home_path := "/home"
			config_path := home_path.joined_dir_steps (<< "finnian", ".config" >>)
			assert ("same path", config_path.same_as (Home_finnian + "/.config"))

			mem_test_path := Mem_test_exe
			assert ("3 steps", mem_test_path.step_count = 3)
		end

	test_ise_path_access
		-- PATH_TEST_SET.test_ise_path_access
		note
			testing: "[
				covers/{EL_ISE_PATH_MANGER}.as_string,
				covers/{EL_path}.make_from_path
			]"
		local
			current_dir: DIRECTORY; current_path: EL_DIR_PATH
		do
			create current_dir.make_with_name (Directory.current_working)
			current_path := current_dir.path
			assert ("same path", current_path ~ Directory.current_working)
		end

	test_joined_steps
		note
			testing: "[
				covers/{EL_PATH}.make_from_steps, covers/{EL_PATH}.make, covers/{EL_PATH}.to_string
			]"
		local
			p1, p2: DIR_PATH
		do
			p1 := Dev_eiffel
			assert ("reversible to string", p1.to_string ~ Dev_eiffel)

			create p2.make_from_steps (Dev_eiffel.split_list ('/'))
			assert ("same path", p1 ~ p2)
		end

	test_ntfs_translation
		-- PATH_TEST_SET.test_ntfs_translation
		note
			testing: "[
				covers/{EL_PATH}.is_valid_ntfs,
				covers/{EL_PATH}.to_ntfs_compatible
			]"
		local
			parent, path_name, ntfs_compatible: ZSTRING; path: FILE_PATH
			invalidate_base, invalidate_parent: BOOLEAN
		do
			across 1 |..| 4 as n loop
				path := Mem_test_exe -- C:/Boot/memtest.exe
				assert ("valid path", path.is_valid_ntfs)
				inspect n.item
					when 1 then
						invalidate_base := True
					when 2 then
						invalidate_parent := True
					when 3 then
						invalidate_base := True; invalidate_parent := True
					when 4 then
						do_nothing
				end
				if invalidate_base then
					path.base.insert_character ('?', 2)
				end
				if invalidate_parent then
					parent := path.parent_string (False)
					parent.insert_character ('?', 5)
					path.set_parent (parent)
				end
				assert ("invalid path", (invalidate_base or invalidate_parent) implies not path.is_valid_ntfs)
				path_name := path
				path_name.replace_character ('?', '-')
				ntfs_compatible := path.to_ntfs_compatible ('-')
				assert_same_string (Void, ntfs_compatible, path_name)
			end
		end

	test_parent
		-- PATH_TEST_SET.test_parent
		note
			testing: "[
				covers/{EL_PATH}.has_parent, covers/{EL_PATH}.parent, covers/{EL_PATH}.parent_string,
				covers/{EL_PATH}.set_parent, covers/{EL_PATH_STEPS}.remove_until,
				covers/{EL_DIR_PATH}.make_parent
			]"
		local
			dir_path: DIR_PATH; root_name: ZSTRING; file_path: FILE_PATH
		do
			assert ("2 parents", parent_count (Home_finnian) = 2)
			assert ("1 parents", parent_count (Documents_eiffel_pdf) = 1)

			dir_path := "base/kernel/reflection"
			assert_same_string (Void, dir_path.parent.to_string, "base/kernel")

			across << Mem_test_exe, Home_finnian >> as list loop
				dir_path := list.item
				if list.cursor_index = 1 then
					root_name := "C:"
				else
					root_name := "/"
				end
				assert_same_string ("same string" + root_name, dir_path.parent.parent.to_string, root_name)
				assert_same_string (Void, dir_path.parent.to_string + OS.separator.out, dir_path.parent_string (False))
			end

			file_path := Documents_eiffel_pdf
			file_path.set_parent (Dev_eiffel)
			assert_same_string (Void, file_path, Dev_eiffel + OS.separator.out + file_path.base)
			assert_same_string (Void, Dev_environ.Eiffel_loop_dir.base, Dev_environ.Eiffel_loop)

			file_path := Documents_eiffel_pdf
			file_path := file_path.base
			assert ("empty parent", file_path.parent.is_empty)
		end

	test_parent_of
		-- PATH_TEST_SET.test_parent_of
		note
			testing: "covers/{EL_PATH}.is_parent_of"
		local
			dir_home, dir: DIR_PATH; dir_string, dir_string_home: ZSTRING
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

	test_path_sort
		-- PATH_TEST_SET.test_path_sort
		note
			testing: "covers/{EL_PATH}.is_less"
		local
			sortable_1: EL_SORTABLE_ARRAYED_LIST [FILE_PATH]
			sortable_2: EL_ARRAYED_LIST [FILE_PATH]
		do
			create sortable_1.make_from_array (<<
				Dev_eiffel, Documents_eiffel_pdf, Home_finnian, Mem_test_exe, Parent_dots
			>>)
			create sortable_2.make_from (sortable_1)
			sortable_1.ascending_sort
			sortable_2.order_by (agent {FILE_PATH}.to_string, True)
			assert ("same order", sortable_1.to_array ~ sortable_2.to_array)
		end

	test_path_steps
		note
			testing: "covers/{EL_PATH_STEPS}.same_i_th_step"
		local
			dir_path: EL_PATH_STEPS
		do
			dir_path := Dev_eiffel
			across dir_path.to_string.split ('/') as step loop
				assert ("same step", dir_path.same_i_th_step (step.item, step.cursor_index))
			end
		end

	test_relative_joins
		note
			testing: "covers/{DIR_PATH}.plus, covers/{DIR_PATH}.leading_backstep_count, covers/{DIR_PATH}.append_path"
		local
			eif_dir_path: DIR_PATH; abs_eiffel_pdf_path: FILE_PATH
		do
			eif_dir_path := Dev_eiffel
			abs_eiffel_pdf_path := eif_dir_path.plus (Parent_dots + Parent_dots + Documents_eiffel_pdf)

			assert ("same string", abs_eiffel_pdf_path.to_string ~ Home_finnian + "/" + Documents_eiffel_pdf)
		end

	test_set_parent
		note
			testing: "covers/{DIR_PATH}.set_parent, covers/{DIR_PATH}.set_parent_path"
		local
			eiffel_pdf: FILE_PATH; dir_path: DIR_PATH
		do
			eiffel_pdf := Documents_eiffel_pdf
			eiffel_pdf.set_parent_path (Dev_eiffel)
			assert_same_string (Void, eiffel_pdf.to_string, Dev_eiffel + "/Eiffel-spec.pdf")

			eiffel_pdf := Documents_eiffel_pdf
			dir_path := Dev_eiffel
			eiffel_pdf.set_parent (dir_path)
			assert_same_string (Void, eiffel_pdf.to_string, Dev_eiffel + "/Eiffel-spec.pdf")
		end

	test_universal_relative_path
		note
			testing: "[
				covers/{DIR_PATH}.relative_path, covers/{FILE_PATH}.relative_path,
				covers/{EL_PATH}.universal_relative_path, covers/{EL_PATH}.exists, covers/{EL_PATH}.expand
			]"
		local
			path_1, p1, relative_path: FILE_PATH; path_2, p2: DIR_PATH
		do
			across OS.file_list (Eiffel_latin_1_sources.to_string, "*.e") as list loop
				p1 := list.item.to_string
				path_1 := p1.relative_path (Eiffel_latin_1_sources)
				lio.put_labeled_string ("class", path_1.to_string)
				lio.put_new_line
				across OS.directory_list (Eiffel_latin_1_sources.to_string) as dir loop
					p2 := dir.item.to_string
					if Eiffel_latin_1_sources.is_parent_of (p2) then
						path_2 := p2.relative_path (Eiffel_latin_1_sources)
						relative_path := path_1.universal_relative_path (path_2)

						Execution_environment.push_current_working (p2)
						assert ("Path exists", relative_path.exists)
						Execution_environment.pop_current_working
					end
				end
			end
		end

	test_version_number
		note
			testing:
				"covers/{EL_PATH}.version_number, covers/{EL_PATH}.has_version_number",
				"covers/{EL_PATH}.version_interval"
		local
			path: FILE_PATH
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

	parent_count (a_path: DIR_PATH): INTEGER
		local
			path: EL_PATH
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

	Eiffel_latin_1_sources: DIR_PATH
		once
			Result := "$EIFFEL_LOOP/tool/eiffel/test-data/sources/latin-1"
			Result.expand
		ensure
			valid_expansion: Result.exists
		end

	Home_finnian: ZSTRING
		once
			Result := "/home/finnian"
		end

	Mem_test_exe: ZSTRING
		once
			Result := "C:/Boot/memtest.exe"
		end

	Parent_dots: ZSTRING
		once
			Result := "../"
		end

end