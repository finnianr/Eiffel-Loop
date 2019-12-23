note
	description: "Module test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-22 14:14:38 GMT (Sunday 22nd December 2019)"
	revision: "10"

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
