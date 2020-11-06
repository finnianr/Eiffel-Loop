note
	description: "Regression testable sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-06 16:34:26 GMT (Friday 6th November 2020)"
	revision: "10"

deferred class
	TEST_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			test_data_dir
		redefine
			Is_test_mode, Is_logging_active
		end

	EIFFEL_LOOP_TEST_CONSTANTS
		rename
			EL_test_data_dir as test_data_dir
		end

feature {NONE} -- Implementation

	log_filter_list: EL_LOG_FILTER_LIST [like Current]
		do
			create Result.make
		end

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