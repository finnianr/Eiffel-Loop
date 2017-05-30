note
	description: "Summary description for {THUNDERBIRD_WWW_EXPORTER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:20:02 GMT (Monday 29th May 2017)"
	revision: "3"

class
	THUNDERBIRD_WWW_EXPORTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [THUNDERBIRD_WWW_EXPORTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_tree_test (".thunderbird", agent test_www_export, 4261842426)
		end

	test_www_export (a_dir_path: EL_DIR_PATH)
			--
		do
			create command.make ("pop.eiffel-loop.com", a_dir_path.joined_dir_path ("export"), a_dir_path.parent)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [
		account_name: ZSTRING; export_path, thunderbird_home_dir: EL_DIR_PATH
	]
		do
			create Result
			Result.account_name := "pop.eiffel-loop.com"
			Result.export_path := ""
			Result.thunderbird_home_dir := Directory.Home
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_argument ("account", "Thunderbird account name"),
				required_argument ("output", "Output directory path"),
				optional_argument ("thunderbird_home", "Location of .thunderbird")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_www"

	Description: STRING = "Export HTML content from www directory under Thunderbird account"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{THUNDERBIRD_WWW_EXPORTER_APP}, All_routines],
				[{THUNDERBIRD_WWW_EXPORTER}, All_routines],
				[{THUNDERBIRD_MAIL_TO_HTML_BODY_CONVERTER}, All_routines]
			>>
		end

end
