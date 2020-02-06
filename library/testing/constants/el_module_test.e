note
	description: "Shared access to routines of class [$source EL_REGRESSION_TESTING_ROUTINES]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-06 14:23:49 GMT (Thursday 6th February 2020)"
	revision: "11"

deferred class
	EL_MODULE_TEST

inherit
	EL_MODULE

feature {NONE} -- Constants

	Test: EL_REGRESSION_TESTING_ROUTINES
			--
		once
			create Result.make (work_area_dir, test_data_dir)
		end

feature {NONE} -- Implementation

	test_data_dir: EL_DIR_PATH
		do
			Result := "test-data"
		end

	work_area_dir: EL_DIR_PATH
		do
			Result := "workarea"
		end

end
