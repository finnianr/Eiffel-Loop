note
	description: "Finalized executable tests for library [./library/os-command.html os-command.ecf]"
	notes: "[
		Command option: `-os_command_autotest'
		
		**Test Sets**
		
			[$source AUDIO_COMMAND_TEST_SET]
			[$source OS_COMMAND_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:57:38 GMT (Friday 14th February 2020)"
	revision: "62"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [AUDIO_COMMAND_TEST_SET, OS_COMMAND_TEST_SET]
		do
			create Result
		end

end
