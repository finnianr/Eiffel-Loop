note
	description: "[
		Test classes

			[$source EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER]
			[$source EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER]
			[$source THUNDERBIRD_WWW_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 17:06:48 GMT (Monday 10th January 2022)"
	revision: "1"

class
	THUNDERBIRD_ACCOUNT_READER_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_DIGESTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("book_exporter", agent test_book_exporter)
			eval.call ("xhtml_exporter", agent test_xhtml_exporter)
			eval.call ("www_exporter", agent test_www_exporter)
		end

feature -- Tests

	test_book_exporter
		local
			command: EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER; folder_names: EL_ZSTRING_LIST
			config_path, package_path, item_path: FILE_PATH; package_root, chapter_root: EL_XPATH_ROOT_NODE_CONTEXT
			chapter_count: INTEGER
		do
			folder_names := "manual"
			config_path := work_area_data_dir + "config.pyx"
			write_config (config_path, new_config_text("pop.myching.co", "en", folder_names))
			create command.make_from_file (config_path)
			command.execute

			package_path := work_area_data_dir + "export/manual/book-package.opf"
			assert ("book-package.opf exists", package_path.exists)
			create package_root.make_from_file (package_path)
			across package_root.context_list ("/package/manifest/item") as manifest loop
				item_path := package_path.parent + manifest.node.attributes ["href"]
				if not item_path.has_extension ("png") then
					assert ("item exists", item_path.exists)
					if item_path.base.starts_with_general ("chapter") then
						create chapter_root.make_from_file (item_path)
						assert ("at least one paragraph", chapter_root.context_list ("/html/body/p").count > 0)
						chapter_count := chapter_count + 1
					end
				end
			end
			assert ("5 chapters", chapter_count = 5)
		end

	test_www_exporter
		local
			command: THUNDERBIRD_WWW_EXPORTER
			config_path: FILE_PATH; folder_names: EL_ZSTRING_LIST
			file_set, dir_set: EL_HASH_SET [ZSTRING]
		do
			create folder_names.make_empty
			config_path := work_area_data_dir + "config.pyx"
			write_config (config_path, new_config_text("pop.eiffel-loop.com", "", folder_names))
			create command.make_from_file (config_path)
			command.execute

			create file_set.make (Www_manifest.occurrences ('%N') + 1)
			across Www_manifest.split ('%N') as line loop
				file_set.put (line.item)
			end
			create dir_set.make_from_array (<<
				"Home", "Libraries", "Tools"
			>>)
			across OS.file_list (work_area_data_dir #+ "export", "*.body") as path loop
				assert ("in directory set", dir_set.has (path.item.parent.base))
				assert ("in file set", file_set.has (path.item.base_sans_extension))
				assert ("h2 file present", path.item.with_new_extension ("h2").exists)
			end
		end

	test_xhtml_exporter
		local
			command: EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER
			config_path: FILE_PATH; folder_names: EL_ZSTRING_LIST
			folder_path: DIR_PATH; md5: like Md5_128;
			modification_table: EL_HASH_TABLE [INTEGER, FILE_PATH]
		do
			create modification_table.make_size (50)
			folder_names := "Purchase, manual, Product Tour, Screenshots"
			config_path := work_area_data_dir + "config.pyx"
			write_config (config_path, new_config_text("pop.myching.co", "", folder_names))
			create command.make_from_file (config_path)
			command.execute
			md5 := Md5_128
			md5.reset
			across << "en", "de" >> as lang loop
				across folder_names as name loop
					folder_path := work_area_data_dir.joined_dir_tuple (["export", lang.item, name.item])
					assert ("folder exists", folder_path.exists)
					across OS.sorted_file_list (folder_path, "*") as path loop
						modification_table.extend (path.item.modification_time, path.item)
						across File_system.plain_text_lines (path.item) as line loop
							md5.sink_string_8 (line.item)
						end
					end
				end
			end
			assert_same_digest_string ("combined export", "4oDcXJh78JgHoaoEXLZ+bQ==", md5.digest_base_64)

			command.execute
			across OS.file_list (work_area_data_dir #+ "export", "*") as path loop
				if modification_table.has_key (path.item) then
					assert ("unchanged after 2nd execution", path.item.modification_time = modification_table.found_item)
				else
					assert (path.item.base + " present", False)
				end
			end
			test_page_rename (command)
		end

feature {NONE} -- Implementation

	new_config_text (account, language: STRING; folders: EL_ZSTRING_LIST): ZSTRING
		local
			lines: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (Pyxis_template #$ [account])
			if not language.is_empty then
				lines.finish
				lines.put_left (Language_template #$ [language])
			end
			if folders.is_empty then
				lines.extend ("%Tcharset = %"ISO-8859-15%"")
			else
				lines.extend ("%Tfolders:")
				across folders as folder loop
					lines.extend (Folder_template #$ [folder.item])
				end
			end
			Result := lines.joined_lines
		end

	source_dir: DIR_PATH
		do
			Result := "test-data/.thunderbird"
		end

	test_page_rename (command: EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER)
		local
			en_file_path, output_path: FILE_PATH; en_text, subject_line: STRING
			en_out: PLAIN_TEXT_FILE; pos_subject: INTEGER
			product_tour_dir: DIR_PATH
		do
			-- Change name of "Home" to "Home Page"
			en_file_path := work_area_data_dir + "21h18lg7.default/Mail/pop.myching.co/Product Tour.sbd/en"
			en_text := File_system.plain_text (en_file_path)
			subject_line := "Subject: Home"
			pos_subject := en_text.substring_index (subject_line, 1)
			if pos_subject > 0 then
				en_text.replace_substring (subject_line + " Page", pos_subject, pos_subject + subject_line.count - 1)
			end
			create en_out.make_open_write (en_file_path)
			en_out.put_string (en_text)
			en_out.close
			command.execute

			product_tour_dir := work_area_data_dir #+ "export/en/Product Tour"
			across << "Home", "Home Page" >> as name loop
				across << "h2", "body" >> as extention loop
					output_path := product_tour_dir + name.item
					output_path.add_extension (extention.item)
					if output_path.base.has_substring ("Page") then
						assert ("file exists", output_path.exists)
					else
						assert ("file deleted", not output_path.exists)
					end
				end
			end
		end

	write_config (config_path: FILE_PATH; config_text: ZSTRING)
		do
			if attached open (config_path, Write) as pyxis_out then
				pyxis_out.put_string (config_text)
				pyxis_out.close
			end
		end

feature {NONE} -- Test Constants

	Folder_template: ZSTRING
		once
			Result := "%T%T%"%S%""
		end

	Language_template: ZSTRING
		once
			Result := "%Tlanguage = %S"
		end

	Pyxis_template: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "ISO-8859-1"
				
				thunderbird:
					account = "#"; export_dir = "workarea/.thunderbird/export"; home_dir = workarea
			]"
		end

	WWW_manifest: STRING = "[
		Audio management
		Client-server network
		Digital Signal Processing
		Development Tools
		External Language integration
		Graphical user interface
		Installing Eiffel Loop
		Miscellaneous
		Multi-threading
		Text processing
		Toolkit functions
		XML processing
	]"
end