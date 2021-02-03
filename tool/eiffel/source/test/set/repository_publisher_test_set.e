note
	description: "Repository publisher test set. See class [$source REPOSITORY_TEST_PUBLISHER]"
	notes: "[
		FILE: config-1.pyx

			ecf-list:
				# Library Base
				ecf:
					"library/base/base.ecf#utility"
					"library/base/base.ecf#math"
					"library/base/base.ecf#persistency"

				# Library (Text)
				ecf:
					"library/i18n.ecf"
				# Library Graphics
				ecf:
					"library/html-viewer.ecf"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-02 12:39:38 GMT (Tuesday 2nd February 2021)"
	revision: "28"

class
	REPOSITORY_PUBLISHER_TEST_SET

inherit
	EL_GENERATED_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		redefine
			on_prepare, on_clean
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_EXECUTABLE

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("publisher", agent test_publisher)
		end

feature -- Tests

	test_publisher
		local
			publisher: like new_publisher; editor: FIND_AND_REPLACE_EDITOR
			line: ZSTRING; base_name_list: EL_ZSTRING_LIST
		do
			publisher := new_publisher
			publisher.execute
			check_html_exists (publisher)

			create editor.make ("make_shell", "make_command_shell")
			editor.set_file_path (Modified_file_path)
			editor.edit

			base_name_list := "base.utility.html, index.html"
			base_name_list.extend (Modified_file_path.base_sans_extension + ".html")
			base_name_list.append (sorted_base_names (Shared_directory.named (Crc_32_dir).files))
			base_name_list.sort

			Shared_directory.named (Crc_32_dir).delete_content

			if Executable.Is_work_bench then
				line := User_input.line ("Enter to continue")
			end
			publisher := new_publisher
			publisher.execute

			assert ("same list", base_name_list ~ sorted_base_names (publisher.ftp_sync.ftp.uploaded_list))
		end

feature {NONE} -- Events

	on_prepare
		local
			lib_dir: EL_DIR_PATH; list: EL_STRING_8_LIST
		do
			Precursor
			OS.copy_tree (Eiffel_loop_dir.joined_dir_path ("doc-config"), Work_area_dir)
			OS.copy_file ("test-data/publish/config-1.pyx", Doc_config_dir)
			list := "dummy, images, css, js"
			across list as name loop
				OS.copy_tree (Eiffel_loop_dir.joined_dir_steps (<< "doc", name.item >>), Doc_dir)
			end
			list := "library, library/base, library/text, library/graphic, library/graphic/toolkit"
			across list as dir loop
				OS.File_system.make_directory (Work_area_dir.joined_dir_path (dir.item))
			end
			list := "library/base/utility, library/base/math, library/base/persistency, library/text/i18n%
								%, library/graphic/toolkit/html-viewer"
			across list as dir loop
				lib_dir := dir.item
				OS.copy_tree (Eiffel_loop_dir.joined_dir_path (lib_dir), Work_area_dir.joined_dir_path (lib_dir.parent))
			end
			list := "library/base/base.ecf, library/i18n.ecf, library/html-viewer.ecf"
			across list as path loop
				OS.copy_file (Eiffel_loop_dir + path.item, (Work_area_dir + path.item).parent)
			end
			Execution_environment.put ("workarea", Var_EIFFEL_LOOP)
			Execution_environment.put ("workarea/doc", "EIFFEL_LOOP_DOC")
		end

	on_clean
		do
			Precursor
			Execution_environment.put (new_eiffel_loop_dir, Var_EIFFEL_LOOP)
			Execution_environment.put ("", "EIFFEL_LOOP_DOC")
		end

feature {NONE} -- Implementation

	check_html_exists (publisher: like new_publisher)
		local
			html_file_path: EL_FILE_PATH
		do
			across publisher.ecf_list as tree loop
				across tree.item.path_list as path loop
					html_file_path := Doc_dir + path.item.relative_path (publisher.root_dir).with_new_extension ("html")
					assert ("html exists", html_file_path.exists)
				end
			end
		end

	file_content_checksum: NATURAL
		local
			crc: like crc_generator
		do
			crc := crc_generator
			across generated_files as html loop
				crc.add_file (html.item)
			end
			Result := crc.checksum
		end

	file_modification_checksum: NATURAL
		local
			crc: like crc_generator
			modification_time: DATE_TIME
		do
			crc := crc_generator
			across OS.file_list (Doc_dir, "*.html") as html loop
				modification_time := html.item.modification_date_time
				crc.add_integer (modification_time.date.ordered_compact_date)
				crc.add_integer (modification_time.time.compact_time)
			end
			Result := crc.checksum
		end

	generated_files: like OS.file_list
		do
			Result := OS.file_list (Doc_dir, "*.html")
		end

	new_publisher: REPOSITORY_TEST_PUBLISHER
		do
			create Result.make (Doc_config_dir + "config-1.pyx", "1.4.0", 0)
		end

	sorted_base_names (list: LIST [EL_FILE_PATH]): EL_ZSTRING_LIST
		-- sorted list of base names
		do
			create Result.make (list.count)
			across list as path loop
				Result.extend (path.item.base)
			end
			Result.sort
		end

feature {NONE} -- Constants

	Crc_32_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc/library/base/utility/crc-32")
		end

	Doc_config_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc-config")
		end

	Doc_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc")
		end

	Modified_file_path: EL_FILE_PATH
		once
			Result := Work_area_dir + "library/base/utility/benchmark/el_benchmark_command_shell.e"
		end

end