note
	description: "[
		Parses output of command:
		
			gvfs-ls "$uri" | grep -c "^.*$"
	]"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-25 11:52:01 GMT (Saturday 25th March 2023)"
	revision: "5"

class
	EL_GVFS_FILE_COUNT_COMMAND

inherit
	EL_GVFS_URI_COMMAND
		redefine
			find_line, reset
		end

create
	make

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

feature {NONE} -- Constants

	Template: STRING = "gvfs-ls $uri"

end