note
	description: "Line reader"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_LINE_READER [F -> FILE]

feature -- Element change

	append_next_line (line: ZSTRING; file: F)
		require
			source_open: file.is_open_read
			line_available: not file.after
		do
			append_to_line (line, file.last_string)
			line.prune_all_trailing ('%R')
		end

feature {NONE} -- Implementation

	append_to_line (line: ZSTRING; raw_line: STRING)
		require
			empty_line: line.is_empty
		deferred
		end


end
