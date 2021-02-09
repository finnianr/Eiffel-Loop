note
	description: "Test set for [$source MONTHLY_STOCK_USE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-02 11:10:23 GMT (Tuesday 2nd February 2021)"
	revision: "2"

class
	MONTHLY_STOCK_USE_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("execute", agent test_execute)
		end

feature -- Tests

	test_execute
		local
			stock_use: STOCK_CONSUMPTION_CALCULATOR
		do
			if not file_list.is_empty then
				create stock_use.make (file_list.first_path, create {EL_FILE_PATH})
				stock_use.execute
				check_same_content (stock_use.output_path, "3246A2F4CEAB1545E271751F7ABC0D53")
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "stock-list.csv" >>)
		end

feature {NONE} -- Constants

	Data_dir: EL_DIR_PATH
		once
			Result := "test-data"
		end
end