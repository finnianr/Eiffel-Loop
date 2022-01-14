note
	description: "Test classes conforming to [$source EL_THUNDERBIRD_ACCOUNT_READER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-14 15:51:08 GMT (Friday 14th January 2022)"
	revision: "1"

deferred class
	THUNDERBIRD_EQA_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

	EL_FILE_OPEN_ROUTINES

	EL_SHARED_DIGESTS

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

	new_root_node (body_path: EL_FILE_PATH): EL_XPATH_ROOT_NODE_CONTEXT
		local
			xml: STRING
		do
			xml := Xml_template.twin
			xml.replace_substring_all ("$BODY_TEXT", File_system.plain_text (body_path))
			create Result.make_from_string (xml)
		end

	write_config (config_path: FILE_PATH; config_text: ZSTRING)
		do
			if attached open (config_path, Write) as pyxis_out then
				pyxis_out.put_string (config_text)
				pyxis_out.close
			end
		end

feature {NONE} -- Constants

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