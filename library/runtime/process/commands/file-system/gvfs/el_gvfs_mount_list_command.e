note
	description: "Summary description for {EL_GVFS_VOLUME_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_GVFS_MOUNT_LIST_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			find_line as find_mount
		redefine
			default_create, find_mount, call
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			create uri_root_table.make_equal (3)
			make ("gvfs-mount --list")
		end

feature -- Access

	uri_root_table: EL_ASTRING_HASH_TABLE [EL_DIR_URI_PATH]

feature -- Status change

	reset
		do
			uri_root_table.wipe_out
		end

feature {NONE} -- Line states

	find_mount (line: ASTRING)
		local
			pos_colon, pos_arrow: INTEGER
			volume_name: ASTRING
		do
			if line.starts_with ("Mount(") then
				pos_colon := line.index_of (':', 1)
				pos_arrow := line.substring_index ("->", pos_colon)
				volume_name := line.substring (pos_colon + 2, pos_arrow - 2)
				uri_root_table [volume_name] := line.substring (pos_arrow + 3, line.count)
			end
		end

feature {NONE} -- Implementation

	call (line: ASTRING)
		do
			line.left_adjust
			Precursor (line)
		end

end
