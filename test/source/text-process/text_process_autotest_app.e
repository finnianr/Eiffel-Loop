note
	description: "Finalized executable tests for library [./library/text-process.html text-process.ecf]"
	notes: "[
		Command option: `-text_process_autotest'
		
		**Test Sets**
		
			[$source TEXT_PARSER_TEST_SET_1]
			[$source TEXT_PARSER_TEST_SET_2]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-10 14:39:58 GMT (Sunday 10th January 2021)"
	revision: "5"

class
	TEXT_PROCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TEXT_PARSER_TEST_SET_1, TEXT_PARSER_TEST_SET_2]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_C_PATTERN_FACTORY,
		EL_FILE_TRAILING_SPACE_REMOVER,
		EL_ZIP_FILE_LISTING_PARSER
	]
		do
			create Result
		end
end