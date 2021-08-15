note
	description: "Date-time parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-15 15:31:10 GMT (Sunday 15th August 2021)"
	revision: "6"

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
	make

feature {NONE} -- Initialization

	make (cs: EL_DATE_TIME_CODE_STRING)
		do
			make_parser (cs.value)
			days := cs.days
			months := cs.months
			base_century := cs.base_century
		end

feature -- Basic operations

	parse_source (s: STRING)
		do
			source_string := s
			parse
		end
end