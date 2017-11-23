note
	description: "Summary description for {AMAZON_INSTANT_ACCESS_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-10 15:34:07 GMT (Friday 10th November 2017)"
	revision: "1"

class
	AMAZON_INSTANT_ACCESS_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_STRING_8
		undefine
			default_create
		end

feature -- Tests

	test_parse_header_1
		note
			testing: "covers/{AIA_AUTHORIZATION_HEADER}.parse"
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

	test_credential_id_equality
		local
			id_1, id_2: AIA_CREDENTIAL_ID
		do
			create id_1.make ("key/date")
			create id_2.make ("key" + "/date")
			assert ("equal", id_1 ~ id_2)
		end

	test_header_selection
		note
			testing: "covers/{FCGI_HTTP_HEADERS}.selected"
		local
			http_table: HASH_TABLE [ZSTRING, STRING]
			http_name: STRING; request: FCGI_REQUEST_PARAMETERS
			headers: HASH_TABLE [ZSTRING, STRING]
		do
         create http_table.make (5)
			from Signed_headers.start until Signed_headers.after loop
				http_name := Signed_headers.item
				String_8.replace_character (http_name, '-', '_')
				http_name.prepend ("HTTP_")
				http_name.to_upper
				http_table.extend (Signed_headers.index.out, http_name)
				Signed_headers.forth
			end
			create request.make_from_table (http_table)
			headers := request.headers.selected (Signed_headers)
			assert ("same count", headers.count = Signed_headers.count)
			assert ("same names", across headers as h all Signed_headers.has (h.key) end)
		end

	test_sign_and_verify
		local
			table: HASH_TABLE [ZSTRING, STRING]; content: STRING
			request: FCGI_REQUEST_PARAMETERS; credential: AIA_CREDENTIAL
			credential_list: EL_ARRAYED_LIST [AIA_CREDENTIAL]
			signer: AIA_SIGNER; verifier: AIA_VERIFIER
		do
			create table.make (7)
			table	["HTTP_HOST"] := "amazon.com"
			table	["SERVER_PROTOCOL"] := "HTTP/1.1"
			table	["SERVER_PORT"] := "80"
			table	["REQUEST_URI"] := "/service/foo.php"
			table	["REQUEST_METHOD"] := "POST"
			table	["HTTP_ACCEPT"] := "*/*"
			table	["CONTENT_TYPE"] := "application/json"

			create request.make_from_table (table)
			request.set_content ("{%"operation%" : %"bar%"}")

			create credential.make ("SECRET", "PUBLIC")
			create signer.make (request, credential)
			signer.sign

			create credential_list.make_from_array (<< credential >>)

			create verifier.make (request, credential_list)

			assert ("request is verified", verifier.is_verified)
		end

feature {NONE} -- Constants

	Signed_headers: EL_SPLIT_ZSTRING_LIST
		once
			create Result.make ("Content-Type;X-Amz-Date;X-Amz-Dta-Version;X-AMZ-REQUEST-ID", ";")
		end
end
