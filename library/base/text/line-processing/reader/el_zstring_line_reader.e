note
	description: "Summary description for {EL_ZSTRING_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 13:08:19 GMT (Sunday 3rd September 2017)"
	revision: "2"

class
	EL_ZSTRING_LINE_READER

inherit
	EL_LINE_READER [EL_ZSTRING_IO_MEDIUM]
		redefine
			append_next_line
		end

feature -- Element change

	append_next_line (line: ZSTRING; file: EL_ZSTRING_IO_MEDIUM)
		do
			file.read_line
			line.append (file.last_string)
		end

feature {NONE} -- Implementation

	append_to_line (line: ZSTRING; raw_line: STRING)
		do
		end
end
