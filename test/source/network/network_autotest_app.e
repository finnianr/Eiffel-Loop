note
	description: "Finalized executable tests for library [./library/network.html network.ecf]"
	notes: "[
		Command option: `-simple_client_server_autotest'

		**Test Sets**

			[$source SIMPLE_CLIENT_SERVER_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-30 10:18:18 GMT (Monday 30th October 2023)"
	revision: "33"

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

	compile_network_ecf: TUPLE [SINGLE_TRANSACTION, FILE_PROTOCOL]
		do
			create Result
		end

	compile: TUPLE [
		EL_COOKIE_STRING_8,
		EL_NETWORK_DEVICE_IMP,
		EL_WAYBACK_CLOSEST,
		EL_FIREWALL_STATUS,
		EL_FTP_FILE_SYNC_MEDIUM,
		EL_FTP_WEBSITE,
		EL_XML_NETWORK_MESSENGER,
		EL_WEB_LOG_PARSER_COMMAND,
		FTP_TEST_SET
	]
		do
			create Result
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, SIMPLE_SERVER_THREAD, SIMPLE_CLIENT_SERVER_TEST_SET
	]
		do
			create Result.make
		end

	visible_types: TUPLE [SIMPLE_COMMAND_HANDLER, EL_FTP_PROTOCOL]
		do
			create Result
		end

end