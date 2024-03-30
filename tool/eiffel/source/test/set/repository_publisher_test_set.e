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
	date: "2024-03-29 10:13:04 GMT (Friday 29th March 2024)"
	revision: "73"

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
				assert ("same list digest", crc.checksum = 2717188820)
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
				base_name_list := "Eco-DB.html, base.kernel.html, index.html, public-key-encryption.html"
				base_name_list.extend (broadcaster_path.base_name + ".html")
				base_name_list.append (sorted_base_names (cmd.path_list))
				base_name_list.ascending_sort

				if Executable.Is_work_bench then
					line := User_input.line ("Enter to continue")
				end
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
			dir_path: DIR_PATH; file_path: FILE_PATH; extension: STRING
		do
			Precursor
			OS.copy_tree (el_source_dir (Work_dir.doc_config), Work_dir.doc_config.parent)
			OS.copy_file ("test-data/publish/config-1.pyx", Work_dir.doc_config)
			if attached new_csv_list ("dummy, images, css, js") as www_name_list then
				across << Work_dir.doc, Work_dir.ftp_doc >> as destination_dir loop
					across www_name_list as list loop
						dir_path := Dev_environ.Eiffel_loop_dir.joined_dir_steps (<< "doc", list.item >>)
						OS.copy_tree (dir_path, destination_dir.item)
					end
				end
			end
			if attached new_csv_list (
					"base/kernel/event, base/kernel/initialization, base/kernel/reflection, base/math,%
					%base/persistency, persistency/database/eco-db, text/rsa-encryption"
				) as library_list
			then
				across library_list as list loop
					File_system.make_directory (Work_dir.library #+ list.item)
				end
				across library_list as list loop
					dir_path := Work_dir.library #+ list.item
					OS.copy_tree (el_source_dir (dir_path), dir_path.parent)
				end
			end
			if attached new_csv_list ("base/base.ecf, Eco-DB.ecf, public-key-encryption.ecf") as library_list then
				across library_list as list loop
					file_path := Work_dir.library + list.item
					OS.copy_file (el_source_path (file_path), file_path.parent)
				end
				across << Work_dir.library, Work_dir.library #+ "base", Work_dir.library #+ "doc" >> as dir loop
					File_system.make_directory (dir.item)
					inspect dir.cursor_index
						when 1 , 2 then
							extension := "pecf"
					else
						extension := "txt"
					end
					across Shared_directory.named (el_source_dir (dir.item)).files_with_extension (extension) as path loop
						OS.copy_file (path.item, dir.item)
					end
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
					html_file_path := Work_dir.doc + path.item.relative_path (publisher.root_dir).with_new_extension ("html")
					assert ("html exists", html_file_path.exists)
				end
			end
		end

	check_markdown_link_translation (publisher: like new_publisher)
		-- check Contents.md generated correctly
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
								assert_same_string (Void, url, (github_url + table.item))
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

	el_source_dir (work_area_sub_dir: DIR_PATH): DIR_PATH
		do
			REsult := Dev_environ.Eiffel_loop_dir #+ work_area_sub_dir.relative_path (Work_area_dir)
		end

	el_source_path (work_area_file_path: FILE_PATH): FILE_PATH
		do
			REsult := Dev_environ.Eiffel_loop_dir + work_area_file_path.relative_path (Work_area_dir)
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
			across OS.file_list (Work_dir.doc, "*.html") as html loop
				modification_time := Date_time.modification_time (html.item)
				crc.add_integer (modification_time.date.ordered_compact_date)
				crc.add_integer (modification_time.time.compact_time)
			end
			Result := crc.checksum
		end

	generated_files: like OS.file_list
		do
			Result := OS.file_list (Work_dir.doc, "*.html")
		end

	html_path (a_path: FILE_PATH): FILE_PATH
		do
			Result := Kernel_event.html_dir + a_path.base_name
			Result.add_extension ("html")
		end

	new_csv_list (str: STRING): EL_STRING_8_LIST
		do
			Result := str
		end

	new_link_checker: REPOSITORY_NOTE_LINK_CHECKER
		do
			create Result.make (Work_dir.doc_config + "config-1.pyx", "1.4.0", 0)
		end

	new_publisher: REPOSITORY_TEST_PUBLISHER
		do
			create Result.make (Work_dir.doc_config + "config-1.pyx", "1.4.0", 0)
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

	Work_dir: TUPLE [doc, doc_config, ftp_doc, library: DIR_PATH]
		once
			create Result
			across new_csv_list ("doc, doc-config, ftp.doc, library") as list loop
				Result.put_reference (Work_area_dir #+ list.item, list.cursor_index)
			end
		end

	Kernel_event: TUPLE [class_dir, html_dir: DIR_PATH]
		local
			l_dir: DIR_PATH
		once
			l_dir := "library/base/kernel/event"
			Result := [Work_area_dir #+ l_dir, Work_dir.doc #+ l_dir]
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