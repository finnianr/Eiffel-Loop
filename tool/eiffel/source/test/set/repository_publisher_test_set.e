note
	description: "Repository publisher test set. See class ${REPOSITORY_TEST_PUBLISHER}"
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
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-23 11:28:14 GMT (Tuesday 23rd January 2024)"
	revision: "67"

class
	REPOSITORY_PUBLISHER_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_FILE_OPEN_ROUTINES

	EL_FILE_SYNC_ROUTINES undefine default_create end

	EL_MODULE_DATE_TIME; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_EXECUTABLE

	EL_MODULE_OS; EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	SHARED_INVALID_CLASSNAMES; SHARED_DEV_ENVIRON

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["publisher", agent test_publisher],
				["link_checker", agent test_link_checker]
			>>)
		end

feature -- Tests

	test_link_checker
		-- REPOSITORY_PUBLISHER_TEST_SET.test_link_checker
		local
			link_checker: like new_link_checker
			found: BOOLEAN; rbox_classes: EL_STRING_8_LIST
		do
			link_checker := new_link_checker
			link_checker.execute

			if attached Invalid_source_name_table as table then
				create rbox_classes.make_from_array (<< "RBOX_TEST_DATABASE", "RBOX_DATABASE" >>)

				from table.start until found or else table.after loop
					if table.key_for_iteration.base.same_string_general ("el_solitary.e")  then
						assert ("key is RBOX_DATABASE class", table.item_for_iteration.for_all (agent rbox_classes.has))
						found := true
					end
					table.forth
				end
			end
			assert ("el_solitary.e found", found)

			lio.put_new_line
			lio.put_line ("Invalid names list")
			if attached open_lines (link_checker.invalid_names_output_path, Latin_1) as line_list
				and then attached crc_generator as crc
			then
				across line_list as list loop
					if attached list.item as line
					 	and then (line.starts_with ("class") or line.has_substring ("Source"))
					 	and then attached line.split_list (' ') as parts
					 then
						crc.add_string (line)
						if parts.first.same_string ("--") then
							lio.put_string (line)
						else
							lio.put_labeled_string (parts.first, parts.last)
						end
						lio.put_new_line
					end
				end
				assert ("same list digest", crc.checksum = 1278806107)
			end
		end

	test_publisher
		-- REPOSITORY_PUBLISHER_TEST_SET.test_publisher
		local
			publisher: like new_publisher; editor: FIND_AND_REPLACE_EDITOR
			line: ZSTRING; base_name_list: EL_ZSTRING_LIST
			broadcaster_path, checker_path, relative_path, crc_path: FILE_PATH
		do
			publisher := new_publisher
			publisher.execute
			check_html_exists (publisher)
			check_markdown_link_translation (publisher)

			broadcaster_path := Kernel_event.class_dir + "el_event_broadcaster.e"
			checker_path := Kernel_event.class_dir + "el_event_checker.e"

			create editor.make ("make", "make_default") -- feature {NONE} -- Initialization
			editor.set_source_path (broadcaster_path)
			editor.edit

			File_system.remove_file (checker_path)

			-- Remove some CRC files to force regeneration
			if attached OS.find_files_command (Kernel_event.html_dir, "*listener.html") as cmd then
				cmd.execute
				across cmd.path_list as path loop
					relative_path := path.item.relative_path (publisher.output_dir)
					crc_path := new_crc_sync_dir (publisher.output_dir, publisher.ftp_host) + relative_path
					crc_path.replace_extension (Crc_extension)
					File_system.remove_file (crc_path)
				end
				base_name_list := "base.kernel.html, index.html"
				base_name_list.extend (broadcaster_path.base_name + ".html")
				base_name_list.append (sorted_base_names (cmd.path_list))
				base_name_list.ascending_sort

				if Executable.Is_work_bench then
					line := User_input.line ("Enter to continue")
				end
--				publisher := new_publisher
				publisher.execute

				across cmd.path_list as path loop
					assert ("removed regenerated", path.item.exists)
				end
			end
			assert ("checker html gone", not html_path (checker_path).exists)
			assert ("same list", base_name_list ~ sorted_base_names (publisher.uploaded_path_list))
		end

