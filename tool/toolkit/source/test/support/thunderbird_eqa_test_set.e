note
	description: "Test classes conforming to [$source EL_THUNDERBIRD_ACCOUNT_READER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 17:20:03 GMT (Saturday 15th January 2022)"
	revision: "2"

deferred class
	THUNDERBIRD_EQA_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_DIGESTS

feature {NONE} -- Implementation

	assert_valid_h2_file (xdoc: EL_XPATH_ROOT_NODE_CONTEXT; body_path: FILE_PATH)
		local
			h2_path: FILE_PATH; h2_set: EL_HASH_SET [ZSTRING]
			count: INTEGER
		do
			h2_path := body_path.with_new_extension ("h2")
			assert (h2_path.base + " exists", h2_path.exists)
			create h2_set.make (11)
			if attached open_lines (h2_path, Utf_8) as h2_lines then
				across h2_lines as line loop
					h2_set.put (line.item)
				end
			end
			across xdoc.context_list ("//h2") as h2 loop
				if attached h2.node.string_value as title then
					assert ("has title " + title, h2_set.has (title))
				end
				count := count + 1
			end
			assert ("same h2 set count", h2_set.count = count)
		end

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

	new_root_node (body_path: EL_FILE_PATH): EL_XPATH_ROOT_NODE_CONTEXT
		local
			xml: STRING
		do
			xml := Xml_template.twin
			xml.replace_substring_all ("$BODY_TEXT", File_system.plain_text (body_path))
			create Result.make_from_string (xml)
		end

	new_xdoc_path (xdoc: EL_XPATH_ROOT_NODE_CONTEXT; xpath: STRING): FILE_PATH
		do
			Result := xdoc.string_32_at_xpath (xpath)
		end

	source_dir: DIR_PATH
		do
			Result := "test-data/.thunderbird"
		end

	write_config (config_path: FILE_PATH; config_text: ZSTRING)
		do
			if attached open (config_path, Write) as pyxis_out then
				pyxis_out.put_string (config_text)
				pyxis_out.close
			end
		end

feature {NONE} -- Constants

	Export_dir: DIR_PATH
		once
			Result := work_area_data_dir #+ "export"
		end

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

	Xml_template: STRING = "[
		<?xml version="1.0" encoding="UTF-8"?>
		<body>
			$BODY_TEXT
		</body>
	]"
end