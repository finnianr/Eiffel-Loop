note
	description: "Test suite for Amazon Instant Access API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-27 6:45:34 GMT (Tuesday 27th August 2024)"
	revision: "43"

class
	AMAZON_INSTANT_ACCESS_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		redefine
			on_prepare
		end

	EL_MODULE_EIFFEL

	AIA_SHARED_REQUEST_MANAGER

	AIA_SHARED_ENUMERATIONS

create
	make

feature {NONE} -- Initialization

	on_prepare
			-- Called after all initializations in `default_create'.
		do
			Precursor
			create credential_list.make (credentials_file_path, new_encrypter)
			credential_list.extend (Credential)
		end

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
			-- Account Linking
				["get_user_id", 					agent test_get_user_id],
				["get_user_id_health_check",	agent test_get_user_id_health_check],

			-- Authorization
				["credential_storage",			agent test_credential_storage],
				["credential_id_equality", 	agent test_credential_id_equality],
				["header_selection", 			agent test_header_selection],
				["parse_header_1", 				agent test_parse_header_1],
				["sign_and_verify", 				agent test_sign_and_verify],

			-- Purchase
				["purchase_fullfill", 			agent test_purchase_fullfill],
				["purchase_revoke",				agent test_purchase_revoke],
				["response_code", 				agent test_response_code]
			>>)
		end

feature -- Account Linking

	test_get_user_id
		note
			testing: "[
				covers/{AIA_REQUEST_MANAGER}.response,
				covers/{EL_SETTABLE_FROM_JSON_STRING}.as_json,
				covers/{AIA_SIGNER}.sign
			]"
		local
			request: like new_amazon_request
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "GetUserId",
					"infoField1": "nobody@amazon.com",
					"infoField2": "amazon",
					"infoField3": "nobody"
				}
			]")
			sign (request)
			request_get_user_id_1234 (request, "[
				{
					"response": "OK",
					"userId": "1234"
				}
			]")
		end

	test_get_user_id_health_check
		note
			testing: "[
				covers/{AIA_REQUEST_MANAGER}.response,
				covers/{EL_SETTABLE_FROM_JSON_STRING}.as_json
			]"
		local
			request: like new_amazon_request
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "GetUserId",
					"infoField1": "AMAZONTEST"
				}
			]")
			sign (request)
			request_get_user_id_1234 (request, "[
				{
					"response": "OK",
					"userId": ""
				}
			]")
		end

feature -- Authorization

	test_credential_id_equality
		local
			id_1, id_2: AIA_CREDENTIAL_ID
		do
			create id_1.make ("key/date")
			create id_2.make ("key" + "/date")
			assert ("equal", id_1 ~ id_2)
		end

	test_credential_storage
		do
			create credential_list.make (credentials_file_path, new_encrypter)
			assert ("same credential", Credential ~ Credential_list.first)
		end

	test_header_selection
		-- AMAZON_INSTANT_ACCESS_TEST_SET.test_header_selection
		note
			testing: "covers/{FCGI_HTTP_HEADERS}.selected"
		local
			http_table: EL_IMMUTABLE_UTF_8_TABLE; request: FCGI_REQUEST_PARAMETERS
			headers: HASH_TABLE [ZSTRING, STRING];
		do
			create http_table.make_field_map (signed_headers_manifest)
			create request.make_from_utf_8_table (http_table)
			headers := request.headers.selected (Signed_headers, Translater)
			assert ("same count", headers.count = Signed_headers.count)
			assert ("same names", across headers as h all Signed_headers.has (h.key) end)
		end

	test_parse_header_1
		note
			testing: "covers/{AIA_AUTHORIZATION_HEADER}.make_from_string"
		local
			header: AIA_AUTHORIZATION_HEADER
		do
			create header.make_from_string (
				"DTA1-HMAC-SHA256 %
				%SignedHeaders=Content-Type;X-Amz-Date;X-Amz-Dta-Version;X-AMZ-REQUEST-ID, %
	         %Credential=367caa91-cde5-48f2-91fe-bb95f546e9f0/20131207, %
	        	%Signature=87729cb3475859a18b5d9cead0bba82f0f56a85c2a13bed3bc229c6c35e06628"
			)
			assert ("same algorithm", header.algorithm ~ "DTA1-HMAC-SHA256")
			assert ("same Signed_headers", header.signed_headers_list ~ Signed_headers)
			assert ("same credential.key", header.credential.key ~ "367caa91-cde5-48f2-91fe-bb95f546e9f0")
			assert ("same credential.date", header.credential.date ~ "20131207")
			assert ("same signature", header.signature ~ "87729cb3475859a18b5d9cead0bba82f0f56a85c2a13bed3bc229c6c35e06628")
		end

	test_sign_and_verify
		note
			testing: "covers/{EL_SETTABLE_FROM_STRING}.set_from_utf_8_table"
		local
			request: like new_amazon_request
			verifier: AIA_VERIFIER
		do
			request := new_amazon_request
			request.set_from_parsed ("[
				HTTP_ACCEPT:
					*/*
				REQUEST_URI:
					/service/foo.php
			]")
			request.set_content ("{%"operation%" : %"bar%"}")

			sign (request)
			create verifier.make (request, Credential_list)

			assert ("request is verified", verifier.is_verified)
		end

feature -- Purchase

	test_purchase_fullfill
		note
			testing: "[
				covers/{AIA_REQUEST_MANAGER}.response,
				covers/{EL_SETTABLE_FROM_JSON_STRING}.as_json,
				covers/{AIA_PURCHASE_REQUEST}.response
			]"
		local
			request: like new_amazon_request; json_response: STRING
			response: AIA_RESPONSE
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "Purchase",
					"reason": "FULFILL",
					"productId": "GamePack1",
					"userId": "123456",
					"purchaseToken": "6f3092e5-0326-42b7-a107-416234d548d8"
				}
			]")
			sign (request)
			json_response := "[
				{
					"response": "FAIL_USER_NOT_ELIGIBLE"
				}
			]"
			Request_manager.purchase.set_new_response (agent purchase_with_ineligible_user)
			response := Request_manager.response (request)
			if attached {AIA_PURCHASE_RESPONSE} response as purchase then
				assert ("no error", not Request_manager.has_error)
				assert ("expected response", purchase.as_json.to_latin_1 ~ json_response)
			else
				failed ("returned AIA_PURCHASE_RESPONSE")
			end
		end

	test_purchase_revoke
		note
			testing: "[
				covers/{AIA_REQUEST_MANAGER}.response,
				covers/{EL_SETTABLE_FROM_JSON_STRING}.as_json,
				covers/{AIA_PURCHASE_REQUEST}.response
			]"
		local
			request: like new_amazon_request; json_response: STRING
		do
			request := new_amazon_request
			request.set_content ("[
				{
					"operation": "Revoke",
					"reason": "CUSTOMER_SERVICE_REQUEST",
					"productId": "GamePack1",
					"userId": "123456",
					"purchaseToken": "6f3092e5-0326-42b7-a107-416234d548d8"
				}
			]")
			sign (request)
			json_response := "[
				{
					"response": "FAIL_INVALID_PURCHASE_TOKEN"
				}
			]"
			Request_manager.revoke_purchase.set_new_response (agent revoke_with_invalid_purchase_token)
			if attached {AIA_REVOKE_RESPONSE} Request_manager.response (request) as l_response then
				assert ("no error", not Request_manager.has_error)
				assert ("expected response", l_response.as_json.to_latin_1 ~ json_response)
			else
				failed ("returned AIA_REVOKE_RESPONSE")
			end
		end

	test_response_code
		do
			assert ("same message", response_enum.name (response_enum.fail_other) ~ "FAIL_OTHER")
		end

feature {NONE} -- Request handlers

	get_user_id_1234 (request: AIA_GET_USER_ID_REQUEST): AIA_GET_USER_ID_RESPONSE
		do
			create Result.make (response_enum.ok)
			Result.set_user_id ("1234")
		end

	purchase_with_ineligible_user (request: AIA_PURCHASE_REQUEST): AIA_PURCHASE_RESPONSE
		do
			check_purchase_fields (request)
			create Result.make (response_enum.fail_user_not_eligible)
		end

	revoke_with_invalid_purchase_token (request: AIA_REVOKE_REQUEST): AIA_REVOKE_RESPONSE
		do
			check_purchase_fields (request)
			create Result.make (response_enum.fail_invalid_purchase_token)
		end

feature {NONE} -- Implementation

	check_purchase_fields (request: AIA_PURCHASE_REQUEST)
		do
			assert ("same", request.product_id ~ "GamePack1")
			assert ("same", request.user_id ~ "123456")
			assert ("same", request.purchase_token ~ "6f3092e5-0326-42b7-a107-416234d548d8")
		end

feature {NONE} -- Implementation

	new_amazon_request: FCGI_REQUEST_PARAMETERS
		do
			create Result.make
			Result.set_from_parsed ("[
				HTTP_HOST:
					amazon.com
				CONTENT_TYPE:
					application/json
				SERVER_PROTOCOL:
					HTTP/1.1
				SERVER_PORT:
					80
				REQUEST_METHOD:
					POST
				REQUEST_URI:
					/
			]")
		end

	new_encrypter: EL_AES_ENCRYPTER
		do
			create Result.make ("abc", 128)
		end

	request_get_user_id_1234 (request: like new_amazon_request; json_response: STRING)
		local
			response: AIA_RESPONSE
		do
			Request_manager.get_user_id.set_new_response (agent get_user_id_1234)
			Request_manager.print_verification (lio, request)
			response := Request_manager.response (request)
			if attached {AIA_GET_USER_ID_RESPONSE} response as user_id_response then
				assert ("no error", not Request_manager.has_error)
				assert ("expected response", user_id_response.as_json.to_latin_1 ~ json_response)

			elseif attached {AIA_FAIL_RESPONSE} response then
				lio.put_labeled_string ("Failure", Request_manager.error_message)
				lio.put_new_line
				failed ("returned AIA_GET_USER_ID_RESPONSE")
			else
				lio.put_line ("response not attached")
				failed ("returned AIA_GET_USER_ID_RESPONSE")
			end
		end

	sign (request: like new_amazon_request)
		local
			signer: AIA_SIGNER
		do
			create signer.make (request, credential)
			signer.sign
		end

	signed_headers_manifest: STRING
		-- content_type:
		--		1
		-- x_amz_date:
		-- 	2
		-- ..
		local
			header, http_name: STRING; s: EL_STRING_8_ROUTINES
		do
			create Result.make (Signed_headers.character_count * 2)
			across Signed_headers as list loop
				header := list.item
				if Result.count > 0 then
					Result.append_character ('%N')
				end
				http_name := "HTTP_" + header.as_upper
				s.replace_character (http_name, '-', '_')
				Result.append (http_name)
				Result.append (":%N%T")
				Result.append_integer (list.cursor_index)
			end
		end

feature {NONE} -- Internal attributes

	credential_list: AIA_STORABLE_CREDENTIAL_LIST

feature {NONE} -- Constants

	Credential: AIA_CREDENTIAL
		once
			create Result.make ("SECRET", "PUBLIC")
		end

	Credentials_file_path: FILE_PATH
		once
			Result := Work_area_dir + "credentials.dat"
		end

	Signed_headers: EL_STRING_8_LIST
		once
			Result := "Content-Type, X-Amz-Date, X-Amz-Dta-Version, X-AMZ-REQUEST-ID"
		end

	Translater: EL_KEBAB_CASE_TRANSLATER
		once
			create Result.make
		end
end