note
	description: "Evaluate tests in [$source DIGEST_ROUTINES_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:56:16 GMT (Thursday 23rd January 2020)"
	revision: "1"

class
	DIGEST_ROUTINES_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [DIGEST_ROUTINES_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("hmac_sha_256_digest", 	agent item.test_hmac_sha_256_digest)
			test ("sha_256_digest", 		agent item.test_sha_256_digest)
			test ("rfc_4231_2_ascii", 		agent item.test_rfc_4231_2_ascii)
			test ("reset",						agent item.test_reset)
		end
end
