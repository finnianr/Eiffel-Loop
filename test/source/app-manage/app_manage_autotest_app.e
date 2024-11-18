note
	description: "[
		Finalized executable tests for library [./library/app-manage.html app-manage.ecf]
	]"
	notes: "[
		Command option: `-app_manage_autotest'
		
		**Test Sets**
		
			${COMMAND_ARGUMENTS_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-18 10:53:28 GMT (Monday 18th November 2024)"
	revision: "1"

class
	APP_MANAGE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [COMMAND_ARGUMENTS_TEST_SET]

create
	make

end