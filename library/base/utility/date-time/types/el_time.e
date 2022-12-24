note
	description: "Optimized string conversion for [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-24 11:36:35 GMT (Saturday 24th December 2022)"
	revision: "5"

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

	EL_TIME_DATE_I
		rename
			input_valid as time_valid,
			check_case as do_nothing_1
		redefine
			do_nothing_1
		end

create
	make, make_fine, make_now, make_now_utc, make_by_seconds, make_by_fine_seconds,
	make_with_format, make_from_string, make_by_compact_time, make_by_compact_decimal

feature {NONE} -- Initialization

	make_by_compact_decimal (a_compact_decimal: NATURAL_64)
		local
			time: EL_TIME_ROUTINES
		do
			time.set_from_compact_decimal (Current, a_compact_decimal)
		ensure
			set: a_compact_decimal = compact_decimal
		end

	make_with_parser (a_parser: EL_DATE_TIME_PARSER)
		do
			make_fine (a_parser.hour, a_parser.minute, a_parser.fine_second)
		end

feature -- Access

	default_format_string: STRING
			-- Default output format string
		do
			Result := Date_time_tools.time_default_format_string
		end

	compact_decimal: NATURAL_64
		local
			time: EL_TIME_ROUTINES
		do
			Result := time.compact_decimal (Current)
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