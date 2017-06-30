note
	description: "Summary description for {EL_MODULE_TEST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-29 12:02:55 GMT (Thursday 29th June 2017)"
	revision: "4"

deferred class
	EL_MODULE_TEST

inherit
	EL_MODULE

feature -- Access

	Test: EL_REGRESSION_TESTING_ROUTINES
			--
		once
			create Result.make (work_area_dir, test_data_dir)
		end

feature {NONE} -- Constants

	Test_data_dir: EL_DIR_PATH
		once
			Result := "test-data"
		end

	Work_area_dir: EL_DIR_PATH
		once
			Result := "workarea"
		end

end
