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
	date: "2022-01-14 16:36:42 GMT (Friday 14th January 2022)"
	revision: "2"

class
	THUNDERBIRD_EXPORT_TEST_SET

inherit
	THUNDERBIRD_EQA_TEST_SET

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

			create file_set.make (Www_manifest.count)
			across Www_manifest as line loop
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
			config_path, body_path, h2_path: FILE_PATH; folder_names: EL_ZSTRING_LIST
			folder_path: DIR_PATH; modification_table: EL_HASH_TABLE [INTEGER, FILE_PATH]
			name: ZSTRING; count: INTEGER
		do
			create modification_table.make_size (50)
			folder_names := "Purchase, manual, Product Tour, Screenshots"
			config_path := work_area_data_dir + "config.pyx"
			write_config (config_path, new_config_text("pop.myching.co", "", folder_names))
			create command.make_from_file (config_path)
			command.execute

			-- check parseable as XML document
			across Pop_myching_co_manifest as list loop
				body_path := Export_dir + list.item; h2_path := body_path.with_new_extension ("h2")
				modification_table.put (body_path.modification_time, body_path)
				assert (body_path.base + " exists", body_path.exists)
				assert (h2_path.base + " exists", h2_path.exists)
				name := body_path.base_sans_extension
				if attached new_root_node (body_path) as xdoc then
					if name.has_substring ({STRING_32} "Ÿœ€") then
						assert ("expected h2 text", xdoc.string_32_at_xpath ({STRING_32}"/body/a[@id='Ÿœ']/h2") ~ {STRING_32}"Ÿœ")
						count := count + 1
					elseif name.has_substring ("Engine Screenshot") then
						assert ("expected img src", xdoc.string_8_at_xpath ("/body/img[1]/@src").ends_with_general ("search-engine.png"))
						count := count + 1
					else
						assert ("at least one paragraph", xdoc.context_list ("//p").count > 0)
						count := count + 1
					end
				end
			end
			assert ("all items covered", count = Pop_myching_co_manifest.count)

			command.execute
			if attached OS.file_list (Export_dir, "*.body") as file_list then
				assert ("manifest complete", file_list.count = Pop_myching_co_manifest.count)
				across file_list as path loop
					if modification_table.has_key (path.item) then
						assert ("unchanged after 2nd execution", path.item.modification_time = modification_table.found_item)
					else
						assert (path.item.base + " present", False)
					end
				end
			end
			test_page_rename (command)
		end

feature {NONE} -- Implementation

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

feature {NONE} -- Constants

	Export_dir: DIR_PATH
		once
			Result := work_area_data_dir #+ "export"
		end

	WWW_manifest: EL_STRING_8_LIST
		once
			create Result.make_with_lines ("[
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
			]")
		end

	Pop_myching_co_manifest: EL_ZSTRING_LIST
		once
			create Result.make_with_lines ({STRING_32} "[
				de/manual/Tagebuch-Einträge.body
				de/manual/Tagebücher-Ÿœ€.body
				de/manual/Tastenkombinationen.body
				de/Product Tour/Startseite.body
				de/Product Tour/Suchmaschine.body
				de/Purchase/2-Jahres-Abonnement.body
				en/manual/1.Hexagrams.body
				en/manual/2.Journals.body
				en/manual/3.Journal Entries.body
				en/manual/4.Keyboard Shortcuts.body
				en/manual/5.Quick Guide.body
				en/Product Tour/5.Data Privacy.body
				en/Product Tour/Home.body
				en/Product Tour/Search Engine.body
				en/Purchase/6 Month Subscription.body
				en/Screenshots/Search Engine Screenshot.body
			]")
		end
end