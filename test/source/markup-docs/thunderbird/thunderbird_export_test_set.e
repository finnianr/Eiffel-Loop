note
	description: "[
		Test classes

			[$source EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER]
			[$source EL_ML_THUNDERBIRD_ACCOUNT_BOOK_EXPORTER]
			[$source THUNDERBIRD_WWW_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "11"

class
	THUNDERBIRD_EXPORT_TEST_SET

inherit
	THUNDERBIRD_EQA_TEST_SET
		redefine
			test_book_exporter
		end

	EL_MODULE_FILE

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("decode_iso_8859_15_subject_line", agent test_decode_iso_8859_15_subject_line)
			eval.call ("decode_utf_8_subject_line", agent test_decode_utf_8_subject_line)
			eval.call ("book_exporter", agent test_book_exporter)
			eval.call ("www_exporter", agent test_www_exporter)
			eval.call ("xhtml_exporter", agent test_xhtml_exporter)
			eval.call ("xhtml_doc_exporter", agent test_xhtml_doc_exporter)
		end

feature -- Tests

	test_book_exporter
		do
			Precursor
		end

	test_decode_iso_8859_15_subject_line
		local
			subject: EL_SUBJECT_LINE_DECODER
		do
			create subject.make
			subject.set_line ("=?ISO-8859-15?Q?=DCber_My_Ching?=")
			assert ("same string", subject.decoded_line.to_latin_1 ~ "Über My Ching")
		end

	test_decode_utf_8_subject_line
		local
			subject: EL_SUBJECT_LINE_DECODER
		do
			create subject.make
			subject.set_line ("=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=")
			assert ("same string", subject.decoded_line.same_string ({STRING_32} "Über€ My Ching"))

			subject.set_line ("=?UTF-8?Q?Journaleintr=c3=a4ge_bearbeiten?=")
			assert ("same string", subject.decoded_line.same_string ("Journaleinträge bearbeiten"))
		end

	test_www_exporter
		local
			command: EL_THUNDERBIRD_WWW_EXPORTER
			file_set, dir_set: EL_HASH_SET [ZSTRING]
		do
			write_config ("pop.eiffel-loop.com", "", "")
			create command.make_from_file (Config_path)
			command.execute

			create file_set.make (Www_manifest.count)
			across Www_manifest as line loop
				file_set.put (line.item)
			end
			create dir_set.make_from_array (<< "Home", "Libraries", "Tools" >>)
			across OS.file_list (work_area_data_dir #+ "export", "*.body") as path loop
				assert ("in directory set", dir_set.has (path.item.parent.base))
				assert ("in file set", file_set.has (path.item.base_sans_extension))
				assert_valid_h2_file (new_root_node (path.item), path.item)
			end
		end

	test_xhtml_doc_exporter
		local
			command: EL_ML_THUNDERBIRD_ACCOUNT_XHTML_DOC_EXPORTER
			count: INTEGER; xhtml_path: FILE_PATH; xdoc: like new_root_node
		do
			write_config ("pop.myching.software", "", "1.About")
			create command.make_from_file (config_path)
			command.execute
			-- check parseable as XML document
			across About_myching_manifest as list loop
				xhtml_path := Export_dir + list.item
				assert (xhtml_path.base + " exists", xhtml_path.exists)
				create xdoc.make_from_file (xhtml_path)

				assert ("at least one paragraph", xdoc.context_list ("//p").count > 0)
				count := count + 1
			end
			assert ("all items found", count = About_myching_manifest.count)
		end

	test_xhtml_exporter
		local
			command: EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER
			body_path: FILE_PATH; modification_table: EL_HASH_TABLE [INTEGER, FILE_PATH]
			name: ZSTRING; count: INTEGER; xdoc: like new_root_node
		do
			create modification_table.make_size (50)
			write_config ("pop.myching.co", "", "Purchase, manual, Product Tour, Screenshots")
			create command.make_from_file (Config_path)
			command.execute

			-- check parseable as XML document
			across Pop_myching_co_manifest as list loop
				body_path := Export_dir + list.item
				modification_table.put (body_path.modification_time, body_path)
				assert (body_path.base + " exists", body_path.exists)
				name := body_path.base_sans_extension
				xdoc := new_root_node (body_path)

				assert_valid_h2_file (xdoc, body_path)
				if name.has_substring ({STRING_32} "Ÿœ€") then
					assert ("expected h2 text", xdoc.query ({STRING_32}"/body/a[@id='Ÿœ']/h2").as_string_32 ~ {STRING_32}"Ÿœ")
					count := count + 1
				elseif name.has_substring ("Engine Screenshot") then
					assert ("expected img src", xdoc.query ("/body/img[1]/@src").as_string_8.ends_with_general ("search-engine.png"))
					count := count + 1
				else
					assert ("at least one paragraph", xdoc.context_list ("//p").count > 0)
					count := count + 1
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

	test_page_rename (command: EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER)
		local
			en_file_path, output_path: FILE_PATH; en_text, subject_line: STRING
			en_out: PLAIN_TEXT_FILE; pos_subject: INTEGER
			product_tour_dir: DIR_PATH
		do
			-- Change name of "Home" to "Home Page"
			en_file_path := work_area_data_dir + "21h18lg7.default/Mail/pop.myching.co/Product Tour.sbd/en"
			en_text := File.plain_text (en_file_path)
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
				output_path := product_tour_dir + name.item
				output_path.add_extension ("body")
				if output_path.base.has_substring ("Page") then
					assert ("file exists", output_path.exists)
				else
					assert ("file deleted", not output_path.exists)
				end
			end
		end

feature {NONE} -- Constants

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

	About_myching_manifest: EL_STRING_8_LIST
		once
			create Result.make_with_lines ("[
				de/1.About/1.Hex 11 Software.xhtml
				de/1.About/2.Der Entwickler.xhtml
				de/1.About/3.Technologie.xhtml
				en/1.About/1.Hex 11 Software.xhtml
				en/1.About/2.The Developer.xhtml
				en/1.About/3.Technology.xhtml
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