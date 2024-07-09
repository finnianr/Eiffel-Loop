note
	description: "GVFS command to remove a file"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-09 9:13:21 GMT (Tuesday 9th July 2024)"
	revision: "9"

class
	EL_GVFS_REMOVE_FILE_COMMAND

inherit
	EL_GVFS_URI_COMMAND
		redefine
			ignore
		end

create
	make

feature {NONE} -- Implementation

	ignore (a_error: ZSTRING): BOOLEAN
		do
			Result := is_file_not_found (a_error)
		end

feature {NONE} -- Constants

	Default_template: STRING = "gvfs-rm $uri"
end