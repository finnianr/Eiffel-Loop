note
	description: "Test set for [$source MONTHLY_STOCK_USE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 11:08:35 GMT (Thursday 13th May 2021)"
	revision: "4"

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
				check_same_content (stock_use.output_path, "A2756A9DDF757352124E9CDBB15D8EAA")
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