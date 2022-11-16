note
	description: "Test set using files in $EIFFEL_LOOP/test/data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "14"

deferred class
	EIFFEL_LOOP_TEST_SET

inherit
	EL_EQA_TEST_SET
		export
			{EL_APPLICATION} clean
		redefine
			on_prepare, on_clean
		end

	SHARED_DEV_ENVIRON

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Events

	on_prepare
		do
			Execution_environment.push_current_working (Dev_environ.EL_test_data_dir)
		end

	on_clean
		do
			Execution_environment.pop_current_working
		end

end