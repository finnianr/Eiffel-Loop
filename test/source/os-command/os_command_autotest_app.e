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
	date: "2022-02-22 16:16:46 GMT (Tuesday 22nd February 2022)"
	revision: "69"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [OS_COMMAND_TEST_SET, FILE_AND_DIRECTORY_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_VIDEO_TO_MP3_COMMAND_IMP
	]
		do
			create Result
		end
end