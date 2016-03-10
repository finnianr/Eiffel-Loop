note
	description: "Summary description for {EL_GVFS_FILE_LIST_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GVFS_FILE_LIST_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			find_line as read_file
		redefine
			default_create, read_file
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make ( "[
				gvfs-ls "$uri"
			]")
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

	read_file (line: ASTRING)
		do
			file_list.extend (line)
		end

end
