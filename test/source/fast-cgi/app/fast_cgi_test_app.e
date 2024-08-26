note
	description: "Command line interface to ${FAST_CGI_TEST_SERVICE}"
	notes: "[
		Command switch: `-fast_cgi_test'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 9:00:06 GMT (Monday 26th August 2024)"
	revision: "8"

class
	FAST_CGI_TEST_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [FAST_CGI_TEST_SERVICE]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		local
			n16: NATURAL_16
		do
			Result := <<
				optional_argument ("port", "Port number to listen on", << within_range (1 |..| n16.Max_value) >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {FAST_CGI_TEST_SERVICE}.make_port (8000)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		FAST_CGI_TEST_APP, FAST_CGI_TEST_SERVICE
	]
		do
			create Result.make
		end

end