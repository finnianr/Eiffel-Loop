note
	description: "Finalized executable tests for library [./library/os-command.html os-command.ecf]"
	notes: "[
		Command option: `-os_command_autotest'
		
		**Test Sets**
		
			[$source OS_COMMAND_TEST_SET]
			[$source FILE_AND_DIRECTORY_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-03 10:39:37 GMT (Thursday 3rd December 2020)"
	revision: "67"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [OS_COMMAND_TEST_SET, FILE_AND_DIRECTORY_TEST_SET]

create
	make

end