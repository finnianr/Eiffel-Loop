note
	description: "Finalized executable tests for library [./library/os-command.html os-command.ecf]"
	notes: "[
		Command option: `-os_command_autotest'
		
		**Test Sets**
		
			[$source OS_COMMAND_TEST_SET]
			[$source FILE_AND_DIRECTORY_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 16:33:12 GMT (Thursday 17th August 2023)"
	revision: "75"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		OS_COMMAND_TEST_SET,
		FILE_AND_DIRECTORY_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_GET_GNOME_SETTING_COMMAND,
		EL_NATIVE_DIRECTORY_PATH_LIST,
		EL_NATIVE_DIRECTORY_TREE_FILE_PROCESSOR,
		EL_VIDEO_TO_MP3_COMMAND_IMP
	]
		do
			create Result
		end
end