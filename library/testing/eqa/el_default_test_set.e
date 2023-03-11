note
	description: "Default EQA test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 12:07:21 GMT (Friday 10th March 2023)"
	revision: "6"

class
	EL_DEFAULT_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		-- evaluate all tests
		do
			test_file_system := new_file_system
		end
end