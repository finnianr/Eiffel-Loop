note
	description: "Test set using files in $EIFFEL_LOOP/projects.data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:51:41 GMT (Monday 1st July 2019)"
	revision: "3"

class
	EIFFEL_LOOP_TEST_SET

inherit
	EQA_TEST_SET
		rename
			file_system as eqa_file_system
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
			Execution_environment.push_current_working (Test_data_dir)
		end

	on_clean
		do
			Execution_environment.pop_current_working
		end

end
