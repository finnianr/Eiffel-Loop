note
	description: "Test set using files in $EIFFEL_LOOP/projects.data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 13:11:14 GMT (Friday 31st January 2020)"
	revision: "6"

class
	EIFFEL_LOOP_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_LOG

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Events

	on_prepare
		do
			Execution_environment.push_current_working (EL_test_data_dir)
		end

	on_clean
		do
			Execution_environment.pop_current_working
		end

end
