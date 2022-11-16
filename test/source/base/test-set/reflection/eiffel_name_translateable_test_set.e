note
	description: "Eiffel name translateable test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	EIFFEL_NAME_TRANSLATEABLE_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_NAMING_ROUTINES
		undefine
			default_create
		end

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
		end

feature -- Tests

	test_from_upper_camel_case
		do

		end

end