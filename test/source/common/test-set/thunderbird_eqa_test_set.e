note
	description: "Test classes conforming to ${TB_ACCOUNT_READER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-14 8:04:39 GMT (Monday 14th April 2025)"
	revision: "29"

deferred class
	THUNDERBIRD_EQA_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_TUPLE

	EL_FILE_OPEN_ROUTINES

	SHARED_DEV_ENVIRON

	EL_STRING_8_CONSTANTS

feature -- Tests

	test_book_exporter
		local
			exporter: like new_book_exporter; package_path, item_path: FILE_PATH
			package_root: EL_XML_DOC_CONTEXT; chapter_count, dc_count: INTEGER
			extra_lines: EL_ZSTRING_LIST; item_id: STRING; href: ZSTRING
		do
			extra_lines := new_folder_lines ("manual")
			extra_lines.append_sequence (new_book_info_lines)

			write_config ("pop.myching.co", "en", extra_lines)
			exporter := new_book_exporter
			exporter.execute

			package_path := work_area_data_dir + "export/manual/book-package.opf"
			lio.put_path_field ("Checking", package_path)
			lio.put_new_line
			assert ("book-package.opf exists", package_path.exists)
			create package_root.make_from_file (package_path)
			if attached package_root.find_node ("/package/metadata") as metadata then
				metadata.set_namespace_key ("dc")
				across Book_info_table as table loop
					if attached metadata.find_node ("dc:" + new_metadata_name (table.key)) as dc then
						assert ("same value", table.item.is_equal (dc))
						dc_count := dc_count + 1
					end
				end
			end
			assert ("7 dc fields", dc_count = 7)

			across package_root.context_list ("/package/manifest/item") as manifest loop
				href := manifest.node ["href"]
				item_path := package_path.parent + href
				item_id := manifest.node ["id"]

				if item_path.has_extension ("png") then
					if item_id ~ "item_1" then
						assert ("valid first item", href.ends_with (Book_info_table ["cover-image-path"]))
					end
				else
					assert ("item exists", item_path.exists)
					if item_path.base.starts_with_general ("chapter") then
						check_book_chapter (create {EL_XML_DOC_CONTEXT}.make_from_file (item_path))
						chapter_count := chapter_count + 1
					end
				end
			end
			assert ("5 chapters", chapter_count = 5)

			check_book_navigation
		end

