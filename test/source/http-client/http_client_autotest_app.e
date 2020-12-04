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
	date: "2020-12-03 10:39:51 GMT (Thursday 3rd December 2020)"
	revision: "64"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [HTTP_CONNECTION_TEST_SET]

create
	make

end