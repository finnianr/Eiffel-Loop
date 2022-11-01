note
	description: "Finalized executable tests for library [./library/text-process-fast.html text-process-fast.ecf]"
	notes: "[
		Command option: `-text_process_fast_autotest'
		
		**Test Sets**
		
			[$source PATTERN_MATCH_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-01 14:41:16 GMT (Tuesday 1st November 2022)"
	revision: "10"

class
	TEXT_PROCESS_FAST_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		PATTERN_MATCH_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_PARSER_2]
		do
			create Result
		end

end