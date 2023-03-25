note
	description: "GVFS command to obtain list of files in directory"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-25 11:52:15 GMT (Saturday 25th March 2023)"
	revision: "7"

class
	EL_GVFS_FILE_LIST_COMMAND

inherit
	EL_GVFS_URI_COMMAND
		rename
			find_line as read_file
		redefine
			make_default, read_file, reset
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create file_list.make_with_count (10)
		end

feature -- Access

	file_list: EL_FILE_PATH_LIST

feature -- Element change

	reset
		do
			file_list.wipe_out
		end

feature {NONE} -- Line states

	read_file (line: ZSTRING)
		do
			file_list.extend (line)
		end

feature {NONE} -- Constants

	Template: STRING = "gvfs-ls $uri"
end