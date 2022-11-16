note
	description: "Date-time parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

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