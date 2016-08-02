note
	description: "Summary description for {EXPORT_THUNDERBIRD_HTML_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 6:35:19 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [THUNDERBIRD_LOCALIZED_HTML_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export, 4261842426)
--			Test.do_file_tree_test (".thunderbird", agent test_html_body_export, 2247727507)
--			Test.do_file_tree_test (".thunderbird", agent test_small_html_body_export, 3426906612)
		end

	test_xhtml_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				"pop.myching.co", a_dir_path.joined_dir_path ("export"), a_dir_path.parent, True, Empty_inluded_sbd_dirs
			)
			normal_run
		end

	test_html_body_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				"pop.myching.co", a_dir_path.joined_dir_path ("export"), a_dir_path.parent, False, Empty_inluded_sbd_dirs
			)
			normal_run
		end

	test_small_html_body_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				"small.myching.co", a_dir_path.joined_dir_path ("export"), a_dir_path.parent, False, Empty_inluded_sbd_dirs
			)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [
		account_name: ZSTRING; export_path, thunderbird_home_dir: EL_DIR_PATH
		is_xhtml: BOOLEAN; included_folders: EL_ZSTRING_LIST
	]
		do
			create Result
			Result.account_name := ""
			Result.export_path := ""
			Result.thunderbird_home_dir := Directory.Home
			Result.included_folders := create {EL_ZSTRING_LIST}.make (7)
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_argument ("account", "Thunderbird account name"),
				required_argument ("output", "Output directory path"),
				optional_argument ("thunderbird_home", "Location of .thunderbird"),
				optional_argument ("as_xhtml", "Export as xhtml"),
				optional_argument ("folders", "Folders to include")
			>>
		end

feature {NONE} -- Constants

	Empty_inluded_sbd_dirs: EL_ZSTRING_LIST
		once
			create Result.make (0)
		end

	Option_name: STRING = "export_thunderbird"

	Description: STRING = "Export multi-lingual HTML content from Thunderbird"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{THUNDERBIRD_LOCALIZED_HTML_EXPORTER_APP}, All_routines],
				[{THUNDERBIRD_LOCALIZED_HTML_EXPORTER}, All_routines],
				[{THUNDERBIRD_MAIL_TO_XHTML_CONVERTER}, All_routines],
				[{THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER}, All_routines]

			>>
		end

end