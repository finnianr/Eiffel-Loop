note
	description: "Thunderbird www exporter app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 9:28:47 GMT (Monday 2nd September 2019)"
	revision: "12"

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
		local
			config_path: EL_FILE_PATH; pyxis_out: EL_PLAIN_TEXT_FILE
		do
			config_path := a_dir_path + "config.pyx"
			create pyxis_out.make_open_write (config_path)
			pyxis_out.put_string (Pyxis_template #$ ["pop.eiffel-loop.com"])
			pyxis_out.close
			create command.make_from_file (config_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Thunderbird export configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make_from_file ("")
		end

feature {NONE} -- Test Constants

	Pyxis_template: ZSTRING
		once
			Result := "[
				pyxis-doc:
					version = 1.0; encoding = "UTF-8"
				
				thunderbird:
					account = "#"; export_dir = "workarea/.thunderbird/export"; home_dir = workarea
					charset = "ISO-8859-15"
			]"
		end

feature {NONE} -- Constants

	Option_name: STRING = "export_www"

	Description: STRING = "Export HTML content from www directory under Thunderbird account"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{THUNDERBIRD_WWW_EXPORTER_APP}, All_routines],
				[{THUNDERBIRD_WWW_EXPORTER}, All_routines]
			>>
		end

end
