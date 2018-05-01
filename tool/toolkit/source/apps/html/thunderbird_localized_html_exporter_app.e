note
	description: "[
		Export folders of Thunderbird HTML as XHTML bodies and recreating the folder structure.
		
		See class [$source THUNDERBIRD_LOCALIZED_HTML_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-17 14:16:18 GMT (Saturday 17th March 2018)"
	revision: "9"

class
	THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [THUNDERBIRD_LOCALIZED_HTML_EXPORTER]
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
			Test.do_file_tree_test (".thunderbird", agent test_html_body_export ("pop.myching.co", ?), 2383008038)
--			Test.do_file_tree_test (".thunderbird", agent test_html_body_export ("small.myching.co", ?), 4015841579)
		end

	test_xhtml_export (account: ZSTRING; a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				account, a_dir_path.joined_dir_path ("export"), a_dir_path.parent, True, Empty_inluded_sbd_dirs
			)
			normal_run
		end

	test_html_body_export (account: ZSTRING; a_dir_path: EL_DIR_PATH)
			--
		local
			en_file_path: EL_FILE_PATH; en_text, subject_line: STRING; en_out: PLAIN_TEXT_FILE
			pos_subject: INTEGER
		do
			create command.make (
				account, a_dir_path.joined_dir_path ("export"), a_dir_path.parent, False, Empty_inluded_sbd_dirs
			)
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
				required_argument ("account", "Thunderbird account name"),
				required_argument ("output", "Output directory path"),
				optional_argument ("thunderbird_home", "Location of .thunderbird"),
				optional_argument ("as_xhtml", "Export as xhtml"),
				optional_argument ("folders", "Folders to include")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "", Directory.Home, False, create {EL_ZSTRING_LIST}.make (7))
		end

feature {NONE} -- Constants

	Empty_inluded_sbd_dirs: EL_ZSTRING_LIST
		once
			create Result.make (0)
		end

	Option_name: STRING = "export_thunderbird"

	Description: STRING = "Export multi-lingual HTML content from Thunderbird"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP}, All_routines],
				[{THUNDERBIRD_LOCALIZED_HTML_EXPORTER}, All_routines],
				[{THUNDERBIRD_EXPORT_AS_XHTML}, All_routines],
				[{THUNDERBIRD_EXPORT_AS_XHTML_BODY}, All_routines]
			>>
		end

end
