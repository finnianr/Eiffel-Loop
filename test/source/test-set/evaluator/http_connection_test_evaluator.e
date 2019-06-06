note
	description: "Http connection test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-06 9:16:19 GMT (Thursday 6th June 2019)"
	revision: "3"

class
	HTTP_CONNECTION_TEST_EVALUATOR

inherit
	EL_EQA_TEST_SET_EVALUATOR [HTTP_CONNECTION_TEST_SET]

feature {NONE} -- Implementation

	test_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["http_hash_table",						agent item.test_http_hash_table],
				["download_image_and_headers",		agent item.test_download_image_and_headers],
				["cookies",									agent item.test_cookies],
				["image_headers",							agent item.test_image_headers],
				["documents_download",					agent item.test_documents_download],
				["download_document_and_headers",	agent item.test_download_document_and_headers],
				["http_post",								agent item.test_http_post]
			>>)
		end
end
