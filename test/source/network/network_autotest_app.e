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
	date: "2021-06-16 8:50:56 GMT (Wednesday 16th June 2021)"
	revision: "17"

class
	NETWORK_AUTOTEST_APP

inherit
	EL_REGRESSION_AUTOTEST_SUB_APPLICATION [SIMPLE_CLIENT_SERVER_TEST_SET, NETWORK_TEST_SET]
		redefine
			description, visible_types, log_filter_set
		end

create
	make

feature {NONE} -- Implementation

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

feature {NONE} -- Constants

	Description: STRING = "Tests for library network.ecf"

end