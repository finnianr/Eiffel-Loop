note
	description: "Repository publisher test set. See class [$source REPOSITORY_TEST_PUBLISHER]"
	notes: "[
		FILE: config-1.pyx

			ecf-list:
				# Library Base
				ecf:
					"library/base/base.ecf#kernel"
					"library/base/base.ecf#math"
					"library/base/base.ecf#persistency"
				# Library (Persistence)
				ecf:
					"library/Eco-DB.ecf"
				# Library Text
				ecf:
					"library/public-key-encryption.ecf"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-20 17:06:26 GMT (Saturday 20th March 2021)"
	revision: "32"

class
	REPOSITORY_PUBLISHER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare, on_clean
		end

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_COMMAND

	EL_MODULE_USER_INPUT

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_EXECUTABLE

	EL_MODULE_TUPLE

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

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
			line: ZSTRING; base_name_list: EL_ZSTRING_LIST; finder: EL_FIND_FILES_COMMAND_I
			broadcaster_path, checker_path: EL_FILE_PATH
		do
			publisher := new_publisher
			publisher.execute
			check_html_exists (publisher)

			broadcaster_path := Kernel_event.class_dir + "el_event_broadcaster.e"
			checker_path := Kernel_event.class_dir + "el_event_checker.e"

			create editor.make ("make", "make_default") -- feature {NONE} -- Initialization
			editor.set_file_path (broadcaster_path)
			editor.edit

			File_system.remove_file (checker_path)

			finder := Command.new_find_files (Kernel_event.html_dir, "*listener.html")
			finder.execute
			across finder.path_list as path loop
				File_system.remove_file (path.item)
			end

			base_name_list := "base.kernel.html, index.html"
			base_name_list.extend (broadcaster_path.base_sans_extension + ".html")
			base_name_list.append (sorted_base_names (finder.path_list))
			base_name_list.sort

			if Executable.Is_work_bench then
				line := User_input.line ("Enter to continue")
			end
			publisher := new_publisher
			publisher.execute

			across finder.path_list as path loop
				assert ("removed regenerated", path.item.exists)
			end
			assert ("checker html gone", not html_path (checker_path).exists)

			assert ("same list", base_name_list ~ sorted_base_names (publisher.ftp_sync.ftp.uploaded_list))
		end

feature {NONE} -- Events

	on_prepare
		local
			lib_dir: EL_DIR_PATH; list: EL_STRING_8_LIST
			steps: EL_PATH_STEPS
		do
			Precursor
			OS.copy_tree (Eiffel_loop_dir.joined_dir_path ("doc-config"), Work_area_dir)
			OS.copy_file ("test-data/publish/config-1.pyx", Doc_config_dir)
			list := "dummy, images, css, js"
			across list as name loop
				OS.copy_tree (Eiffel_loop_dir.joined_dir_steps (<< "doc", name.item >>), Doc_dir)
			end
			list := "library/base/kernel, library/base/math, library/base/persistency, library/persistency/database/eco-db%
								%, library/text/rsa-encryption"
			across list as dir loop
				from steps := dir.item until steps.count = 0 loop
					lib_dir := Work_area_dir.joined_dir_path (steps.as_directory_path)
					OS.File_system.make_directory (lib_dir)
					steps.remove_tail (1)
				end
			end
			across list as dir loop
				lib_dir := dir.item
				OS.copy_tree (Eiffel_loop_dir.joined_dir_path (lib_dir), Work_area_dir.joined_dir_path (lib_dir.parent))
			end
			list := "library/base/base.ecf, library/Eco-DB.ecf, library/public-key-encryption.ecf"
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

	html_path (a_path: EL_FILE_PATH): EL_FILE_PATH
		do
			Result := Kernel_event.html_dir + a_path.base_sans_extension
			Result.add_extension ("html")
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

	Kernel_event: TUPLE [class_dir, html_dir: EL_DIR_PATH]
		local
			l_dir: EL_DIR_PATH
		once
			l_dir := "library/base/kernel/event"
			Result := [Work_area_dir.joined_dir_path (l_dir), Work_area_dir.joined_dir_path ("doc").joined_dir_path (l_dir)]
		end

	Doc_config_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc-config")
		end

	Doc_dir: EL_DIR_PATH
		once
			Result := Work_area_dir.joined_dir_path ("doc")
		end

end