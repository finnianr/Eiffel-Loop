note
	description: "Gvfs file list command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_GVFS_FILE_LIST_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			make as make_command,
			find_line as read_file
		redefine
			read_file, reset
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create file_list.make_with_count (10)
			make_command ("gvfs-ls $uri")
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

end