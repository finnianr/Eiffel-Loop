note
	description: "Regression testable sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 13:52:10 GMT (Thursday 6th February 2020)"
	revision: "9"

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

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{like Current}, All_routines]
			>>
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
