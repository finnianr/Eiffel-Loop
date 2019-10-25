note
	description: "Amazon instant access test evalutaor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-05 11:33:08 GMT (Saturday   5th   October   2019)"
	revision: "2"

class
	AMAZON_INSTANT_ACCESS_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [AMAZON_INSTANT_ACCESS_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["get_user_id", 					agent item.test_get_user_id],
				["get_user_id_health_check]", agent item.test_get_user_id_health_check],
				["response_code", 				agent item.test_response_code],
				["credential_id_equality", 	agent item.test_credential_id_equality],
				["credential_storage", 			agent item.test_credential_storage],
				["header_selection", 			agent item.test_header_selection],
				["parse_header_1", 				agent item.test_parse_header_1],
				["sign_and_verify", 				agent item.test_sign_and_verify]

			>>)
		end
end
