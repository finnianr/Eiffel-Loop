note
	description: "Sub application for calling a particular AutoTest test"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	do_file_data_test (test: PROCEDURE [EQA_TEST_SET, TUPLE])
		do
			test.apply
			if attached {EL_FILE_DATA_TEST_SET} test.target as data_test then
				data_test.clean (False)
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Call manual and automatic sets during development"

	Option_name: STRING = "autotest"

end
