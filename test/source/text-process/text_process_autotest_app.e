note
	description: "Finalized executable tests for library [./library/text-process.html text-process.ecf]"
	notes: "[
		Command option: `-text_process_autotest'
		
		**Test Sets**
		
			[$source GENERAL_PARSER_TEST_SET]
			[$source EIFFEL_PARSING_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-23 9:19:27 GMT (Sunday 23rd October 2022)"
	revision: "8"

class
	TEXT_PROCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		GENERAL_PARSER_TEST_SET,
		EIFFEL_PARSING_TEST_SET
	]

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