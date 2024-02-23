note
	description: "Optimized string conversion for ${TIME}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-02-23 9:58:05 GMT (Friday 23rd February 2024)"
	revision: "6"

class
	EL_DATE

inherit
	DATE
		rename
			make_from_string as make_with_format,
			make_from_string_with_base as make_with_format_and_base,
			make_from_string_default as make_from_string,
			make_from_string_default_with_base as make_from_string_with_base
		undefine
			make_with_format, formatted_out, date_valid, make_now, make_now_utc
		redefine
			default_format_string
		end

	EL_TIME_DATE_I
		rename
			input_valid as date_valid
		end

create
	make, make_default, make_now, make_now_utc,
	make_month_day_year, make_day_month_year, make_by_days,
	make_with_format, make_with_format_and_base, make_from_string, make_from_string_with_base,
	make_by_compact_date, make_by_ordered_compact_date

feature {NONE} -- Initialization

	make_default
		do
			make_by_days (0)
		end

	make_with_parser (a_parser: EL_DATE_TIME_PARSER)
		do
			make (a_parser.year, a_parser.month, a_parser.day)
		end

feature -- Access

	default_format_string: STRING
			-- Default output format string
		do
			Result := Date_time_tools.date_default_format_string
		end

feature -- Status query

	same_as (other: DATE): BOOLEAN
		do
			Result := ordered_compact_date = other.ordered_compact_date
		end

feature {NONE} -- Implementation

	to_shared_date_time: DATE_TIME
		do
			Result := Once_date_time
			Result.date.make_by_ordered_compact_date (ordered_compact_date)
		end

	update_with (system: EL_SYSTEM_TIME)
		do
			make (system.year_now, system.month_now, system.day_now)
		end

	valid_string_for_code (str: STRING; code: EL_DATE_TIME_CODE_STRING): BOOLEAN
		do
			Result := code.precise_date and code.correspond (str) and then code.is_date (str)
		end

end