feature {NONE} -- Events

	on_prepare
		local
			lib_dir, library_doc_dir: DIR_PATH; list: EL_STRING_8_LIST; steps: EL_PATH_STEPS
		do
			Precursor
			OS.copy_tree (Dev_environ.Eiffel_loop_dir #+ "doc-config", Work_area_dir)
			OS.copy_file ("test-data/publish/config-1.pyx", Doc_config_dir)
			list := "dummy, images, css, js"
			across << Doc_dir, Ftp_dir >> as destination_dir loop
				across list as name loop
					OS.copy_tree (Dev_environ.Eiffel_loop_dir.joined_dir_steps (<< "doc", name.item >>), destination_dir.item)
				end
			end
			list := "library/base/kernel/event, library/base/kernel/initialization, library/base/kernel/reflection,%
						%library/base/math, library/base/persistency, library/persistency/database/eco-db,%
						%library/text/rsa-encryption"

			across list as dir loop
				from steps := dir.item.twin until steps.is_empty loop
					lib_dir := Work_area_dir #+ steps
					File_system.make_directory (lib_dir)
					steps.remove_tail (1)
				end
			end
			across list as dir loop
				lib_dir := dir.item
				OS.copy_tree (Dev_environ.Eiffel_loop_dir #+ lib_dir, Work_area_dir #+ lib_dir.parent)
			end
			list := "library/base/base.ecf, library/Eco-DB.ecf, library/public-key-encryption.ecf"
			if attached Dev_environ.Eiffel_loop_dir as el_dir then
				across list as path loop
					OS.copy_file (el_dir + path.item, (Work_area_dir + path.item).parent)
				end
				library_doc_dir := Work_area_dir #+ "library/doc"
				File_system.make_directory (library_doc_dir)
				across Shared_directory.named (el_dir #+ "library").files_with_extension ("txt") as path loop
					OS.copy_file (path.item, library_doc_dir)
				end
			end
		end

feature {NONE} -- Implementation

	check_html_exists (publisher: like new_publisher)
		local
			html_file_path: FILE_PATH
		do
			across publisher.ecf_list as tree loop
				across tree.item.path_list as path loop
					html_file_path := Doc_dir + path.item.relative_path (publisher.root_dir).with_new_extension ("html")
					assert ("html exists", html_file_path.exists)
				end
			end
		end

	check_markdown_link_translation (publisher: like new_publisher)
		local
			contents_md_path: FILE_PATH; md_name, url, github_url: STRING
			link_index, index_left_bracket, index_right_bracket: INTEGER

		do
			github_url := publisher.github_url.to_string

			contents_md_path := Work_area_dir + "doc/Contents.md"
			if contents_md_path.exists and then attached File.plain_text (contents_md_path) as markdown then
				across Markdown_link_table as table loop
					md_name := "[]"; md_name.insert_string (table.key, 2)
					link_index := markdown.substring_index (md_name, 1)
					if link_index > 0 then
						index_left_bracket := link_index + md_name.count
						assert ("( at index", markdown [index_left_bracket] = '(')
						index_right_bracket := markdown.index_of (')', index_left_bracket)
						if index_right_bracket > 0 then
							url := markdown.substring (index_left_bracket + 1, index_right_bracket - 1)
							if table.is_first then
								assert_same_string (Void, url, table.item)
							else
								assert_same_string (Void, url, github_url + table.item)
							end
						else
							failed ("found matching )")
						end
					else
						failed ("Found link " + table.key)
					end
				end
			else
				failed ("Contents.md found")
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
				modification_time := Date_time.modification_time (html.item)
				crc.add_integer (modification_time.date.ordered_compact_date)
				crc.add_integer (modification_time.time.compact_time)
			end
			Result := crc.checksum
		end

	generated_files: like OS.file_list
		do
			Result := OS.file_list (Doc_dir, "*.html")
		end

	html_path (a_path: FILE_PATH): FILE_PATH
		do
			Result := Kernel_event.html_dir + a_path.base_name
			Result.add_extension ("html")
		end

	new_link_checker: REPOSITORY_NOTE_LINK_CHECKER
		do
			create Result.make (Doc_config_dir + "config-1.pyx", "1.4.0", 0)
		end

	new_publisher: REPOSITORY_TEST_PUBLISHER
		do
			create Result.make (Doc_config_dir + "config-1.pyx", "1.4.0", 0)
		end

	sorted_base_names (list: LIST [FILE_PATH]): EL_ZSTRING_LIST
		-- sorted list of base names
		do
			create Result.make (list.count)
			across list as path loop
				Result.extend (path.item.base)
			end
			Result.ascending_sort
		end

feature {NONE} -- Constants

	Doc_config_dir: DIR_PATH
		once
			Result := Work_area_dir #+ "doc-config"
		end

	Doc_dir: DIR_PATH
		once
			Result := Work_area_dir #+ "doc"
		end

	Ftp_dir: DIR_PATH
		once
			Result := Work_area_dir #+ "ftp.doc"
		end

	Kernel_event: TUPLE [class_dir, html_dir: DIR_PATH]
		local
			l_dir: DIR_PATH
		once
			l_dir := "library/base/kernel/event"
			Result := [Work_area_dir #+ l_dir, Work_area_dir #+ "doc" #+ l_dir]
		end

	Markdown_link_table: EL_HASH_TABLE [STRING, STRING]
		-- expect links in doc/Contents.md
		once
			create Result.make (<<
				["X509 PKCS1 standard", "https://en.wikipedia.org/wiki/X.509#Sample_X.509_certificates"],
				["text-formats.ecf", "/library/text-formats.pecf"],
				["reflection cluster", "/library/base/base.pecf"],
				["EL_MODULE_X509", "/library/text/rsa-encryption/x509/el_module_x509.e"]
			>>)
		end


end