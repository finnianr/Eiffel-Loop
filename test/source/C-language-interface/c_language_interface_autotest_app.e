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
	date: "2024-01-02 10:18:17 GMT (Tuesday 2nd January 2024)"
	revision: "2"

class
	C_LANGUAGE_INTERFACE_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [COM_OBJECT_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_CPP_BOOLEAN_VECTOR,
		EL_CPP_ITERATION_CURSOR [ANY],
		EL_CPP_STD_ITERATION_CURSOR [ANY]
	]
		do
			create Result
		end

end