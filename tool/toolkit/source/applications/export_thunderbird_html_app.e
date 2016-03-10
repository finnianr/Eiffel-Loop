note
	description: "Summary description for {EXPORT_THUNDERBIRD_HTML_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-02-20 11:59:40 GMT (Thursday 20th February 2014)"
	revision: "4"

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
--			Test.do_file_tree_test (".thunderbird", agent test_xhtml_export, 2489845202)
			Test.do_file_tree_test (".thunderbird", agent test_html_body_export, 1319933599)
		end

	test_xhtml_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make ("pop.myching.co", "xhtml", a_dir_path.joined_dir_path ("export"), a_dir_path.parent)
			normal_run
		end

	test_html_body_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make ("pop.myching.co", "htmlbody", a_dir_path.joined_dir_path ("export"), a_dir_path.parent)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [
		account_name, export_type: EL_ASTRING; export_path, thunderbird_home_dir: EL_DIR_PATH
	]
		do
			create Result
			Result.account_name := ""
			Result.export_type := "xhtml"
			Result.export_path := ""
			Result.thunderbird_home_dir := Directory.Home
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_argument ("account", "Thunderbird account name"),
				optional_argument ("type", "Export type (xhtml or htmlbody)"),
				required_argument ("output", "Output directory path"),
				optional_argument ("thunderbird_home", "Location of .thunderbird")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_thunderbird"

	Description: STRING = "Export HTML content from Thunderbird as XHTML"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EXPORT_THUNDERBIRD_HTML_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{THUNDERBIRD_MAIL_EXPORTER}, "*"],
				[{THUNDERBIRD_MAIL_TO_XHTML_CONVERTER}, "*"],
				[{THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER}, "*"]
			>>
		end

end
