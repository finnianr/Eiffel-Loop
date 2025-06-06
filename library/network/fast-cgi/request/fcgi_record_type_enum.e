note
	description: "[
		Enumeration of [https://fast-cgi.github.io/spec#8-types-and-constants Fast-CGI header record types].

			#define FCGI_BEGIN_REQUEST       1
			#define FCGI_ABORT_REQUEST       2
			#define FCGI_END_REQUEST         3
			#define FCGI_PARAMS              4
			#define FCGI_STDIN               5
			#define FCGI_STDOUT              6
			#define FCGI_STDERR              7
			#define FCGI_DATA                8
			#define FCGI_GET_VALUES          9
			#define FCGI_GET_VALUES_RESULT  10
			#define FCGI_UNKNOWN_TYPE       11
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 12:23:10 GMT (Wednesday 30th April 2025)"
	revision: "10"

class
	FCGI_RECORD_TYPE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as Snake_case_upper
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields (field_list: EL_FIELD_LIST)
		do
			begin_request := 1
			abort_request := 2
			end_request := 3
			params := 4
			stdin := 5
			stdout := 6
			stderr := 7
			data := 8
			get_values := 9
			get_values_result := 10
			unknown_type := 11
		end

feature -- Access

	begin_request: NATURAL_8

	abort_request: NATURAL_8

	end_request: NATURAL_8

	params: NATURAL_8

	stdin: NATURAL_8

	stdout: NATURAL_8

	stderr: NATURAL_8

	data: NATURAL_8

	get_values: NATURAL_8

	get_values_result: NATURAL_8

	unknown_type: NATURAL_8

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end

end