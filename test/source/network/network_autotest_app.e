note
	description: "Finalized executable tests for library [./library/network.html network.ecf]"
	notes: "[
		Command option: `-simple_client_server_autotest'

		**Test Sets**

			[$source SIMPLE_CLIENT_SERVER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-05 15:31:08 GMT (Sunday 5th June 2022)"
	revision: "22"

class
	NETWORK_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [
		FTP_TEST_SET,
		SIMPLE_CLIENT_SERVER_TEST_SET,
		NETWORK_TEST_SET
	]
		redefine
			log_filter_set, visible_types
		end

create
	make

feature {NONE} -- Implementation

	compile: TUPLE [EL_XML_NETWORK_MESSENGER]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, SIMPLE_SERVER_THREAD, SIMPLE_CLIENT_SERVER_TEST_SET
	]
		do
			create Result.make
		end

	visible_types: TUPLE [SIMPLE_COMMAND_HANDLER]
		do
			create Result
		end

end