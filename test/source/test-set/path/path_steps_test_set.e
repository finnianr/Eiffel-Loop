note
	description: "Path steps test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-02 12:39:49 GMT (Wednesday 2nd January 2019)"
	revision: "2"

class
	PATH_STEPS_TEST_SET

inherit
	EQA_TEST_SET

feature -- Test routines

	test_path_to_steps
		note
			testing: "covers/{EL_PATH_STEPS}.make_from_path"
		local
			steps: EL_PATH_STEPS
		do
			steps := Config_dir
			across Config_dir.to_string.split ('/') as step loop
				assert ("same step", step.item ~ steps [step.cursor_index])
			end
		end

feature {NONE} -- Constants

	Config_dir: EL_DIR_PATH
		once
			Result := "/home/finnian/.config"
		end

end
