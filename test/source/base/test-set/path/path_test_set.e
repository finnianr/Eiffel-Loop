note
	description: "Test classes conforming to ${EL_PATH}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 20:44:05 GMT (Sunday 4th May 2025)"
	revision: "41"

class	PATH_TEST_SET inherit EL_EQA_TEST_SET

	BASE_TEST_SET

	PLATFORM
		export
			{NONE} all
		undefine
			default_create
		end

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_TUPLE

	EL_CHARACTER_8_CONSTANTS

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["comparisons",				 agent test_comparisons],
				["drive_letter",				 agent test_drive_letter],
				["extension",					 agent test_extension],
				["first_step",					 agent test_first_step],
				["initialization",			 agent test_initialization],
				["ise_path_access",			 agent test_ise_path_access],
				["joined_steps",				 agent test_joined_steps],
				["ntfs_translation",			 agent test_ntfs_translation],
				["parent",						 agent test_parent],
				["parent_of",					 agent test_parent_of],
				["path_expansion",			 agent test_path_expansion],
				["path_sort",					 agent test_path_sort],
				["path_steps",					 agent test_path_steps],
				["plus_path",					 agent test_plus_path],
				["set_parent",					 agent test_set_parent],
				["universal_relative_path", agent test_universal_relative_path],
				["version_number",			 agent test_version_number]
			>>)
		end

