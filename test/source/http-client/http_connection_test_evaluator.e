note
	description: "Http connection test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-23 14:57:29 GMT (Thursday 23rd January 2020)"
	revision: "5"

class
	HTTP_CONNECTION_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [HTTP_CONNECTION_TEST_SET]

feature {NONE} -- Implementation

	do_tests
		do
			test ("http_hash_table",					agent item.test_http_hash_table)
			test ("download_image_and_headers",		agent item.test_download_image_and_headers)
			test ("cookies",								agent item.test_cookies)
			test ("image_headers",						agent item.test_image_headers)
			test ("documents_download",				agent item.test_documents_download)
			test ("download_document_and_headers",	agent item.test_download_document_and_headers)
			test ("http_post",							agent item.test_http_post)
		end
end
