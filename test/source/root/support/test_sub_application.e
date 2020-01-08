note
	description: "Regression testable sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 15:15:23 GMT (Wednesday 8th January 2020)"
	revision: "6"

deferred class
	TEST_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			test_data_dir
		redefine
			Is_test_mode, Is_logging_active
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS
		rename
			Build_info as EL_build_info,
			EL_test_data_dir as test_data_dir
		end

feature {NONE} -- Implementation

	normal_initialize
		do
		end

	normal_run
		do
		end

feature {NONE} -- Constants

	Is_test_mode: BOOLEAN = True

	Is_logging_active: BOOLEAN = True

end
