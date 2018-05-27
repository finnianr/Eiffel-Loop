note
	description: "Module test"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "6"

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
