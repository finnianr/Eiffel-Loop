note
	description: "Table of GVFS mounts. Example: `E2105 -> mtp://[usb:003,005]/'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-06 10:21:28 GMT (Wednesday 6th January 2021)"
	revision: "11"

class
	EL_GVFS_MOUNT_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [EL_URI]
		rename
			make as make_with_array
		end

	EL_GVFS_OS_COMMAND
		rename
			make as make_command,
			find_line as find_mount
		export
			{NONE} all
		undefine
			copy, default_create, is_equal
		redefine
			find_mount
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (3)
			make_command ("gvfs-mount --list")
			execute
		end

feature {NONE} -- Line states

	find_mount (line: ZSTRING)
		local
			f: EL_COLON_FIELD_ROUTINES; split_list: EL_SPLIT_STRING_8_LIST
		do
			line.left_adjust
			if line.starts_with (Text_mount) then
				create split_list.make (f.value (line), Arrow_symbol)
				if split_list.count = 2 then
					put (split_list.last_item (True), split_list.first_item (True))
				end
			end
		end

feature {NONE} -- Constants

	Text_mount: ZSTRING
		once
			Result := "Mount("
		end

	Arrow_symbol: ZSTRING
		once
			Result := " -> "
		end
end