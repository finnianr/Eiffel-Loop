note
	description: "[
		Table of GVFS mounts as for example:
			
			E2105 -> mtp://[usb:003,005]/
	]"
	notes: "[
		GVFS stands for [https://www.commandlinux.com/man-page/man7/gvfs.7.html GIO virtual file system]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-25 11:51:45 GMT (Saturday 25th March 2023)"
	revision: "18"

class
	EL_GVFS_MOUNT_TABLE

inherit
	EL_GVFS_OS_COMMAND [TUPLE]
		rename
			find_line as find_mount
		export
			{NONE} all
		undefine
			copy, default_create, is_equal
		redefine
			make, find_mount
		end

	EL_ZSTRING_HASH_TABLE [EL_URI]
		rename
			make as make_with_array
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_equal (3)
			Precursor
			execute
		end

feature {NONE} -- Line states

	find_mount (line: ZSTRING)
		local
			f: EL_COLON_FIELD_ROUTINES; split_list: EL_SPLIT_STRING_8_LIST
		do
			line.left_adjust
			if line.starts_with (Text_mount) then
				create split_list.make_by_string (f.value (line), Arrow_symbol)
				if split_list.count = 2 then
					put (split_list.last_item_copy, split_list.first_item_copy)
				end
			end
		end

feature {NONE} -- Constants

	Arrow_symbol: ZSTRING
		once
			Result := " -> "
		end

	Template: STRING = "gvfs-mount --list"

	Text_mount: ZSTRING
		once
			Result := "Mount("
		end

end