note
	description: "[
		Finalized executable tests for library [./library/C-language-interface.C_API.html C-language-interface.ecf]
	]"
	notes: "[
		Command option: `-c_language_interface_autotest'
		
		**Test Sets**
		
			${COM_OBJECT_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-02 10:53:37 GMT (Sunday 2nd March 2025)"
	revision: "5"

class
	C_LANGUAGE_INTERFACE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [COM_OBJECT_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_C_DATA,
		EL_CPP_BOOLEAN_VECTOR,
		EL_CPP_ITERATOR [EL_CPP_OBJECT],
		EL_CPP_LIST [EL_CPP_ITERATION_CURSOR [EL_CPP_OBJECT], EL_CPP_OBJECT],
		EL_CPP_STD_ITERATION_CURSOR [ANY],
		EL_IMMOVEABLE
	]
		do
			create Result
		end

end