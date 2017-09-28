note
	description: "Summary description for {EL_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-09-03 13:21:29 GMT (Sunday 3rd September 2017)"
	revision: "2"

deferred class
	EL_LINE_READER [F -> FILE]

feature -- Element change

	append_next_line (line: ZSTRING; file: F)
		require
			source_open: file.is_open_read
			line_available: not file.after
		do
			file.read_line
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