feature {NONE} -- Factory

	new_book_exporter: TB_MULTI_LANG_ACCOUNT_BOOK_EXPORTER
		do
			create Result.make_from_file (Config_path)
		end

	new_book_info_lines: EL_ZSTRING_LIST
		do
			create Result.make (Book_info_table.count * 2 + 1)
			Result.extend ("kindle-book:")
			across Book_info_table as table loop
				Result.append_split (Template.pyxis_value #$ [table.key, table.item], '%N', 0)
			end
			Result.indent (1)
		end

	new_config_text (account, language: STRING; extra_lines: EL_ZSTRING_LIST): ZSTRING
		local
			lines: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (Pyxis_template #$ [account])
			if not language.is_empty then
				lines.finish
				lines.put_left (Template.language #$ [language])
			end
			lines.append_sequence (extra_lines)
			Result := lines.joined_lines
		end

	new_folder_lines (folders: STRING): EL_ZSTRING_LIST
		local
			folder_list: EL_ZSTRING_LIST
		do
			folder_list := folders
			create Result.make (folder_list.count + 3)
			if folder_list.is_empty then
				Result.extend ("%Tcharset = %"ISO-8859-15%"")
			else
				Result.extend ("%Tfolders:")
				across folder_list as list loop
					Result.extend (Template.folder #$ [list.item])
				end
			end
		end

	new_metadata_name (name: STRING): STRING
		local
			XML: XML_ROUTINES
		do
			if name.ends_with ("-date") then
				Result :=  super_8 (name).substring_to_reversed ('-')

			elseif name.ends_with ("-heading") then
				Result :=  super_8 (name).substring_to ('-')

			else
				Result := name
			end
		end

	new_xdoc (body_path: FILE_PATH): EL_XML_DOC_CONTEXT
		local
			XML: XML_ROUTINES
		do
			create Result.make_from_string (XML.document_text ("body", "UTF-8", File.plain_text (body_path)))
		end

	new_xdoc_path (xdoc: EL_XML_DOC_CONTEXT; xpath: STRING): FILE_PATH
		do
			Result := xdoc.query (xpath)
		end

feature {NONE} -- Implementation

	assert_valid_h2_file (xdoc: EL_XML_DOC_CONTEXT; body_path: FILE_PATH)
		local
			h2_path: FILE_PATH; h2_set: EL_HASH_SET [ZSTRING]; title, has_title: ZSTRING
			count: INTEGER; h2_list: EL_XPATH_NODE_CONTEXT_LIST
		do
			has_title := "has title "
			h2_path := body_path.with_new_extension ("h2")
			h2_list := xdoc.context_list ("//h2")
			if h2_list.count > 0 then
				assert ("h2 heading file exists", h2_path.exists)
				create h2_set.make_equal (11)
				if attached open_lines (h2_path, {EL_ENCODING_TYPE}.Utf_8) as h2_lines then
					across h2_lines as line loop
						h2_set.put_copy (line.shared_item)
					end
				end
				across h2_list as h2 loop
					title := h2.node.as_full_string
					assert_32 (has_title + title, h2_set.has (title))
					count := count + 1
				end
				assert ("same h2 set count", h2_set.count = count)
			end
		end

	check_book_chapter (chapter_root: EL_XML_DOC_CONTEXT)
		do
			assert ("at least one paragraph", chapter_root.context_list ("/html/body/p").count > 0)
		end

	check_book_navigation
		local
			navigation_path: FILE_PATH; dtb_uid, doc_title, doc_author: ZSTRING
			ncx_root: EL_XML_DOC_CONTEXT
		do
			navigation_path := work_area_data_dir + "export/manual/book-navigation.ncx"
			lio.put_path_field ("Checking", navigation_path)
			lio.put_new_line

			assert ("book-navigation.ncx exists", navigation_path.exists)
			create ncx_root.make_from_file (navigation_path)
			dtb_uid := ncx_root.query ("/ncx/head/meta[@name='dtb:uid']/@content")
			doc_title := ncx_root.query ("/ncx/docTitle/text")
			doc_author := ncx_root.query ("/ncx/docAuthor/text")

			assert ("valid dtb:uid", Book_info_table ["uuid"] ~ dtb_uid)
			assert ("valid docTitle", Book_info_table ["title"] ~ doc_title)
			assert ("valid docAuthor", Book_info_table ["author"] ~ doc_author)

			do_test ("display_book_navigation_text", 1633220310 , agent display_book_navigation_text, [ncx_root])
		end

	display_book_navigation_text (ncx_root: EL_XML_DOC_CONTEXT)
		do
			across ncx_root.context_list ("//text") as text loop
				lio.put_string_field ("text", text.node.as_string)
				lio.put_new_line
			end
		end

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ ".thunderbird"
		end

	write_config (account, language: STRING; extra_lines: EL_ZSTRING_LIST)
		do
			lio.put_path_field ("Config_path", Config_path)
			lio.put_new_line
			File_system.make_directory (Config_path.parent)

			if attached open (Config_path, Write) as pyxis_out then
				pyxis_out.put_string (new_config_text (account, language, extra_lines))
				pyxis_out.close
			end
		end

feature {NONE} -- Constants

	Book_info_table: EL_ZSTRING_TABLE
		once
		-- Use `Indented' format because of kebab-case names
			create Result.make ({EL_TABLE_FORMAT}.Indented, "[
				title:
					The My Ching Manual: The complete guide to using the I Ching journal software
				description:
					Reference manual for the My Ching journal software developed by Hex 11 Software
				cover-image-path:
					image/kindle-cover.png
				author:
					Reilly, Finnian
				creator:
					Hex 11 Software
				publisher:
					Hex 11 Software
				uuid:
					39880922-D84B-11E8-9D6F-A759E74D277D
				language:
					en-US
				subject-heading:
					Reference
				publication-date:
					2018-12-01
			]")
		end

	Config_path: FILE_PATH
		once
			Result := work_area_data_dir + "config.pyx"
		end

	Empty_lines: EL_ZSTRING_LIST
		once
			create Result.make_empty
		end

	Export_dir: DIR_PATH
		once
			Result := work_area_data_dir #+ "export"
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

	Template: TUPLE [folder, language, pyxis_value: ZSTRING]
		once
			create Result
			Tuple.fill_adjusted (Result, "%T%T%"%S%",%Tlanguage = %S,%T%S:%N%T%T%"%S%"", False)
		end

end