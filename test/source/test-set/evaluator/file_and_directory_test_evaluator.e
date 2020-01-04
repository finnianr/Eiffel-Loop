note
	description: "Evaluator for test set [$source FILE_AND_DIRECTORY_TEST_SET]"
	description: "Evaluator for test set [$source FILE_AND_DIRECTORY_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-27 11:06:53 GMT (Friday 27th December 2019)"
	revision: "2"

class
	FILE_AND_DIRECTORY_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [FILE_AND_DIRECTORY_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["search_path_list",					agent item.test_search_path_list],
				["delete_content_with_action",	agent item.test_delete_content_with_action],
				["delete_with_action",				agent item.test_delete_with_action],
				["read_directories",					agent item.test_read_directories],
				["read_directory_files",			agent item.test_read_directory_files]
			>>)
		end

end