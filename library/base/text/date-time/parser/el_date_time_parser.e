note
	description: "Date-time parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-03 13:35:04 GMT (Sunday 3rd November 2024)"
	revision: "9"

class
	EL_DATE_TIME_PARSER

inherit
	DATE_TIME_PARSER
		rename
			make as make_parser
		export
			{NONE} parse, set_source_string
		end

create
	make, make_from_string

convert
	make_from_string ({STRING})

feature {NONE} -- Initialization

	make (cs: EL_DATE_TIME_CODE_STRING)
		do
			make_parser (cs.code_table)
			days := cs.days
			months := cs.months
			base_century := cs.base_century
		end

	make_from_string (format: STRING_8)
		do
			make (create {EL_DATE_TIME_CODE_STRING}.make (format))
		end

feature -- Basic operations

	parse_source (s: STRING)
		do
			source_string := s
			parse
		end

feature -- Conversion

	to_ordered_compact_date (s: STRING): INTEGER
		-- Year, month, day coded for fast comparison between dates.
		do
			parse_source (s)
			Once_date.set_with_parser (Current)
			Result := Once_date.ordered_compact_date
		end

	to_compact_time (s: STRING): INTEGER
		-- Hour, minute, second coded.
		do
			parse_source (s)
			Once_time.set_with_parser (Current)
			Result := Once_time.compact_time
		end

feature {NONE} -- Constants

	Once_date: EL_DATE
		once
			create Result.make_default
		end

	Once_time: EL_TIME
		once
			create Result.make_default
		end

end