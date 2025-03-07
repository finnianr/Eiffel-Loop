note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating dynamic firewall rule blocking IP address
	]"
	notes: "[
		USAGE: 
			el_test -hacker_intercept_test_service -logging -config <config-path>
		
		OR USE
		
			. run/hacker_intercept_test_service.sh myching
			. run/hacker_intercept_test_service.sh matryoshka
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-07 8:34:42 GMT (Friday 7th March 2025)"
	revision: "4"

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
				required_argument ("config", "Path to configuration file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

	log_filter_set: EL_LOG_FILTER_SET [like Current, TESTABLE_404_INTERCEPT_SERVICE]
		do
			create Result.make
			Result.show_selected ({TESTABLE_404_INTERCEPT_SERVLET}, "serve")
		end

end