feature -- Tests

	test_comparisons
		-- PATH_TEST_SET.test_comparisons
		note
			testing: "[
				covers/{EL_PATH}.base_matches, covers/{EL_PATH}.same_extension,
				covers/{EL_PATH}.same_as
			]"
		local
			docs_pdf: FILE_PATH; z_docs_pdf: ZSTRING
		do
			docs_pdf := String.docs_pdf
			assert ("same string", docs_pdf.same_extension ("PDF", True))
			assert ("base matches", docs_pdf.base_matches ("Eiffel-spec", False))
			assert ("same path", docs_pdf.same_as (String.docs_pdf))
			z_docs_pdf := String.docs_pdf
			assert ("not same path", not docs_pdf.same_as (z_docs_pdf.translated ("f", "_")))
		end

	test_drive_letter
		-- PATH_TEST_SET.test_drive_letter
		local
			path: FILE_PATH; c_drive: STRING
		do
			path := String.boot_memtest
			assert_same_string (Void, path.to_unix, String.boot_memtest)
			c_drive := "C:"; path := c_drive
			assert_same_string (Void, path.to_string, c_drive)
		end

	test_extension
		note
			testing: "[
				covers/{EL_PATH}.with_new_extension, covers/{EL_PATH}.without_extension,
				covers/{EL_PATH}.has_dot_extension, covers/{EL_PATH}.replace_extension,
				covers/{EL_PATH}.remove_extension, covers/{EL_PATH}.add_extension
			]"
		local
			docs_pdf: FILE_PATH
		do
			docs_pdf := String.docs_pdf
			assert_same_string (Void, docs_pdf.with_new_extension ("doc").base, "Eiffel-spec.doc")
			assert_same_string (Void, docs_pdf.without_extension.base, "Eiffel-spec")
		end

	test_first_step
		note
			testing: "[
				covers/{EL_PATH}.first_step, covers/{EL_PATH}.is_absolute
			]"
		local
			dir_path: DIR_PATH
		do
			dir_path := String.home_eiffel
			assert_same_string ("is home", dir_path.first_step, "home")
			dir_path := String.docs_pdf
			assert_same_string ("is Documents", dir_path.first_step, "Documents")
		end

	test_initialization
		-- PATH_TEST_SET.test_initialization
		note
			testing: "[
				covers/{EL_PATH}.make_from_steps, covers/{EL_PATH}.make, covers/{EL_PATH}.to_string,
				covers/{EL_PATH}.joined_dir_steps, covers/{EL_PATH}.same_as
			]"
		local
			home_path, root_path, config_path, boot_memtest: DIR_PATH
		do
			root_path := "/"
			assert ("empty base", root_path.base.is_empty)
			assert ("count is 1", root_path.count = 1)

			home_path := "/home"
			config_path := home_path.joined_dir_steps (<< "joe", ".config" >>)
			assert ("same path", config_path.same_as (to_platform (String.home_user + "/.config")))

			boot_memtest := String.boot_memtest
			assert ("3 steps", boot_memtest.step_count = 3)
			if is_windows then
				assert ("absolute on Windows", boot_memtest.is_absolute)
			else
				assert ("not absolute on Unix", not boot_memtest.is_absolute)
			end
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
			p1 := String.home_eiffel
			assert_same_string ("reversible to string", p1.to_unix, String.home_eiffel)

			create p2.make_from_steps (String.home_eiffel.split ('/'))
			assert ("same path", p1 ~ p2)
		end

	test_ntfs_translation
		-- PATH_TEST_SET.test_ntfs_translation
		note
			testing: "[
				covers/{EL_PATH}.is_valid_ntfs,
				covers/{EL_PATH}.to_ntfs_compatible,
				covers/{EL_PATH}.set_parent
			]"
		local
			parent_string, path_name, ntfs_compatible: ZSTRING; path: FILE_PATH
			invalidate_base, invalidate_parent: BOOLEAN
		do
			across 1 |..| 4 as n loop
				path := String.boot_memtest -- C:/Boot/memtest.exe
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
					parent_string := path.parent_string (True)
					parent_string.insert_character ('?', 5)
					path.set_parent (parent_string)
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
			dir_path: DIR_PATH; root_name, c_root: STRING; file_path: FILE_PATH
		do
			assert ("2 parents", parent_count (String.home_user) = 2)
			assert ("1 parents", parent_count (String.docs_pdf) = 1)

			dir_path := "base/kernel/reflection"
			assert_same_string (Void, dir_path.parent.to_unix, "base/kernel")

			across << String.boot_memtest, String.home_user >> as list loop
				dir_path := list.item
				c_root := "C:"
				if is_windows then
					c_root.extend (OS.separator)
				end
				root_name := if list.cursor_index = 1 then c_root else OS.separator.out end
				assert_same_string ("same root name", dir_path.parent.parent.to_string, root_name)
				assert_same_string (Void, dir_path.parent.to_string + OS.separator.out, dir_path.parent_string (False))
			end

			file_path := String.docs_pdf
			file_path.set_parent (String.home_eiffel)
			assert_same_string (Void, file_path.to_unix, String.home_eiffel + char ('/') + file_path.base)
			assert_same_string (Void, eiffel_loop_dir.base, Dev_environ.Eiffel_loop)

			file_path := String.docs_pdf
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
			dir_string_home := String.home_user
			dir_home := dir_string_home
			across String.home_eiffel.split ('/') as step loop
				if step.cursor_index > 1 then
					dir_string.append_character ('/')
				end
				dir_string.append_string_general (step.item)
				dir := dir_string
				is_parent := dir_string.starts_with (dir_string_home) and dir_string.count > dir_string_home.count
				assert ("same result", is_parent ~ dir_home.is_parent_of (dir))
			end
		end

	test_path_expansion
		-- PATH_TEST_SET.test_path_expansion
		note
			testing: "covers/{EL_PATH}.expand"
		do
			assert ("variable expanded", not Eiffel_latin_1_sources.to_string.starts_with_general ("$EIFFEL_LOOP"))
			assert ("valid path", Eiffel_latin_1_sources.exists)
		end

	test_path_sort
		-- PATH_TEST_SET.test_path_sort
		note
			testing: "covers/{EL_PATH}.is_less"
		local
			path_list: EL_ZSTRING_LIST; sortable_2: EL_SORTABLE_ARRAYED_LIST [FILE_PATH]
		do
			create path_list.make_from_tuple (String)
			if attached {EL_ARRAYED_LIST [FILE_PATH]} path_list.derived_list (agent new_path) as sortable_1 then
				create sortable_2.make_from (sortable_1)
				sortable_2.ascending_sort
				sortable_1.order_by (agent {FILE_PATH}.to_string, True)
				assert ("same order", sortable_1.to_array ~ sortable_2.to_array)
			else
				failed ("derive file path list")
			end
		end

	test_path_steps
		-- PATH_TEST_SET.test_path_steps
		note
			testing: "covers/{EL_PATH_STEPS}.i_th_same_as"
		local
			dir_path: EL_PATH_STEPS
		do
			dir_path := String.home_eiffel
			assert ("joe is 3rd step", dir_path.index_of ("joe", 1) = 3)
			across dir_path.to_string.split (OS.separator) as step loop
				assert ("same step", dir_path.i_th_same_as (step.cursor_index, step.item))
			end
		end

	test_plus_path
		note
			testing: "[
				covers/{DIR_PATH}.plus_file_path,
				covers/{DIR_PATH}.plus_dir,
				covers/{DIR_PATH}.leading_backstep_count,
				covers/{DIR_PATH}.append_path
			]"
		local
			eif_dir_path, empty_dir, w_code_c1, home_user: DIR_PATH; docs_pdf_abs: FILE_PATH
		do
			create empty_dir; w_code_c1 := String.w_code_c1; home_user := String.home_user
			assert_same_string (Void, empty_dir.plus_dir (w_code_c1).as_unix, String.w_code_c1)
			assert_same_string (Void, empty_dir.plus_dir_path (w_code_c1).as_unix, String.w_code_c1)

			if attached char ('/').joined (String.home_user, String.w_code_c1) as joined_string then
				assert_same_string (Void, home_user.plus_dir (w_code_c1).as_unix, joined_string)
				assert_same_string (Void, home_user.plus_dir_path (w_code_c1).as_unix, joined_string)
			end

			eif_dir_path := String.home_eiffel
			docs_pdf_abs := eif_dir_path.plus_file_path (String.parent_dots + String.parent_dots + String.docs_pdf)

			assert_same_string (Void, docs_pdf_abs.as_unix, char ('/').joined (String.home_user, String.docs_pdf))
		end

	test_set_parent
		note
			testing: "covers/{DIR_PATH}.set_parent, covers/{DIR_PATH}.set_parent_path"
		local
			docs_pdf: FILE_PATH; dir_path, boot_memtest: DIR_PATH; boot_memtest_string: STRING
		do
			docs_pdf := String.docs_pdf
			docs_pdf.set_parent_path (String.home_eiffel)
			assert_same_string (Void, docs_pdf.to_unix, String.home_eiffel + "/Eiffel-spec.pdf")

			docs_pdf := String.docs_pdf
			dir_path := String.home_eiffel
			docs_pdf.set_parent (dir_path)
			assert_same_string (Void, docs_pdf.to_unix, String.home_eiffel + "/Eiffel-spec.pdf")

			across << True, False >> as set_parent loop
				boot_memtest := String.boot_memtest
				if set_parent.item then
					boot_memtest.set_parent (String.d_boot)
				else
					boot_memtest.set_parent_path (String.d_boot)
				end
				if is_windows then
					assert ("D: drive", boot_memtest.volume = 'D')
					assert ("is absolute", boot_memtest.is_absolute)
				else
					assert ("no volume", not boot_memtest.has_volume)
					assert ("not absolute", not boot_memtest.is_absolute)
				end
				boot_memtest_string := boot_memtest.to_unix
				boot_memtest_string [1] := 'C'
				assert_same_string (Void, boot_memtest_string, String.boot_memtest)
			end
		end

	test_universal_relative_path
		-- PATH_TEST_SET.test_universal_relative_path
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
		-- PATH_TEST_SET.test_version_number
		note
			testing:
				"[
					covers/{EL_PATH}.version_number, covers/{EL_PATH}.has_version_number,
					covers/{EL_PATH}.version_interval
				]"
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
						path.set_version_number (103)
						assert_same_string (Void, path.to_string, "myfile.103.mp3")
					when 3 then
						assert ("no version", path.version_number = -1)
				end
			end
		end

feature {NONE} -- Implementation

	new_path (str: ZSTRING): FILE_PATH
		do
			Result := str
		end

	parent_count (a_path: DIR_PATH): INTEGER
		local
			path: EL_PATH
		do
			from path := a_path until not path.has_parent loop
				path := path.parent
				Result := Result + 1
			end
		end

	to_platform (str: STRING): STRING
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if is_windows then
				Result := str.twin
				sg.super_8 (str).replace_character ('/', '\')
			else
				Result := str
			end
		end

feature {NONE} -- Constants

	Eiffel_latin_1_sources: DIR_PATH
		once
			create Result.make_expanded ("$EIFFEL_LOOP/tool/eiffel/test-data/sources/latin-1")
		ensure
			valid_expansion: Result.exists
		end

	String: TUPLE [d_boot, c_root, home_user, home_eiffel, docs_pdf, boot_memtest, w_code_c1, parent_dots: STRING]
		once
			create Result
		-- order is for `test_path_sort'
			Tuple.line_fill (Result, "[
				D:/Boot
				C:/
				/home/joe
				/home/joe/dev/Eiffel
				Documents/Eiffel-spec.pdf
				C:/Boot/memtest.exe
				W_code/C1
				../
			]")
		end

end