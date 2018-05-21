note
	description: "Regression testable sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "2"

deferred class
	REGRESSION_TESTABLE_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION
		undefine
			Test_data_dir
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS

feature {NONE} -- Implementation

	normal_initialize
		do
		end

	normal_run
		do
		end
end
