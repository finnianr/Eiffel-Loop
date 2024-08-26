note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"
	notes: "Command option: -hacker_intercept_test_service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 8:19:12 GMT (Monday 26th August 2024)"
	revision: "1"

class
	HACKER_INTERCEPT_TEST_SERVICE_APP

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [HACKER_INTERCEPT_TEST_SERVICE]
		redefine
			visible_types
		end

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
		local
			default_config_path: FILE_PATH
		do
			Result := agent {like command}.make (default_config_path)
		end

	log_filter_set: EL_LOG_FILTER_SET [
		like Current, HACKER_INTERCEPT_TEST_SERVICE
	]
		do
			create Result.make
		end

	visible_types: TUPLE [FCGI_REQUEST_BROKER, EL_CAPTURED_OS_COMMAND]
		do
			create Result
		end

end