note
	description: "Regression testable sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-05 13:54:19 GMT (Sunday 5th January 2020)"
	revision: "4"

deferred class
	REGRESSION_TESTABLE_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			test_data_dir
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
end
