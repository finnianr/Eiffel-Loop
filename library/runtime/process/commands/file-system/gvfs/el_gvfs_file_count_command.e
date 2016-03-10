note
	description: "[
		Parses output of command: gvfs-ls "$uri" | grep -c "^.*$"
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GVFS_FILE_COUNT_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			find_line as read_count
		redefine
			default_create, read_count
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			make_with_name ("gvfs-ls.count_lines", "[
				gvfs-ls "$uri" | grep -c "^.*$"
			]")
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

	read_count (line: ASTRING)
		do
			if line.is_integer then
				count := line.to_integer
				state := agent final
			end
		end

end
