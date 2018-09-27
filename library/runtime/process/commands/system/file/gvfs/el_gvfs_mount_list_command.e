note
	description: "Gvfs mount list command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:15 GMT (Thursday 20th September 2018)"
	revision: "5"

class
	EL_GVFS_MOUNT_LIST_COMMAND

inherit
	EL_GVFS_OS_COMMAND
		rename
			make as make_command,
			find_line as find_mount
		redefine
			find_mount, call, reset
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create uri_root_table.make_equal (3)
			make_command ("gvfs-mount --list")
		end

feature -- Access

	uri_root_table: EL_ZSTRING_HASH_TABLE [EL_DIR_URI_PATH]

feature -- Status change

	reset
		do
			uri_root_table.wipe_out
		end

feature {NONE} -- Line states

	find_mount (line: ZSTRING)
		local
			pos_colon, pos_arrow: INTEGER
			volume_name: ZSTRING
		do
			if line.starts_with (Text_mount) then
				pos_colon := line.index_of (':', 1)
				pos_arrow := line.substring_index (Arrow_symbol, pos_colon)
				volume_name := line.substring (pos_colon + 2, pos_arrow - 2)
				uri_root_table [volume_name] := line.substring (pos_arrow + 3, line.count)
			end
		end

feature {NONE} -- Implementation

	call (line: ZSTRING)
		do
			line.left_adjust
			Precursor (line)
		end

feature {NONE} -- Constants

	Text_mount: ZSTRING
		once
			Result := "Mount("
		end

	Arrow_symbol: ZSTRING
		once
			Result := "->"
		end
end