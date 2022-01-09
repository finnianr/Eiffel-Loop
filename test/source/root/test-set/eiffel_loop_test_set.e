note
	description: "Test set using files in $EIFFEL_LOOP/test/data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-09 12:11:16 GMT (Sunday 9th January 2022)"
	revision: "11"

deferred class
	EIFFEL_LOOP_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_SUB_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	EIFFEL_LOOP_TEST_ROUTINES

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