note
	description: "Finalized executable tests for library [./library/wel-regedit-x.html wel-regedit-x.ecf]"
	notes: "[
		Command option: `-regedit_autotest'

		**Test Sets**

			${REGEDIT_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-23 7:26:13 GMT (Saturday 23rd September 2023)"
	revision: "1"

class
	REGEDIT_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [REGEDIT_TEST_SET]

create
	make

end