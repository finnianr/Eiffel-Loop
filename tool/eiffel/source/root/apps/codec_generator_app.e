note
	description: "Command-line interface to [$source CODEC_GENERATOR] command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-05 9:43:18 GMT (Tuesday 5th June 2018)"
	revision: "7"

class
	CODEC_GENERATOR_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [CODEC_GENERATOR]
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

	test_generation (dir_path: EL_DIR_PATH)
			--
		local
			template_path, source_path: EL_FILE_PATH
		do
			template_path := dir_path + "template.evol"
			source_path := dir_path + "test-decoder.c"
			create command.make (source_path, template_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_argument ("c_source", "C source code path"),
				required_argument ("template", "Eiffel codec template")
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("", "")
		end

feature {NONE} -- Constants

	Option_name: STRING = "generate_codecs"

	Description: STRING = "Generate Eiffel codecs from VTD-XML C source"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{CODEC_GENERATOR_APP}, All_routines],
				[{CODEC_GENERATOR}, All_routines]
			>>
		end

end
