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
	date: "2020-05-26 17:30:54 GMT (Tuesday 26th May 2020)"
	revision: "65"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type: TUPLE [OS_COMMAND_TEST_SET]
		do
			create Result
		end

	test_types_all: TUPLE [OS_COMMAND_TEST_SET, FILE_AND_DIRECTORY_TEST_SET]
		do
			create Result
		end

end
