note
	description: "Test set using files in $EIFFEL_LOOP/projects.data"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-14 10:25:39 GMT (Wednesday 14th June 2017)"
	revision: "2"

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

	EL_MODULE_LOG
		undefine
			default_create
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS
		undefine
			default_create
		end

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
