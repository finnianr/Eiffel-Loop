note
	description: "GVFS command to detect if file exists"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:12:48 GMT (Tuesday 9th July 2024)"
	revision: "9"

class
	EL_GVFS_FILE_EXISTS_COMMAND

inherit
	EL_GVFS_URI_COMMAND
		redefine
			ignore, find_line, reset
		end

create
	make

feature -- Access

	file_exists: BOOLEAN

feature -- Element change

	reset
		do
			Precursor
			file_exists := False
		end

feature {NONE} -- Line states

	find_line (line: ZSTRING)
		do
			file_exists := True
			state := final
		end

feature {NONE} -- Implementation

	ignore (a_error: ZSTRING): BOOLEAN
		do
			Result := is_file_not_found (a_error)
		end

feature {NONE} -- Constants

	Default_template: STRING = "gvfs-info -a standard::type $uri"

end