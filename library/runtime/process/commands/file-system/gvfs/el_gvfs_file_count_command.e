note
	description: "[
		Parses output of command: gvfs-ls "$uri" | grep -c "^.*$"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:08:03 GMT (Wednesday 16th December 2015)"
	revision: "3"

class
	EL_GVFS_FILE_COUNT_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		redefine
			default_create, find_line, reset
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
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
