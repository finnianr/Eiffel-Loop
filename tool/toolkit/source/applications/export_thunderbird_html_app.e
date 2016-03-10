note
	description: "Summary description for {EXPORT_THUNDERBIRD_HTML_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:54:43 GMT (Friday 18th December 2015)"
	revision: "8"

class
	EXPORT_THUNDERBIRD_HTML_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [THUNDERBIRD_MAIL_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export, 3689436838)
--			Test.do_file_tree_test (".thunderbird", agent test_html_body_export, 2247727507)
--			Test.do_file_tree_test (".thunderbird", agent test_small_html_body_export, 3426906612)
		end

	test_xhtml_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				"pop.myching.co", "xhtml", a_dir_path.joined_dir_path ("export"), a_dir_path.parent, Empty_inluded_sbd_dirs
			)
			normal_run
		end

	test_html_body_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				"pop.myching.co", "htmlbody", a_dir_path.joined_dir_path ("export"), a_dir_path.parent, Empty_inluded_sbd_dirs
			)
			normal_run
		end

	test_small_html_body_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make (
				"small.myching.co", "htmlbody", a_dir_path.joined_dir_path ("export"), a_dir_path.parent, Empty_inluded_sbd_dirs
			)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [
		account_name, export_type: ZSTRING; export_path, thunderbird_home_dir: EL_DIR_PATH; included_folders: EL_ZSTRING_LIST
	]
		do
			create Result
			Result.account_name := ""
			Result.export_type := "xhtml"
			Result.export_path := ""
			Result.thunderbird_home_dir := Directory.Home
			Result.included_folders := create {EL_ZSTRING_LIST}.make (7)
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_argument ("account", "Thunderbird account name"),
				optional_argument ("type", "Export type (xhtml or htmlbody)"),
				required_argument ("output", "Output directory path"),
				optional_argument ("thunderbird_home", "Location of .thunderbird"),
				optional_argument ("folders", "Folders to include")
			>>
		end

feature {NONE} -- Constants

	Empty_inluded_sbd_dirs: EL_ZSTRING_LIST
		once
			create Result.make (0)
		end

	Option_name: STRING = "export_thunderbird"

	Description: STRING = "Export HTML content from Thunderbird as XHTML"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EXPORT_THUNDERBIRD_HTML_APP}, All_routines],
				[{EL_TEST_ROUTINES}, All_routines],
				[{THUNDERBIRD_MAIL_EXPORTER}, All_routines],
				[{THUNDERBIRD_MAIL_TO_XHTML_CONVERTER}, All_routines],
				[{THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER}, All_routines]

			>>
		end

end
