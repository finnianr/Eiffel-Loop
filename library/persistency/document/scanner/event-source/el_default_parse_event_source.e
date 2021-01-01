note
	description: "Default parse event source"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-01 14:17:25 GMT (Friday 1st January 2021)"
	revision: "3"

class
	EL_DEFAULT_PARSE_EVENT_SOURCE

inherit
	EL_PARSE_EVENT_SOURCE

create
	make

feature -- Basic operations

	parse_from_lines (a_lines: ITERABLE [READABLE_STRING_GENERAL])
		do
		end

	parse_from_stream (a_stream: IO_MEDIUM)
			-- Parse XML document from input stream.
		do
		end

	parse_from_string (a_string: STRING)
			-- Parse XML document from `a_string'.
		do
		end

end