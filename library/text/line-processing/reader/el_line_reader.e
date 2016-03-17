﻿note
	description: "Summary description for {EL_LINE_READER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:09:05 GMT (Wednesday 16th December 2015)"
	revision: "7"

deferred class
	EL_LINE_READER [F -> FILE]

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_UTF
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			create line.make_empty
		end

feature -- Element change

	set_line_from_file (source: F)
		require
			source_open: source.is_open_read
			line_available: not source.after
		do
			source.read_line
			set_line (source.last_string)
			line.prune_all_trailing ('%R')
		end

	set_line (raw_line: STRING)
		deferred
		end

feature -- Access

	line: ZSTRING

end
