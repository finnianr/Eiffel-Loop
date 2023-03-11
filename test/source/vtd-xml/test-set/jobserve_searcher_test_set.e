note
	description: "Test class [$source JOBSERVE_SEARCHER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:29:39 GMT (Friday 10th March 2023)"
	revision: "8"

class
	JOBSERVE_SEARCHER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["execute", agent test_execute]
			>>)
		end

feature -- Tests

	test_execute
		local
			searcher: JOBSERVE_SEARCHER
		do
			if not file_list.is_empty then
				create searcher.make (file_list.first_path, create {DIR_PATH}, "")
				searcher.execute
				assert_same_digest (searcher.results_path, "Fa3LI9hN1xM8e97BEq1IFQ==")
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
			Result := Dev_environ.EL_test_data_dir #+ "XML"
		end
end