note
	description: "Summary description for {EL_ZSTRING_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-18 15:36:19 GMT (Monday 18th January 2016)"
	revision: "1"

class
	EL_ZSTRING_LINE_READER

inherit
	EL_LINE_READER [EL_ZSTRING_IO_MEDIUM]
		redefine
			set_line_from_file
		end

feature -- Element change

	set_line_from_file (source: EL_ZSTRING_IO_MEDIUM)
		do
			source.read_line
			line := source.last_string
		end

feature {NONE} -- Implementation

	set_line (raw_line: STRING)
		do
		end
end