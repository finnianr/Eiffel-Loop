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
	date: "2024-07-09 9:12:40 GMT (Tuesday 9th July 2024)"
	revision: "8"

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

	count: INTEGER
		-- file count

feature -- Element change

	reset
		do
			Precursor
			count := 0
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
			count := count + 1
		end

feature {NONE} -- Constants

	Default_template: STRING = "gvfs-ls $uri"

end