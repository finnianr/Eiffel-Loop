note
	description: "Finalized executable tests for library [./library/text-process-fast.html text-process-fast.ecf]"
	notes: "[
		Command option: `-text_process_fast_autotest'
		
		**Test Sets**
		
			[$source EIFFEL_FAST_PARSING_TEST_SET]
			[$source PATTERN_MATCH_TEST_SET]
			[$source STRING_32_PATTERN_MATCH_TEST_SET]
			[$source ZSTRING_PATTERN_MATCH_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	TEXT_PROCESS_FAST_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		EIFFEL_FAST_PARSING_TEST_SET,
		PATTERN_MATCH_TEST_SET,
		STRING_32_PATTERN_MATCH_TEST_SET,
		ZSTRING_PATTERN_MATCH_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_FILE_PARSER_2,
		EL_FILE_PARSER_TEXT_EDITOR_2,
		EL_PARSER_2,
		EL_PARSER_TEXT_EDITOR_2
	]
		do
			create Result
		end

end