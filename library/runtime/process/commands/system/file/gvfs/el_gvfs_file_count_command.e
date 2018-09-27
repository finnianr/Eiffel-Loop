note
	description: "[
		Parses output of command
			gvfs-ls "$uri" | grep -c "^.*$"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "3"

class
	EL_GVFS_FILE_COUNT_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			make as make_command
		redefine
			find_line, reset
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_name ("gvfs-ls.count", "gvfs-ls $uri")
		end

feature -- Access

	is_empty: BOOLEAN
		do
			Result := count = 0
		end

	count: INTEGER

feature -- Element change

	reset
		do
			count := 0
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
			count := count + 1
		end

end