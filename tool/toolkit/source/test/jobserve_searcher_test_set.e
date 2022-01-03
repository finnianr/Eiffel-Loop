note
	description: "Test class [$source JOBSERVE_SEARCHER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:51 GMT (Monday 3rd January 2022)"
	revision: "2"

class
	JOBSERVE_SEARCHER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	EIFFEL_LOOP_TEST_CONSTANTS

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("execute", agent test_execute)
		end

feature -- Tests

	test_execute
		local
			searcher: JOBSERVE_SEARCHER
		do
			if not file_list.is_empty then
				create searcher.make (file_list.first_path, create {DIR_PATH}, "")
				searcher.execute
				check_same_content (searcher.results_path, "15ADCB23D84DD7133C7BDEC112AD4815")
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< Data_dir + "jobserve.xml" >>)
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := EL_test_data_dir.joined_dir_path ("XML")
		end
end