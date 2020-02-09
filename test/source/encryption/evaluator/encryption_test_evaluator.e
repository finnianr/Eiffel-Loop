note
	description: "Encryption test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-07 10:24:03 GMT (Friday 7th February 2020)"
	revision: "1"

class
	ENCRYPTION_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [ENCRYPTION_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("aes_encryption", 	agent item.test_aes_encryption)
		end
end
