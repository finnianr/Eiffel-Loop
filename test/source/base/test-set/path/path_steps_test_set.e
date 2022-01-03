note
	description: "Path steps test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "6"

class
	PATH_STEPS_TEST_SET

inherit
	EL_EQA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("path_to_steps", agent test_path_to_steps)
		end

feature -- Tests

	test_path_to_steps
		note
			testing: "covers/{EL_PATH_STEPS}.make_from_path"
		local
			steps: EL_PATH_STEPS
		do
			steps := Config_dir
			across Config_dir.to_string.split_list ('/') as step loop
				assert ("same step", step.item ~ steps [step.cursor_index])
			end
		end

feature {NONE} -- Constants

	Config_dir: DIR_PATH
		once
			Result := "/home/finnian/.config"
		end

end