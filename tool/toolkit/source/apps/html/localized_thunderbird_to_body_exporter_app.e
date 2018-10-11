note
	description: "[
		Export folders of Thunderbird HTML as XHTML bodies and recreating the folder structure.
		
		See class [$source EL_THUNDERBIRD_LOCALIZED_HTML_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 17:30:42 GMT (Thursday 27th September 2018)"
	revision: "11"

class
	LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
--			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export ("pop.myching.co", ?), 2477712861)
--			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export ("small.myching.co", ?), 4123295270)
			Test.do_file_tree_test (".thunderbird", agent test_html_body_export ("pop.myching.co", ?), 1477209464)
--			Test.do_file_tree_test (".thunderbird", agent test_html_body_export ("small.myching.co", ?), 4015841579)
		end

	test_html_body_export (account: ZSTRING; a_dir_path: EL_DIR_PATH)
			--
		local
			en_file_path, config_path: EL_FILE_PATH; en_text, subject_line: STRING; en_out, pyxis_out: EL_PLAIN_TEXT_FILE
			pos_subject: INTEGER
		do
			config_path := a_dir_path + "config.pyx"
			create pyxis_out.make_open_write (config_path)
			pyxis_out.put_string (Pyxis_template #$ [account])
			if account.starts_with_general ("pop.") then
				across Folders as folder loop
					pyxis_out.put_new_line
					pyxis_out.put_string (Folder_template #$ [folder.item])
				end
			end
			pyxis_out.close
			lio.put_new_line
			create command.make_from_file (config_path)
			normal_run

			-- Change name of "Home" to "Home Page"
			en_file_path := a_dir_path + "21h18lg7.default/Mail/pop.myching.co/Product Tour.sbd/en"
			en_text := File_system.plain_text (en_file_path)
			subject_line := "Subject: Home"
			pos_subject := en_text.substring_index (subject_line, 1)
			if pos_subject > 0 then
				en_text.replace_substring (subject_line + " Page", pos_subject, pos_subject + subject_line.count - 1)
			end
			create en_out.make_open_write (en_file_path)
			en_out.put_string (en_text)
			en_out.close

			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("config", "Thunderbird export configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Test Constants

	Folders: ARRAY [STRING]
		once
			Result := << "manual", "Product Tour", "Screenshots" >>
		end

	Folder_template: ZSTRING
		once
			Result := "%T%T%"%S%""
		end

	Pyxis_template: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "UTF-8"
				
				thunderbird:
					account = "#"; export_dir = "workarea/.thunderbird/export"; home_dir = workarea
					charset = "ISO-8859-15"
					folders:
						"Purchase"
			]"
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_thunderbird_to_body"

	Description: STRING = "Export multi-lingual HTML body content from Thunderbird as files with .body extension"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP}, All_routines]
			>>
		end

end
