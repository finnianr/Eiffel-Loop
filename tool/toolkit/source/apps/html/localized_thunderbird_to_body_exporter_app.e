note
	description: "[
		Export folders of Thunderbird HTML as XHTML bodies and recreating the folder structure.
		
		See class [$source EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-24 12:31:05 GMT (Wednesday 24th November 2021)"
	revision: "19"

class
	LOCALIZED_THUNDERBIRD_TO_BODY_EXPORTER_APP

inherit
	TESTABLE_LOCALIZED_THUNDERBIRD_SUB_APPLICATION [EL_ML_THUNDERBIRD_ACCOUNT_XHTML_BODY_EXPORTER]
		rename
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name, test_html_body_export
		end

create
	make

feature -- Test

	test_run
			--
		do
--			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export ("pop.myching.co", ?), 2477712861)
--			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export ("small.myching.co", ?), 4123295270)

--			test_config ("pop.myching.co", "en", << "manual" >>, 578589927)

			test_config ("pop.myching.co", "", << "Purchase", "manual", "Product Tour", "Screenshots" >>, 1701579032)

--			Test.do_file_tree_test (".thunderbird", agent test_html_body_export ("small.myching.co", ?), 4015841579)
		end

	test_html_body_export (config_text: ZSTRING; a_dir_path: EL_DIR_PATH)
		local
			en_file_path: EL_FILE_PATH; en_text, subject_line: STRING
			en_out: PLAIN_TEXT_FILE
			pos_subject: INTEGER
		do
			Precursor (config_text, a_dir_path)
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

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Constants

	Description: STRING = "Export multi-lingual HTML body content from Thunderbird as files with .body extension"

	Option_name: STRING = "export_thunderbird_to_body"

end