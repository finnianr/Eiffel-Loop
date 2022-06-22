note
	description: "Zstring line reader"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

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
			line.append (file.last_string)
		end

feature {NONE} -- Implementation

	append_to_line (line: ZSTRING; raw_line: STRING)
		do
		end
end
