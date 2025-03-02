note
	description: "Finalized executable tests for library [./library/http-client.html http-client.ecf]"
	notes: "[
		Command option: `-http_client_autotest'

		**Test Sets**

			${HTTP_CONNECTION_TEST_SET}
			${WEB_LOG_ENTRY_TEST_SET}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-02 10:30:14 GMT (Sunday 2nd March 2025)"
	revision: "70"

class
	HTTP_CLIENT_AUTOTEST_APP

inherit
	EL_AUTOTEST_APPLICATION [
		HTTP_CONNECTION_TEST_SET,
		WEB_LOG_ENTRY_TEST_SET
	]

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [
		EL_CACHED_XML_HTTP_CONNECTION,
		EL_MODULE_WEB_ARCHIVE,
		EL_TRAFFIC_ANALYSIS_SHELL_MENU
	]
		do
			create Result
		end
end