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
	date: "2022-02-05 14:49:49 GMT (Saturday 5th February 2022)"
	revision: "65"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [HTTP_CONNECTION_TEST_SET]

create
	make

end