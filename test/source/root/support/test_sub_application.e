note
	description: "Regression testable sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-12 7:32:24 GMT (Sunday 12th January 2020)"
	revision: "8"

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
