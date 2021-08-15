note
	description: "Optimized string conversion for [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-15 10:44:43 GMT (Sunday 15th August 2021)"
	revision: "2"

class
	EL_TIME

inherit
	TIME
		rename
			make_from_string as make_with_format,
			make_from_string_default as make_from_string
		undefine
			make_with_format, formatted_out, time_valid
		redefine
			default_format_string
		end

	EL_DATE_TIME_UTILITY
		rename
			input_valid as time_valid,
			check_case as do_nothing_1
		redefine
			do_nothing_1
		end

create
	make, make_fine, make_now, make_now_utc, make_by_seconds, make_by_fine_seconds,
	make_with_format, make_from_string, make_by_compact_time

feature {NONE} -- Initialization

	make_with_parser (parser: EL_DATE_TIME_PARSER)
		do
			make_fine (parser.hour, parser.minute, parser.fine_second)
		end

feature -- Access

	default_format_string: STRING
			-- Default output format string
		do
			Result := Date_time_tools.time_default_format_string
		end

feature -- Status query

	same_as (other: TIME): BOOLEAN
		do
			Result := compact_time = other.compact_time
		end

feature {NONE} -- Implementation

	do_nothing_1 (format, str: STRING; start_index: INTEGER)
		do
		end

	to_shared_date_time: DATE_TIME
		do
			Result := Once_date_time
			Result.time.make_by_fine_seconds (fine_seconds)
		end

	valid_string_for_code (str: STRING; code: EL_DATE_TIME_CODE_STRING): BOOLEAN
		do
			Result := code.precise_time and code.correspond (str) and then code.is_time (str)
		end
end