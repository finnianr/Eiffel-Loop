note
	description: "Summary description for {REGRESSION_TESTING_SUB_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 12:27:58 GMT (Thursday 29th June 2017)"
	revision: "1"

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
