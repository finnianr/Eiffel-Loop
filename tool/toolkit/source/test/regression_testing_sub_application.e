note
	description: "Summary description for {EL_REGRESSION_TESTING_SUB_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	REGRESSION_TESTING_SUB_APPLICATION

inherit
	EL_SUB_APPLICATION
		undefine
			new_lio, new_log_manager
		end

	EL_REGRESSION_TESTING_APPLICATION

	EL_EIFFEL_LOOP_TEST_CONSTANTS

end
