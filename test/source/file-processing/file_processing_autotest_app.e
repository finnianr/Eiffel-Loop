note
	description: "Finalized executable tests for library [./library/text-formats.html text-formats.ecf]"
	notes: "[
		Command option: `-file_processing_autotest'
		
		**Test Sets**
		
			[$source FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET]
			[$source FILE_SYNC_MANAGER_TEST_SET]
			[$source UUID_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-06 17:40:55 GMT (Tuesday 6th December 2022)"
	revision: "19"

class
	FILE_PROCESSING_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET,
		FILE_SYNC_MANAGER_TEST_SET,
		UUID_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_DEFAULT_FILE_PROCESSING_COMMAND,
		EL_DIRECTORY_CONTENT_PROCESSOR,
		EL_DIRECTORY_LIST,
		EL_DIRECTORY_PATH_LIST,
		EL_DIRECTORY_TREE_FILE_PROCESSOR,

		EL_FILE_SWAPPER, EL_FILE_TREE_COMMAND,

		EL_UPDATEABLE_FILE
	]
		do
			create Result
		end

end