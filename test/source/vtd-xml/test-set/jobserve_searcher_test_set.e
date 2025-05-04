note
	description: "Test class ${JOBSERVE_SEARCHER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 20:34:26 GMT (Sunday 4th May 2025)"
	revision: "14"

class
	JOBSERVE_SEARCHER_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		rename
			data_dir as xml_dir
		end

	SHARED_DATA_DIRECTORIES

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
				assert_same_digest (Plain_text, searcher.results_path, "TkBPwxbUD8LWZ1eEuxeBZA==")
			end
		end

feature {NONE} -- Implementation

	source_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_array (<< xml_dir + "jobserve.xml" >>)
		end

	xml_dir: DIR_PATH
		do
			Result := Data_dir.xml
		end

end