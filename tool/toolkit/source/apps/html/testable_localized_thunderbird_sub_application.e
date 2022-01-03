note
	description: "Regression testable Thunderbird reading sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "4"

deferred class
	TESTABLE_LOCALIZED_THUNDERBIRD_SUB_APPLICATION [
		READER -> EL_ML_THUNDERBIRD_ACCOUNT_READER create make_from_file end
	]

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [READER]

feature -- Test

	test_config (account, language: STRING; folders: ARRAY [STRING]; checksum: NATURAL)
		local
			lines: EL_ZSTRING_LIST
		do
			create lines.make_with_lines (Pyxis_template #$ [account])
			if not language.is_empty then
				lines.finish
				lines.put_left (Language_template #$ [language])
			end
			across folders as folder loop
				lines.extend (Folder_template #$ [folder.item])
			end
			Test.do_file_tree_test (".thunderbird", agent test_html_body_export (lines.joined_lines, ?), checksum)
		end

	test_html_body_export (config_text: ZSTRING; a_dir_path: DIR_PATH)
			--
		local
			config_path: FILE_PATH; pyxis_out: PLAIN_TEXT_FILE
		do
			config_path := a_dir_path + "config.pyx"
			create pyxis_out.make_open_write (config_path)
			pyxis_out.put_string (config_text)
			pyxis_out.close
			lio.put_new_line
			create command.make_from_file (config_path)
			normal_run

			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Thunderbird export configuration file", << file_must_exist >>)
			>>
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
					folders:
			]"
		end

end

