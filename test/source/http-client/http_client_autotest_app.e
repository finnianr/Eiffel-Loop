note
	description: "Finalized executable tests for library [./library/http-client.html http-client.ecf]"
	notes: "[
		Command option: `-http_client_autotest'

		**Test Sets**

			[$source HTTP_CONNECTION_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:55:56 GMT (Friday 14th February 2020)"
	revision: "62"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [HTTP_CONNECTION_TEST_SET]
		do
			create Result
		end

end
