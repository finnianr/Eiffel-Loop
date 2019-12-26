note
	description: "File command test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-26 16:58:24 GMT (Thursday 26th December 2019)"
	revision: "1"

class
	FILE_COMMAND_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [FILE_COMMAND_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["delete_content_with_action",	agent item.test_delete_content_with_action],
				["delete_with_action",				agent item.test_delete_with_action],
				["read_directories",					agent item.test_read_directories],
				["read_directory_files",			agent item.test_read_directory_files]
			>>)
		end

end
