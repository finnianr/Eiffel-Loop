note
	description: "Finalized executable tests for library [./library/http-client.html http-client.ecf]"
	notes: "[
		Command option: `-http_client_autotest'

		**Test Sets**

			${HTTP_CONNECTION_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 14:38:16 GMT (Thursday 11th July 2024)"
	revision: "68"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [HTTP_CONNECTION_TEST_SET]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_CACHED_XML_HTTP_CONNECTION]
		do
			create Result
		end
end