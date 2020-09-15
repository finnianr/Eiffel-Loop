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
	date: "2020-09-15 10:20:59 GMT (Tuesday 15th September 2020)"
	revision: "63"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [HTTP_CONNECTION_TEST_SET]]

create
	make

end