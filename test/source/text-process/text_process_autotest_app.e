note
	description: "Finalized executable tests for library [./library/text-process.html text-process.ecf]"
	notes: "[
		Command option: `-text_process_autotest'
		
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
	date: "2022-11-27 8:54:20 GMT (Sunday 27th November 2022)"
	revision: "16"

class
	TEXT_PROCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		EIFFEL_PARSING_TEST_SET,
		PATTERN_MATCH_TEST_SET,
		STRING_32_PATTERN_MATCH_TEST_SET,
		ZSTRING_PATTERN_MATCH_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_FILE_PARSER_TEXT_FILE_CONVERTER,
		EL_FILE_TRAILING_SPACE_REMOVER,
		EL_EIFFEL_LINE_STATE_MACHINE_TEXT_FILE_EDITOR,
		EL_EIFFEL_SOURCE_LINE_STATE_MACHINE,
		EL_MODULE_PATTERN,
		EL_PATTERN_SPLIT_STRING_LIST,
		EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR,
		EL_PASSPHRASE_EVALUATOR,
		EL_TAB_REMOVER,
		EL_ZIP_FILE_LISTING_PARSER
	]
		do
			create Result
		end
end