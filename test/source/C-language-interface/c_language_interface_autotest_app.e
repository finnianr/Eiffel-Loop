note
	description: "[
		Finalized executable tests for library [./library/C-language-interface.html C-language-interface.ecf]
	]"
	notes: "[
		Command option: `-c_language_interface_autotest'
		
		**Test Sets**
		
			[$source COM_OBJECT_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-01 12:00:44 GMT (Monday 1st January 2024)"
	revision: "1"

class
	C_LANGUAGE_INTERFACE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [COM_OBJECT_TEST_SET]

create
	make

end