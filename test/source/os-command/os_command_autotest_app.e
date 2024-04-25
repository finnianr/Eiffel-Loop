note
	description: "Finalized executable tests for library [./library/os-command.html os-command.ecf]"
	notes: "[
		Command option: `-os_command_autotest'
		
		**Test Sets**
		
			${FILE_AND_DIRECTORY_TEST_SET}
			${OS_COMMAND_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-25 9:35:02 GMT (Thursday 25th April 2024)"
	revision: "80"

class
	OS_COMMAND_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		FILE_AND_DIRECTORY_TEST_SET,
		OS_COMMAND_TEST_SET
	]
		redefine
			visible_types
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_GET_GNOME_SETTING_COMMAND,
		EL_NATIVE_DIRECTORY_PATH_LIST,
		EL_NATIVE_DIRECTORY_TREE_FILE_PROCESSOR,
		EL_SSH_COMMAND_FACTORY,
		EL_SYMLINK_LISTING_COMMAND,
		EL_VIDEO_TO_MP3_COMMAND_IMP
	]
		do
			create Result
		end

	visible_types: TUPLE [EL_COPY_FILE_COMMAND_IMP]
		-- types with lio output visible in console
		-- See: {EL_CONSOLE_MANAGER_I}.show_all
		do
			create Result
		end

end