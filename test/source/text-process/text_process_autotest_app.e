note
	description: "Finalized executable tests for library [./library/text-process.html text-process.ecf]"
	notes: "[
		Command option: `-text_process_autotest'
		
		**Test Sets**
		
			[$source TEXT_PARSER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-03 10:39:22 GMT (Thursday 3rd December 2020)"
	revision: "4"

class
	TEXT_PROCESS_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TEXT_PARSER_TEST_SET]

create
	make

end