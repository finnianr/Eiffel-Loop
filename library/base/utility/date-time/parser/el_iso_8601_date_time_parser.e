note
	description: "[$source EL_DATE_TIME_PARSER] for ISO-8601 formats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-15 13:30:17 GMT (Sunday 15th August 2021)"
	revision: "1"

class
	EL_ISO_8601_DATE_TIME_PARSER

inherit
	EL_DATE_TIME_PARSER
		redefine
			make, parse_source
		end

create
	make

feature {NONE} -- Initialization

	make (cs: EL_ISO_8601_DATE_TIME_CODE_STRING)
		do
			precursor (cs)
			converter := cs.converter
		end

feature -- Status setting

	parse_source (s: STRING)
		do
			Precursor (converter.modified_string (s))
		end

feature {NONE} -- Internal attributes

	converter: EL_DATE_TIME_CONVERSION
end