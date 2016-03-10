note
	description: "Summary description for {EL_GVFS_FILE_LIST_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:08:12 GMT (Wednesday 16th December 2015)"
	revision: "3"

class
	EL_GVFS_FILE_LIST_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			find_line as read_file
		redefine
			default_create, read_file, reset
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make ( "gvfs-ls $uri")
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

end
