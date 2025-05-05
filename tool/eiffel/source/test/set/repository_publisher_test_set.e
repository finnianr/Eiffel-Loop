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
	date: "2025-05-05 9:24:40 GMT (Monday 5th May 2025)"
	revision: "93"

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

	EL_MODULE_OS; EL_MODULE_STRING_8; EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

	EL_SHARED_DIRECTORY
		rename
			Directory as Shared_directory
		end

	PUBLISHER_CONSTANTS
		rename
			Html as Html_name
		end

	SHARED_CLASS_TABLE; SHARED_ISE_CLASS_TABLE; SHARED_INVALID_CLASSNAMES; SHARED_EIFFEL_LOOP


create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["link_checker", agent test_link_checker],
				["publisher",	  agent test_publisher]
			>>)
		end

feature -- Tests

	test_link_checker
		-- REPOSITORY_PUBLISHER_TEST_SET.test_link_checker
		local
			found: BOOLEAN; note_descendants: EL_STRING_8_LIST
			link_checker: like new_link_checker
		do
			link_checker := new_link_checker
			link_checker.execute

			if attached Invalid_source_name_table as table then
			-- Some example classes that appear in descendant note on EL_SOLITARY but are not included in test
				note_descendants := "AIA_CREDENTIAL_LIST, RBOX_TEST_DATABASE, RBOX_DATABASE"

				from table.start until found or else table.after loop
					if table.key_for_iteration.same_base ("el_solitary.e") then
						if across note_descendants as list all table.item_for_iteration.has (list.item) end then
							found := True
						else
							failed ("descendant not in test libraries")
						end
					end
					table.forth
				end
			end
			assert ("el_solitary.e found", found)

			lio.put_new_line
			lio.put_line ("Invalid names list")
			if attached open_lines (link_checker.config.invalid_names_output_path, Latin_1) as line_list
				and then attached crc_generator as crc
			then
				across line_list as list loop
					if attached list.shared_item as line
					 	and then (line.starts_with_general ("class") or line.has_substring ("Source"))
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
				assert_same_checksum ("Invalid names list", crc, 1874985684)
			end
		end

	test_publisher
		-- REPOSITORY_PUBLISHER_TEST_SET.test_publisher
		note
			testing: "[
				covers/{EL_TUPLE_ROUTINES}.fill_with_new,
				covers/{REPOSITORY_PUBLISHER}.execute
			]"
		local
			publisher: like new_publisher; editor: FIND_AND_REPLACE_EDITOR; base_name_list: EL_ZSTRING_LIST
			broadcaster_path, checker_path, relative_path, crc_path, el_event_processor_path: FILE_PATH
		do
			publisher := new_publisher
			publisher.execute
			check_html_exists (publisher)
			check_markdown_link_translation (publisher)

--			Reset globals
			Class_link_list.copy (create {CLASS_LINK_LIST}.make (20))
			Invalid_source_name_table.wipe_out
			Ise_class_table.wipe_out; Class_table.wipe_out

			publisher := new_publisher
			publisher.execute
			assert ("no changes", not publisher.has_changes)

			broadcaster_path := Kernel_event.class_dir + "el_event_broadcaster.e"
			checker_path := Kernel_event.class_dir + "el_event_checker.e"

			create editor.make ("make", "make_default") -- feature {NONE} -- Initialization
			editor.set_source_path (broadcaster_path)
			editor.edit

			File_system.remove_file (checker_path)

		-- Remove some CRC files to force regeneration
			if attached OS.find_files_command (Kernel_event.html_dir, "*listener.html") as cmd
				and then attached publisher.config as config
			then
				cmd.execute
				across cmd.path_list as path loop
					relative_path := path.item.relative_path (config.output_dir)
					crc_path := new_crc_sync_dir (config.output_dir, config.ftp_host) + relative_path
					crc_path.replace_extension (Crc_extension)
					File_system.remove_file (crc_path)
				end
				el_event_processor_path := kernel_event_html_path ("el_event_processor.html")
				File_system.remove_file (el_event_processor_path)

				if attached String_8.new_list ("base.kernel, index, " + broadcaster_path.base_name) as base_list then
					create base_name_list.make (base_list.count)
					across base_list as list loop
						base_name_list.extend (list.item + ".html")
					end
				end
				base_name_list.append (sorted_base_names (cmd.path_list))
				base_name_list.ascending_sort

				if Executable.Is_work_bench and then attached User_input.line ("Enter to continue")then
					lio.put_new_line
				end
				publisher.execute

				across cmd.path_list as path loop
					assert ("removed regenerated", path.item.exists)
				end
			end
			assert ("el_event_processor regenerated", el_event_processor_path.exists)
			assert ("checker html gone", not kernel_event_html_path (checker_path).exists)
			if base_name_list /~ sorted_base_names (publisher.copied_path_list) then
				lio.put_labeled_lines ("base_name_list", base_name_list)
				lio.put_new_line
				lio.put_labeled_lines (
					"sorted_base_names (publisher.uploaded_path_list)", sorted_base_names (publisher.copied_path_list)
				)
				lio.put_new_line
				failed ("same base name list")
			end
			publisher.execute
			assert ("no changes", not publisher.has_changes)
		end

