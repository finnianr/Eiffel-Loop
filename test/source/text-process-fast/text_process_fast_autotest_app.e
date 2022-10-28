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
	date: "2022-10-28 16:36:24 GMT (Friday 28th October 2022)"
	revision: "9"

class
	TEXT_PROCESS_FAST_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		PATTERN_MATCH_TEST_SET
	]

create
	make

end