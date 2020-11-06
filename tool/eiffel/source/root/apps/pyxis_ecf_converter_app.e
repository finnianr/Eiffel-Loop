note
	description: "Regression testable command line interface to command [$source PYXIS_ECF_CONVERTER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:38:34 GMT (Friday 6th November 2020)"
	revision: "2"

class
	PYXIS_ECF_CONVERTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_ECF_CONVERTER]
		rename
			extra_log_filter_list as empty_log_filter_list
		undefine
			test_data_dir
		redefine
			Option_name, visible_types
		end

	EIFFEL_LOOP_TEST_CONSTANTS
		rename
			EL_test_data_dir as test_data_dir
		end

create
	make

feature -- Testing

	test_run
			--
		do

			Test.do_file_test ("pyxis/eiffel-loop.pecf", agent convert_pecf, 1269595253)
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Input file path", << file_must_exist >>),
				optional_argument ("out", "Output file path")
			>>
		end

	convert_pecf (a_file_path: EL_FILE_PATH)
			--
		do
			create {PYXIS_ECF_CONVERTER} command.make (a_file_path, create {EL_FILE_PATH})
			normal_run
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

	visible_types: TUPLE [PYXIS_ECF_CONVERTER]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

feature {NONE} -- Constants

	Option_name: STRING = "pecf_to_xml"

	Description: STRING = "Convert ECF file in Pyxis format to xml"

end