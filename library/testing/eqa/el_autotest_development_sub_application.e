note
	description: "Sub application for calling a particular AutoTest test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-20 21:22:03 GMT (Sunday 20th January 2019)"
	revision: "6"

deferred class
	EL_AUTOTEST_DEVELOPMENT_SUB_APPLICATION

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			Option_name
		end

feature {NONE} -- Implementation

	do_file_data_test (test: PROCEDURE)
		do
			test.apply
			if attached {EL_FILE_DATA_TEST_SET} test.target as data_test then
				data_test.clean (False)
			elseif attached {EL_TEST_DATA_TEST_SET} test.target as test_data then
				test_data.clean (False)
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Call manual and automatic sets during development"

	Option_name: STRING = "autotest"

end