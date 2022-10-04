note
	description: "Test set for [$source STOCK_CONSUMPTION_CALCULATOR]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-04 9:37:12 GMT (Tuesday 4th October 2022)"
	revision: "9"

class
	MONTHLY_STOCK_USE_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("execute", agent test_execute)
		end

feature -- Tests

	test_execute
		local
			stock_use: STOCK_CONSUMPTION_CALCULATOR
		do
			if file_list.is_empty then
				assert ("stock list found", False)
			else
				create stock_use.make (file_list.first_path, create {FILE_PATH})
				stock_use.execute
				assert_same_digest (stock_use.output_path, "onVqnd91c1ISTpzbsV2Oqg==")
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "stock-list.csv" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data"
		end
end