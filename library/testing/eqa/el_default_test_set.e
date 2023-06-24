note
	description: "Default EQA test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-24 4:19:15 GMT (Saturday 24th June 2023)"
	revision: "7"

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
			eqa_file_system := new_file_system
		end
end