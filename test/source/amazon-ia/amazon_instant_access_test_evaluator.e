note
	description: "Amazon instant access test evalutaor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 15:20:02 GMT (Thursday 23rd January 2020)"
	revision: "5"

class
	AMAZON_INSTANT_ACCESS_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [AMAZON_INSTANT_ACCESS_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			-- Account Linking
			test ("get_user_id", 					agent item.test_get_user_id)
			test ("get_user_id_health_check",	agent item.test_get_user_id_health_check)

			-- Authorization
			test ("credential_storage", 			agent item.test_credential_storage)
			test ("credential_id_equality", 		agent item.test_credential_id_equality)
			test ("header_selection", 				agent item.test_header_selection)
			test ("parse_header_1", 				agent item.test_parse_header_1)
			test ("sign_and_verify", 				agent item.test_sign_and_verify)

			-- Purchase
			test ("purchase_fullfill", 			agent item.test_purchase_fullfill)
			test ("purchase_revoke", 				agent item.test_purchase_revoke)
			test ("response_code", 					agent item.test_response_code)
		end
end