feature {NONE} -- Events

	on_prepare
		local
			dir_path: DIR_PATH; extension: STRING
		do
			Precursor
			OS.copy_tree (el_source_dir (Work_dir.doc_config), Work_dir.doc_config.parent)
			OS.copy_file ("test-data/publish/config-1.pyx", Work_dir.doc_config)
			if attached String_8.new_list ("dummy, images, css, js") as www_name_list then
				across << Work_dir.doc, Work_dir.ftp_doc >> as destination_dir loop
					across www_name_list as list loop
						dir_path := eiffel_loop_dir.joined_dir_steps (<< "doc", list.item >>)
						OS.copy_tree (dir_path, destination_dir.item)
					end
				end
			end
			copy_source_trees (Work_dir.example, "Eco-DB/source")
			copy_ecf_files (Work_dir.example, "Eco-DB/database.ecf")

			copy_source_trees (Work_dir.library,
				"base/kernel/event, base/kernel/initialization, base/kernel/reflection, base/math,%
				%base/persistency, persistency/database/eco-db, text/rsa-encryption"
			)
			copy_ecf_files (Work_dir.library, "base/base.ecf, Eco-DB.ecf, public-key-encryption.ecf")

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

feature {NONE} -- Implementation

	check_html_exists (publisher: like new_publisher)
		local
			html_file_path: FILE_PATH; root_dir: DIR_PATH
		do
			root_dir := publisher.config.root_dir
			across publisher.ecf_list as tree loop
				across tree.item.path_list as path loop
					html_file_path := Work_dir.doc + path.item.relative_path (root_dir).with_new_extension ("html")
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
			github_url := publisher.config.github_url.to_string

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

	copy_ecf_files (workarea_sub_dir: DIR_PATH; directory_list: STRING)
		do
			if attached String_8.new_list (directory_list) as library_list then
				across library_list as list loop
					if attached (workarea_sub_dir + list.item) as file_path then
						OS.copy_file (el_source_path (file_path), file_path.parent)
					end
				end
			end
		end

	copy_source_trees (workarea_sub_dir: DIR_PATH; directory_list: STRING)
		do
			if attached String_8.new_list (directory_list) as source_list then
				across source_list as list loop
					File_system.make_directory (workarea_sub_dir #+ list.item)
				end
				across source_list as list loop
					if attached (workarea_sub_dir #+ list.item) as dir_path then
						OS.copy_tree (el_source_dir (dir_path), dir_path.parent)
					end
				end
			end
		end

	el_source_dir (work_area_sub_dir: DIR_PATH): DIR_PATH
		do
			REsult := eiffel_loop_dir #+ work_area_sub_dir.relative_path (Work_area_dir)
		end

	el_source_path (work_area_file_path: FILE_PATH): FILE_PATH
		do
			REsult := eiffel_loop_dir + work_area_file_path.relative_path (Work_area_dir)
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

	kernel_event_html_path (a_path: FILE_PATH): FILE_PATH
		do
			Result := Kernel_event.html_dir + a_path.base_name
			Result.add_extension ("html")
		end

	new_link_checker: REPOSITORY_NOTE_LINK_CHECKER
		do
			create Result.make (Work_dir.doc_config + "config-1.pyx", "1.4.0", 0)
		end

	new_publisher: REPOSITORY_PUBLISHER
		do
			create Result.make (Work_dir.doc_config + "config-1.pyx", "1.4.0", 0)
		end

	new_work_area_sub_directory (name: STRING): DIR_PATH
		do
			Result := Work_area_dir #+ name
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
			create Result.make_assignments (<<
				["X509 PKCS1 standard",	"https://en.wikipedia.org/wiki/X.509#Sample_X.509_certificates"],
				["text-formats.ecf",		"/library/text-formats.pecf"],
				["reflection cluster",	"/library/base/base.pecf"],
				["EL_MODULE_X509",		"/library/text/rsa-encryption/x509/el_module_x509.e"]
			>>)
		end

	Work_dir: TUPLE [doc, doc_config, example, ftp_doc, library: DIR_PATH]
		once
			create Result
			Tuple.fill_with_new (Result,
				"doc, doc-config, example, ftp.doc, library", agent new_work_area_sub_directory, 1
			)
		end

end