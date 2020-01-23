note
	description: "Evaluator for test set [$source FILE_AND_DIRECTORY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:58:06 GMT (Thursday 23rd January 2020)"
	revision: "4"

class
	FILE_AND_DIRECTORY_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [FILE_AND_DIRECTORY_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("search_path_list",				agent item.test_search_path_list)
			test ("delete_content_with_action",	agent item.test_delete_content_with_action)
			test ("delete_with_action",			agent item.test_delete_with_action)
			test ("read_directories",				agent item.test_read_directories)
			test ("read_directory_files",			agent item.test_read_directory_files)
		end

end
