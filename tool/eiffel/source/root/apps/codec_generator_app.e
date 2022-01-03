note
	description: "Command-line interface to [$source CODEC_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "15"

class
	CODEC_GENERATOR_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [CODEC_GENERATOR]
		rename
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.set_binary_file_extensions (<< "evc" >>)
			Test.do_file_tree_test ("codec-generation", agent test_generation, 3741528401)
		end

	test_generation (dir_path: DIR_PATH)
			--
		local
			template_path, source_path: FILE_PATH
		do
			template_path := dir_path + "template.evol"
			source_path := dir_path + "test-decoder.c"
			create command.make (source_path, template_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("c_source", "C source code path"),
				required_argument ("template", "Eiffel codec template")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "generate_codecs"

	Description: STRING = "Generate Eiffel codecs from VTD-XML C source"

end
