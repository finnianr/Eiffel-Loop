note
	description: "Eiffel name translateable test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:29:39 GMT (Friday 10th March 2023)"
	revision: "8"

class
	EIFFEL_NAME_TRANSLATEABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_NAMING_ROUTINES
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
			>>)
		end

feature -- Tests

	test_from_upper_camel_case
		do

		end

end