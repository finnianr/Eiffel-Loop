note
	description: "[
		Test classes conforming to [$source TB_ACCOUNT_READER]

			TB_ACCOUNT_READER*
				[$source TB_WWW_XHTML_CONTENT_EXPORTER]
				[$source TB_MULTI_LANG_ACCOUNT_READER]*
					[$source TB_MULTI_LANG_ACCOUNT_XHTML_BODY_EXPORTER]
					[$source TB_MULTI_LANG_ACCOUNT_XHTML_DOC_EXPORTER]
					[$source TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-09 12:11:46 GMT (Thursday 9th November 2023)"
	revision: "29"

class
	THUNDERBIRD_EXPORT_TEST_SET

inherit
	THUNDERBIRD_EQA_TEST_SET
		redefine
			test_book_exporter
		end

	EL_MODULE_FILE

	EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["book_exporter", agent test_book_exporter],
				["email_list", agent test_email_list],
				["email_list_encoding", agent test_email_list_encoding],
				["subject_line_decoding", agent test_subject_line_decoding],
				["www_exporter", agent test_www_exporter],
				["xhtml_doc_exporter", agent test_xhtml_doc_exporter],
				["xhtml_exporter", agent test_xhtml_exporter]
			>>)
		end

feature -- Tests

	test_book_exporter
		-- THUNDERBIRD_EXPORT_TEST_SET.test_book_exporter
		do
			Precursor
		end

	test_email_list
		-- THUNDERBIRD_EXPORT_TEST_SET.test_email_list
		local
			command: TB_WWW_XHTML_CONTENT_EXPORTER; email_list: TB_EMAIL_LIST
			email_date, date_time: EL_DATE_TIME; x_mozilla_draft_info: like Email_type.x_mozilla_draft_info
			n: ARRAY [NATURAL_8]
		do
			write_config ("pop.eiffel-loop.com", Empty_string_8, Empty_lines)
			create command.make_from_file (Config_path)
			create email_list.make (command.mail_dir + "www.sbd/Tools")
			assert ("email count OK", email_list.count = 2)
			if attached email_list.first as email then
				assert_same_string (Void, email.FCC, "mailbox://finnian%%40eiffel-loop.com@pop.eiffel-loop.com/Sent")
				assert_same_string (Void, email.content_type.mime, "text/html")
				assert_same_string (Void, email.content_type.encoding_name, "iso-8859-15")
				assert_same_string (Void, email.content_transfer_encoding, "7bit")
				assert_same_string (Void, email.from_, "Finnian Reilly <finnian@eiffel-loop.com>")
				assert_same_string (Void, email.message_id, "<4D94A700.1000105@eiffel-loop.com>")
				assert_same_string (Void, email.mime_version_string, "1.0")
				assert_same_string (Void, email.subject, "Toolkit functions")
				assert_same_string (Void, email.x_account_key, "account1")
				assert_same_string (Void, email.x_identity_key, "id1")

				create email_date.make_from_epoch (email.date)
				-- Sun, 3 Apr 2016 12:25:48 +0100
				create date_time.make_fine (2016, 4, 3, 11, 25, 48)
				assert ("date OK", date_time ~ email_date)
				assert ("content OK", email.content.starts_with ("<html>") and email.content.ends_with ("</html>"))
				assert ("user_agent", email.user_agent.starts_with ("Mozilla/5.0") and email.user_agent.ends_with ("38.6.0"))

				n := << 1, 2, 3, 4, 5, 6 >>
				x_mozilla_draft_info := ["internal/draft", n [1], n [2], n [3], n [4], n [5], n [6]]
				x_mozilla_draft_info.compare_objects
				email.x_mozilla_draft_info.compare_objects
				assert ("x_mozilla_draft_info OK", email.x_mozilla_draft_info ~ x_mozilla_draft_info)

				assert ("x_mozilla_status OK", email.x_mozilla_status = 1)
				assert ("x_mozilla_status2 OK", email.x_mozilla_status2 = 2)

				assert ("same instance from string set", email.x_mozilla_keys = space * 80)
			end
		end

	test_email_list_encoding
		local
			command: TB_WWW_XHTML_CONTENT_EXPORTER; email_list: TB_EMAIL_LIST; euro_fragment: STRING_32
		do
			write_config ("small.myching.co", Empty_string_8, new_folder_lines ("Purchase"))
			create command.make_from_file (Config_path)
			across << "en", "de" >> as lang loop
				create email_list.make (command.mail_dir.joined_file_tuple (["Purchase.sbd", lang.item]))
				assert ("count OK", email_list.count = 1)
				inspect lang.cursor_index
					when 1 then -- charset=ISO-8859-15
						euro_fragment := {STRING_32} "6 months: €3.00"

					when 2 then -- charset=windows-1252
						euro_fragment := {STRING_32} "8,00 €"
				end
				assert ("euro encoding OK", email_list.first.content.has_substring (euro_fragment))
			end
		end

	test_subject_line_decoding
		local
			line: ZSTRING
		do
			line := Subject_decoder.decoded ("=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=")
			assert_same_string (Void, line, {STRING_32} "Über€ My Ching")

			line := Subject_decoder.decoded ("=?UTF-8?Q?Journaleintr=c3=a4ge_bearbeiten?=")
			assert_same_string (Void, line, "Journaleinträge bearbeiten")

			line := Subject_decoder.decoded ("=?ISO-8859-15?Q?=DCber_My_Ching?=")
			assert_same_string (Void, line, "Über My Ching")
		end

	test_www_exporter
		local
			command: TB_WWW_XHTML_CONTENT_EXPORTER; path: FILE_PATH
			file_set, dir_set: EL_HASH_SET [ZSTRING]
		do
			write_config ("pop.eiffel-loop.com", Empty_string_8, Empty_lines)
			create command.make_from_file (Config_path)
			command.execute

			create file_set.make (Www_manifest.count)
			across Www_manifest as line loop
				file_set.put (line.item)
			end
			create dir_set.make_from_array (<< "Home", "Libraries", "Tools" >>)
			across OS.file_list (work_area_data_dir #+ "export", "*.body") as list loop
				path := list.item
				assert ("in directory set", dir_set.has (path.parent.base))
				assert ("in file set", file_set.has (path.base_name))
				assert_valid_h2_file (new_xdoc (path), path)
			end
		end

	test_xhtml_doc_exporter
		local
			command: TB_MULTI_LANG_ACCOUNT_XHTML_DOC_EXPORTER
			count: INTEGER; xhtml_path: FILE_PATH; xdoc: like new_xdoc
		do
			write_config ("pop.myching.software", Empty_string_8, new_folder_lines ("1.About"))
			create command.make_from_file (config_path)
			command.execute
			-- check parseable as XML document
			across About_myching_manifest as list loop
				xhtml_path := Export_dir + list.item
				assert_32 (xhtml_path.base + " exists", xhtml_path.exists)
				create xdoc.make_from_file (xhtml_path)

				assert ("at least one paragraph", xdoc.context_list ("//p").count > 0)
				count := count + 1
			end
			assert ("all items found", count = About_myching_manifest.count)
		end

	test_xhtml_exporter
		-- THUNDERBIRD_EXPORT_TEST_SET.test_xhtml_exporter
		local
			command: TB_MULTI_LANG_ACCOUNT_XHTML_BODY_EXPORTER
			body_path: FILE_PATH; modification_table: EL_HASH_TABLE [INTEGER, FILE_PATH]
			name: ZSTRING; count: INTEGER; xdoc: like new_xdoc
		do
			create modification_table.make_size (50)
			write_config ("pop.myching.co", Empty_string_8, new_folder_lines ("Purchase, manual, Product Tour, Screenshots"))
			create command.make_from_file (Config_path)
			command.execute

			-- check parseable as XML document
			across Pop_myching_co_manifest as list loop
				body_path := Export_dir + list.item
				modification_table.put (body_path.modification_time, body_path)
				assert_32 (body_path.base + " exists", body_path.exists)
				name := body_path.base_name
				xdoc := new_xdoc (body_path)

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
						failed (path.item.base + " present")
					end
				end
			end
			test_page_rename (command)
		end

feature {NONE} -- Implementation

	test_page_rename (command: TB_MULTI_LANG_ACCOUNT_XHTML_BODY_EXPORTER)
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

	Email_type: TB_EMAIL
		once
			create Result.make
		end

	Subject_decoder: TB_SUBJECT_LINE_DECODER
		once
			create Result.make
		end

feature {NONE} -- File Manifests

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

end