note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating dynamic firewall rule blocking IP address
	]"
	notes: "Command option: -hacker_intercept_test_service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-14 17:41:58 GMT (Friday 14th February 2025)"
	revision: "2"

class
	HACKER_INTERCEPT_TEST_SERVICE_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [TESTABLE_404_INTERCEPT_SERVICE]

create
	make

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("config", "Path to configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, TESTABLE_404_INTERCEPT_SERVICE, TESTABLE_404_INTERCEPT_SERVLET
	]
		do
			create Result.make
		end

end