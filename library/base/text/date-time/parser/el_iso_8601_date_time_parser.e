note
	description: "${EL_DATE_TIME_PARSER} for ISO-8601 formats"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "2"

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