note
	description: "Thunderbird www exporter app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "9"

class
	THUNDERBIRD_WWW_EXPORTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [THUNDERBIRD_WWW_EXPORTER]
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

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_argument ("account", "Thunderbird account name"),
				required_argument ("output", "Output directory path"),
				optional_argument ("thunderbird_home", "Location of .thunderbird")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("pop.eiffel-loop.com", "", Directory.Home)
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_www"

	Description: STRING = "Export HTML content from www directory under Thunderbird account"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{THUNDERBIRD_WWW_EXPORTER_APP}, All_routines],
				[{THUNDERBIRD_WWW_EXPORTER}, All_routines],
				[{THUNDERBIRD_EXPORT_AS_XHTML_BODY}, All_routines]
			>>
		end

end
