note
	description: "Unix dummy test set for Windows class $source EL_SHELL_EXECUTE_INFO_CPP_API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-02 10:45:02 GMT (Tuesday 2nd January 2024)"
	revision: "1"

class
	SHELL_EXECUTE_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
			>>)
		end

end