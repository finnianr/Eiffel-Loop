note
	description: "Path test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-28 10:05:12 GMT (Wednesday 28th October 2020)"
	revision: "1"

class
	PATH_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LIO

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("expansion", agent test_expansion)
		end

feature -- Tests

	test_expansion
		local
			setup_path, setup_path_2: EL_FILE_PATH; string_path: ZSTRING
		do
			setup_path := ("$EIFFEL/" + Relative_setup_path)
			lio.put_labeled_string ("setup_path.is_expandable", setup_path.is_expandable.out)
			lio.put_new_line
			setup_path.expand
			string_path := execution.item ("EIFFEL")
			string_path.append_character ('/')
			string_path.append_string_general (Relative_setup_path)
			setup_path_2 := string_path
			assert ("same path", setup_path ~ setup_path_2)
		end

feature {NONE} -- Constants

	Relative_setup_path: STRING = "library/Eiffel-Loop/setup.py"
end